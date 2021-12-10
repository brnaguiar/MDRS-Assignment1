% TASK 1
% C

lambda = 1800;
C = [10, 20, 30, 40]; 
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

av_pktd_term %  

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



