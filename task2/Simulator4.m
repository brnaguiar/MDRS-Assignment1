function [PLd , PLv , APDd , APDv , MPDd , MPDv , TT] = Simulator4(lambda,C,f,P,n)
% INPUT PARAMETERS:
%  lambda - packet rate (packets/sec)
%  C      - link bandwidth (Mbps)
%  f      - queue size (Bytes)
%  P      - number of packets (stopping criterium)
%  n      - number of VoIP data flows
% OUTPUT PARAMETERS:
%  PLd  - data packet loss (%)
%  PLv  - VoIP packet loss (%)
%  APDd  - average data packet delay (milliseconds)
%  APDv  - average VoIP packet delay (milliseconds)
%  MPDd  - maximum data packet delay (milliseconds)
%  MPDv  - maximum VoIP packet delay (milliseconds)
%  TT   - transmitted throughput (Mbps)

%Types of package
data = 0;
voip = 1;

%Events:
ARRIVAL= 0;       % Arrival of a packet            
DEPARTURE= 1;     % Departure of a packet

%State variables:
STATE = 0;          % 0 - connection free; 1 - connection bysy
QUEUEOCCUPATION= 0; % Occupation of the queue (in Bytes)
QUEUE= [];          % Size and arriving time instant of each packet in the queue

%Statistical Counters:
TOTALPACKETS= 0;       % No. of packets arrived to the system
LOSTPACKETS= 0;        % No. of packets dropped due to buffer overflow
TRANSMITTEDPACKETS= 0; % No. of transmitted packets
TRANSMITTEDBYTES= 0;   % Sum of the Bytes of transmitted packets
DELAYS= 0;             % Sum of the delays of transmitted packets
MAXDELAY= 0;           % Maximum delay among all transmitted packets

TOTALVOIPPACKETS= 0;        % No. of VoIP packets arrived to the system
LOSTVOIPPACKETS= 0;         % No. of VoIP packets dropped due to buffer overflow
TRANSMITTEDVOIPPACKETS= 0;  % No. of transmitted VoIP packets
TRANSMITTEDVOIPBYTES= 0;    % Sum of the Bytes of transmitted VoIP packets
VOIPDELAYS= 0;              % Sum of the delays of transmitted VoIP packets
VOIPMAXDELAY= 0;            % Maximum delay among all transmitted VoIP packets

% Initializing the simulation clock:
Clock= 0;

% Initializing the List of Events with the first ARRIVAL:
tmp= Clock + exprnd(1/lambda);
EventList = [ARRIVAL, tmp, GeneratePacketSize(), tmp, data];

for x = 1:n
    tmpvi = Clock + rand() * 0.02;
    EventList = [EventList; ARRIVAL, tmpvi, randi(20)+110, tmpvi, voip];
end    

%for n vezes para acrescentar a lista de eventos para meter pacotes voips aleatorios entre 0 e 20 ms

%Simulation loop:
while TRANSMITTEDPACKETS<P               % Stopping criterium
    EventList= sortrows(EventList,2);    % Order EventList by time
    Event= EventList(1,1);               % Get first event and 
    Clock= EventList(1,2);               %   and
    PacketSize= EventList(1,3);          %   associated
    ArrivalInstant= EventList(1,4);      %   parameters.
    Type = EventList(1,5);
    EventList(1,:)= [];                  % Eliminate first event
    switch Event
        case ARRIVAL                     % If first event is an ARRIVAL
            if Type==data
                TOTALPACKETS= TOTALPACKETS+1;
                tmp= Clock + exprnd(1/lambda);
                EventList = [EventList; ARRIVAL, tmp, GeneratePacketSize(), tmp, data];
                if STATE==0
                    STATE= 1;
                    EventList = [EventList; DEPARTURE, Clock + 8*PacketSize/(C*10^6),...
                        PacketSize, Clock, data];
                else
                    if QUEUEOCCUPATION + PacketSize <= f
                        QUEUE = [QUEUE;PacketSize , Clock, data];
                        QUEUEOCCUPATION= QUEUEOCCUPATION + PacketSize;
                    else
                        LOSTPACKETS = LOSTPACKETS + 1;
                    end
                end
            else
                TOTALVOIPPACKETS = TOTALVOIPPACKETS+1;
                tmpv = Clock + rand() * 0.008 + 0.016;
                EventList = [EventList; ARRIVAL, tmpv, randi(20)+110, tmpv, voip];
                if STATE==0
                    STATE= 1;
                    EventList = [EventList; DEPARTURE, Clock + 8*PacketSize/(C*10^6),...
                        PacketSize, Clock, voip];
                else
                    if QUEUEOCCUPATION + PacketSize <= f
                        QUEUE = [QUEUE; PacketSize , Clock, voip];
                        QUEUEOCCUPATION= QUEUEOCCUPATION + PacketSize;
                    else
                        LOSTVOIPPACKETS = LOSTVOIPPACKETS + 1;
                    end
                end
            end
        case DEPARTURE                     % If first event is a DEPARTURE
            if Type==data
                TRANSMITTEDBYTES= TRANSMITTEDBYTES + PacketSize;
                DELAYS= DELAYS + (Clock - ArrivalInstant);
                if Clock - ArrivalInstant > MAXDELAY
                    MAXDELAY= Clock - ArrivalInstant;
                end
                TRANSMITTEDPACKETS= TRANSMITTEDPACKETS + 1;
            else
                TRANSMITTEDVOIPBYTES= TRANSMITTEDVOIPBYTES + PacketSize;
                VOIPDELAYS= VOIPDELAYS + (Clock - ArrivalInstant);
                if Clock - ArrivalInstant > VOIPMAXDELAY
                    VOIPMAXDELAY= Clock - ArrivalInstant;
                end
                TRANSMITTEDVOIPPACKETS= TRANSMITTEDVOIPPACKETS + 1;
            end   
            
            if QUEUEOCCUPATION > 0
                QUEUE = sortrows(QUEUE, 3, "descend");
                EventList = [EventList; DEPARTURE, Clock + 8*QUEUE(1,1)/(C*10^6), QUEUE(1,1), QUEUE(1,2), QUEUE(1,3)];
                QUEUEOCCUPATION= QUEUEOCCUPATION - QUEUE(1,1);
                QUEUE(1,:)= [];
            else
                STATE= 0;
            end     
    end
end

%Performance parameters determination:
PLd= 100*LOSTPACKETS/TOTALPACKETS;      % in %
APDd= 1000*DELAYS/TRANSMITTEDPACKETS;   % in milliseconds
MPDd= 1000*MAXDELAY;                    % in milliseconds

PLv= 100*LOSTVOIPPACKETS/TOTALVOIPPACKETS;      % in %
APDv= 1000*VOIPDELAYS/TRANSMITTEDVOIPPACKETS;   % in milliseconds
MPDv= 1000*VOIPMAXDELAY;                        % in milliseconds

TT= 10^(-6)*TRANSMITTEDBYTES*8/Clock;  % in Mbps

end

function out= GeneratePacketSize()
    aux= rand();
    aux2= [65:109 111:1517];
    if aux <= 0.19
        out= 64;
    elseif aux <= 0.19 + 0.23
        out= 110;
    elseif aux <= 0.19 + 0.23 + 0.17
        out= 1518;
    else
        out = aux2(randi(length(aux2)));
    end
end