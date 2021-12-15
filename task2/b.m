% TASK 2
% B

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
derr = zeros(1, nsize);
vdados = zeros(1, nsize);   
verr = zeros(1, nsize);

for it2 = 1:nsize
    ddados(1, it2) = av_pkt_delay_data(it2, 1);
    derr(1, it2) = av_pkt_delay_data(it2, 2);
    vdados(1, it2) = av_pkt_delay_voip(it2, 1);
    verr(1, it2) = av_pkt_delay_voip(it2, 2);  
end 

%%
x = 1:nsize; 

figure('Name', 'Average Packet Delay of Data')
bd = bar(x, ddados);
xlabel('Number of VoIP data flows')
set(gca, 'xticklabel',n)
ylabel('Avg. Packet Delay of Data (ms)') 

hold on
er = errorbar(x, ddados, derr);
er.Color = [0 0 0];
er.LineStyle = 'none';
hold off

figure('Name', 'Average Packet Delay of VoIP')
bl = bar(x, vdados);
xlabel('Number of VoIP data flows')
set(gca, 'xticklabel',n)
ylabel('Avg. Packet Delay of VoIP (ms)')

hold on
er = errorbar(x, vdados, verr);
er.Color = [0 0 0];
er.LineStyle = 'none';
hold off