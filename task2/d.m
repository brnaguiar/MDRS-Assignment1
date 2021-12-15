% TASK 2
% D

lambda = 1500;
C = 10;
f = 10000;
N = 50;
P = 10000;
b = 10^-6;
n = [10, 20, 30, 40];

per=zeros(N,7); % vetor com N valores de simulação

nsize = length(n);
res = zeros(N,7,nsize);
   

for i = 1:nsize
    for it = 1:N 
        [per(it,1),per(it,2),per(it,3),per(it,4),per(it,5),per(it,6),per(it,7)] = Simulator3(lambda, C, f, P, n(i));
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
av_pkt_loss_data = zeros(nsize,2); 
av_pkt_loss_voip = zeros(nsize,2); 

for it = 1:nsize
    av_pkt_delay_data(it,:) = [media(:, 3, it), term(:, 3,it)]; 
    av_pkt_delay_voip(it,:) = [media(:, 4, it), term(:, 4,it)]; 
    av_pkt_loss_data(it,:) = [media(:, 1, it), term(:, 1,it)]; 
    av_pkt_loss_voip(it,:) = [media(:, 2, it), term(:, 2,it)]; 
end 

%%
data_delay = zeros(1, nsize);   
data_delay_err = zeros(1, nsize);
voip_delay = zeros(1, nsize);   
voip_delay_err = zeros(1, nsize);
data_loss = zeros(1, nsize);   
data_loss_err = zeros(1, nsize);
voip_loss = zeros(1, nsize);   
voip_loss_err = zeros(1, nsize);

for it2 = 1:nsize
    data_delay(1, it2) = av_pkt_delay_data(it2, 1);
    data_delay_err(1, it2) = av_pkt_delay_data(it2, 2);
    voip_delay(1, it2) = av_pkt_delay_voip(it2, 1);
    voip_delay_err(1, it2) = av_pkt_delay_voip(it2, 2);

    data_loss(1, it2) = av_pkt_loss_data(it2, 1);
    data_loss_err(1, it2) = av_pkt_loss_data(it2, 2);
    voip_loss(1, it2) = av_pkt_loss_voip(it2, 1);
    voip_loss_err(1, it2) = av_pkt_loss_voip(it2, 2); 
end 

%%
x = 1:nsize; 

figure('Name', 'Average Packet Delay of Data')
bdd = bar(x, data_delay);
xlabel('Number of VoIP data flows')
set(gca, 'xticklabel',n)
ylabel('Avg. Packet Delay of Data (ms)')

hold on
er = errorbar(x, data_delay, data_delay_err);
er.Color = [0 0 0];
er.LineStyle = 'none';
hold off

figure('Name', 'Average Packet Delay of VoIP')
bvd = bar(x, voip_delay);
xlabel('Number of VoIP data flows')
set(gca, 'xticklabel',n)
ylabel('Avg. Packet Delay of VoIP (ms)')

hold on
er = errorbar(x, voip_delay, voip_delay_err);
er.Color = [0 0 0];
er.LineStyle = 'none';
hold off

figure('Name', 'Average Packet Loss of Data')
bdl = bar(x, data_loss);
bdl.FaceColor = '#77AC30';
xlabel('Number of VoIP data flows')
set(gca, 'xticklabel',n)
ylabel('Avg. Packet Loss of Data (%)')

hold on
er = errorbar(x, data_loss, data_loss_err);
er.Color = [0 0 0];
er.LineStyle = 'none';
hold off

figure('Name', 'Average Packet Loss of VoIP')
bvl = bar(x, voip_loss);
bvl.FaceColor = '#77AC30';
xlabel('Number of VoIP data flows')
set(gca, 'xticklabel',n)
ylabel('Avg. Packet Loss of VoIP (%)')

hold on
er = errorbar(x, voip_loss, voip_loss_err);
er.Color = [0 0 0];
er.LineStyle = 'none';
hold off