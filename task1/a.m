% TASK 1
% A

lambda = [400, 800, 1200, 1600, 2000];
C = 10;
P = 10000;

N = 50;
f = 1000000;

per=zeros(N,4); % vetor com N valores de simulação

lambda_len = length(lambda);
lambda_res = zeros(N,4,lambda_len);

for i= 1:lambda_len
    for j = 1:N
        [per(j,1),per(j,2),per(j,3),per(j,4)] = Simulator1(lambda(i), C, f, P);
    end
    lambda_res(:, :, i) = per(:, :);
end

%%

alfa = 0.1; % intervalo de confiança 90%

media = mean(lambda_res);

term = norminv(1-alfa/2)*sqrt(var(lambda_res)/N);

av_pktd_term = zeros(lambda_len,2);

for it = 1:lambda_len
    av_pktd_term(it,:) = [media(:, 2, it), term(:, 2,it)]; 
end

%%
dados = zeros(1, lambda_len); 
err = zeros(1, lambda_len);

for it2 = 1:lambda_len
    dados(1, it2) = av_pktd_term(it2, 1);
    err(1, it2) = av_pktd_term(it2, 2); 
end

x = 1:lambda_len;
figure('Name', 'Average Packet Delay')
bar(x, dados) 
xlabel('Packet rate (p/s)')
set(gca,'xticklabel',lambda) 
ylabel('Avg. Packet Delay (ms)')

hold on
er = errorbar(x, dados, err);
er.Color = [0 0 0];
er.LineStyle = 'none'; 
hold off 



