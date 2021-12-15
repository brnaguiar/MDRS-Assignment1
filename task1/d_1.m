% TASK 1
% D

% ----task c
lambda = 1800;
size = 64:1518 ;
C = [10, 20, 30, 40]; %1515   

P = 10000;
N = 50;
f = 1000000;

per=zeros(N,4); % vetor com N valores de simulação

bwsize = length(C);
bw_res = zeros(N,4,bwsize);

for i= 1:bwsize 
    for j = 1:N
        [per(j,1),per(j,2),per(j,3),per(j,4)] = Simulator1(lambda, C(i), f, P);
    end
    bw_res(:, :, i) = per(:, :);
end

%%

alfa = 0.1; % intervalo de confiança 90%

media = mean(bw_res);

term = norminv(1-alfa/2)*sqrt(var(bw_res)/N);

av_pktd_term = zeros(bwsize,2); 

for it = 1:bwsize
    av_pktd_term(it,:) = [media(:, 2, it), term(:, 2,it)]; 
end 

%%
dados   = zeros(1, bwsize);   
err = zeros(1, bwsize); 

for it2 = 1:bwsize
    dados(1, it2) = av_pktd_term(it2, 1);
    err(1, it2) = av_pktd_term(it2, 2);  
end 

%%
% ----task d
C = [10*10^6, 20*10^6, 30*10^6, 40*10^6];

prob = zeros(1,1518) ;
prob(size) = (1 - 0.19 - 0.23 - 0.17) / ((length(size) - 3)) ;
prob(64) = 0.19 ;
prob(110) = 0.23 ;
prob(1518) = 0.17 ; 

avgPacketSize = sum(prob(size).*size); 

avgPacketTransmission = (avgPacketSize * 8) ./ C ;

ES = avgPacketTransmission ;
ES2 = zeros(1, length(C)) ;

for i = 1:length(C)
    aux = ((size .* 8) / C(i)).^2 ; 
    ES2(1, i) = sum(prob(size).*aux) ; 
end

avgQueuingDelay = (lambda.*ES2)./(2-(2*lambda.*ES));

avgPktDelay = (avgQueuingDelay + avgPacketTransmission) * 1000 % s -> ms


x = 1:bwsize;   
figure("Name", "Average Packet Delay")
bd = bar(x, [dados; avgPktDelay]);
xlabel('Link bandwidth (Mbps)')  
set(gca,'xticklabel',C./10^6) 
ylabel('Avg. Packet Delay (ms)')
legend('Valor do Simulador','Valor Teórico')  

