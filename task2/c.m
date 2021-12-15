% TASK 2
% C

%%
% b)
lambda = 1500;
C = 10;
f = 1000000;
N = 50;
P = 10000;
n = [10, 20, 30, 40];

per=zeros(N,7); % vetor com N valores de simulação

nsize = length(n);
res = zeros(N,7,nsize);

for i = 1:nsize
    for it = 1:N
        [per(it,1),per(it,2),per(it,3),per(it,4),per(it,5),per(it,6),per(it,7)] = Simulator4(lambda, C, f, P, n(i));
        %PLd , PLv , APDd , APDv , MPDd , MPDv , TT
    end
    res(:, :, i) = per(:, :);
end

%%
alfa = 0.1; % intervalo de confiança 90%
media = mean(res);
term = norminv(1-alfa/2)*sqrt(var(res)/N);

av_pkt_delay_data = zeros(nsize,2); 
av_pkt_delay_voip = zeros(nsize,2); 

for it = 1:nsize
    av_pkt_delay_data(it,:) = [media(:, 3, it), term(:, 3,it)]; 
    av_pkt_delay_voip(it,:) = [media(:, 4, it), term(:, 4,it)]; 
end 

%%
ddados = zeros(1, nsize); 
vdados = zeros(1, nsize);

for it2 = 1:nsize
    ddados(1, it2) = av_pkt_delay_data(it2, 1);
    vdados(1, it2) = av_pkt_delay_voip(it2, 1);
end 

%%
% c)
C = 10e6;

size_VoIP = 110:130;
prob_VoIP = zeros(1, 130);
prob_VoIP(size_VoIP) = 1/length(size_VoIP) ;

size_data = 64:1518 ;
prob_data = zeros(1,1518) ;
prob_data(size_data) = (1 - 0.19 - 0.23 - 0.17) / ((length(size_data) - 3)) ;
prob_data(64) = 0.19 ;
prob_data(110) = 0.23 ;
prob_data(1518) = 0.17 ; 

avgPacketSizeVoIP = sum(prob_VoIP(size_VoIP).*size_VoIP); % 
avgPacketSizeData = sum(prob_data(size_data).*size_data); % 


media_pcktarrivals = ((16/1000)+(24/1000))/2;
lambda_VoIP = (1/media_pcktarrivals).*n;

ES_data = (avgPacketSizeData*8)/C ;%
ES_VoIP = (avgPacketSizeVoIP*8)/C ;%
 
ES2_data = (ES_data^2*2);   
ES2_VoIP = (ES_VoIP^2*2); 

W_VoIP = lambda*ES2_data + (lambda_VoIP.*ES2_VoIP); 
W_VoIP = W_VoIP ./ (2 *(1-lambda_VoIP.*ES_VoIP)); %;
W_VoIP = (W_VoIP + ES_VoIP)*1000      

W_data = lambda*ES2_data + lambda_VoIP.*ES2_VoIP;
W_data = W_data ./ (2*(1-lambda_VoIP.*ES_VoIP).*(1-lambda_VoIP.*ES_VoIP-lambda*ES_data)) ; %;  ; 
W_data = (W_data + ES_data).*1000  


%%
x = 1:nsize; 

figure('Name', 'Average Packet Delay of Data')
bd = bar(x, [ddados; W_data]);
xlabel('Number of VoIP data flows')
set(gca, 'xticklabel',n)
ylabel('Avg. Packet Delay of Data (ms)')
legend('Valor do Simulador','Valor Teórico', "Location", "northwest")  

figure('Name', 'Average Packet Delay of VoIP')
bl = bar(x, [vdados; W_VoIP]);
xlabel('Number of VoIP data flows')
set(gca, 'xticklabel',n)
ylabel('Avg. Packet Delay of VoIP (ms)') 
legend('Valor do Simulador','Valor Teórico', "Location", "northwest")     