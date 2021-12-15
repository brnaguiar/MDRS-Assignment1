% TASK 1
% E

lambda = 1800;
C = [10, 20, 50, 100]; 
P = 10000;

N = 50;
f = 1000000;

per=zeros(N,7); % vetor com N valores de simulação

size = length(C);
sim_output = zeros(N,7,size);

for i= 1:size 
    for j = 1:N
        [per(j,1),per(j,2),per(j,3),per(j,4), per(j, 5), per(j, 6), per(j, 7)] =...
            Simulator1_new(lambda, C(i), f, P);
    end
    sim_output(:, :, i) = per(:, :);
end

%%

alfa = 0.1; % intervalo de confiança 90%

media = mean(sim_output);

term = norminv(1-alfa/2)*sqrt(var(sim_output)/N);

av_pktd64_term = zeros(size,2); 
av_pktd110_term = zeros(size, 2);
av_pktd1518_term = zeros(size, 2);

for it = 1:size
    av_pktd64_term(it,:) = [media(:, 3, it), term(:, 3,it)]; 
    av_pktd110_term(it,:) = [media(:, 4, it), term(:, 4,it)]; 
    av_pktd1518_term(it,:) = [media(:, 5, it), term(:, 5,it)]; 
end

%%
dados64 = zeros(1, size); 
derr64 = zeros(1, size);
dados110 = zeros(1, size);
derr110 = zeros(1, size);
dados1518 = zeros(1, size);
derr1518 = zeros(1, size);   

for it2 = 1:size  
    dados64(1, it2) = av_pktd64_term(it2, 1);
    derr64(1, it2) = av_pktd64_term(it2, 2);      
    
    dados110(1, it2) = av_pktd110_term(it2, 1);
    derr110(1, it2) = av_pktd110_term(it2, 2);    

    dados1518(1, it2) = av_pktd1518_term(it2, 1);
    derr1518(1, it2) = av_pktd1518_term(it2, 2);  

end 

x = 1:size; 
figure("Name", "Average 64Byte-Packet Delay")      
bd64 = bar(x, dados64);
xlabel('Link bandwidth (Mbps )') 
set(gca,'xticklabel',C) 
ylabel('Avg. Packet Delay (ms)')      


hold on
er = errorbar(x, dados64, derr64);
er.Color = [0 0 0];
er.LineStyle = 'none'; 
hold off 

x = 1:size;
figure('Name', 'Average 110Byte-Packet Delay')
bar(x, dados110)
xlabel('Link Bandwidth (Mbps)')
set(gca,'xticklabel',C)    
ylabel('Avg. Packet Delay (ms)') 

hold on
er = errorbar(x, dados110, derr110); 
er.Color = [0 0 0];
er.LineStyle = 'none'; 
hold off 

x = 1:size;
figure('Name', 'Average 1518Byte-Packet Delay')
bar(x, dados1518) 
xlabel('Link Bandwith (Mbps)')   
set(gca,'xticklabel',C)   
ylabel('Avg. Packet Delay (ms)')  

hold on
er = errorbar(x, dados1518, derr1518); 
er.Color = [0 0 0];
er.LineStyle = 'none'; 
hold off 
