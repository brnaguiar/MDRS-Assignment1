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
        [per(j,1),per(j,2),per(j,3),per(j,4), per(j, 5), per(j, 6), per(j, 7)] = Simulator1_new(lambda, C(i), f, P);
    end
    sim_output(:, :, i) = per(:, :);
end

sim_output 

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

av_pktd64_term %
av_pktd110_term
av_pktd1518_term



%%
ddados = zeros(1, qsize); 
derr = zeros(1, qsize);
ldados = zeros(1, qsize);
lerr = zeros(1, qsize);

for it2 = 1:qsize
    ddados(1, it2) = av_pktd_term(it2, 1);
    derr(1, it2) = av_pktd_term(it2, 2);
    ldados(1, it2) = av_pktl_term(it2, 1);
    lerr(1, it2) = av_pktl_term(it2, 2);
end

x = 1:qsize; 
figure("Name", "BRO")
bd = bar(x, ddados);
%hold on
figure
bl = bar(x, ldados);

%hold on
%er = errorbar(x, dados, err);
%er.Color = [0 0 0];
%er.LineStyle = 'none'; 
%hold off



