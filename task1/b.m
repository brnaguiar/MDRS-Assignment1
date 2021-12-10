% TASK 1
% B

lambda = 1800;
C = 10;
P = 10000;

N = 50;
f = [100000, 20000, 10000, 2000];

per=zeros(N,4); % vetor com N valores de simulação

qsize = length(f);
qsize_res = zeros(N,4,qsize);

for i= 1:qsize
    for j = 1:N
        [per(j,1),per(j,2),per(j,3),per(j,4)] = Simulator1(lambda, C, f(i), P);
    end
    qsize_res(:, :, i) = per(:, :);
end

%%

alfa = 0.1; % intervalo de confiança 90%

media = mean(qsize_res);

term = norminv(1-alfa/2)*sqrt(var(qsize_res)/N);

av_pktd_term = zeros(qsize,2);
av_pktl_term = zeros(qsize,2);

for it = 1:qsize
    av_pktd_term(it,:) = [media(:, 2, it), term(:, 2,it)]; 
    av_pktl_term(it,:) = [media(:, 1, it), term(:, 1, it)];
end

av_pktl_term % fila mais pequena -> maior l porque como o queue size é menor, tem que descartar mais pacotes
av_pktd_term % fila mais pequena -> menor delay por causa do first in first out. 
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



