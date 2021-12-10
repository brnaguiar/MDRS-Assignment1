% D

lambda = 1800;
size = 64:1518 ;
C = [10*10^6, 20*10^6, 30*10^6, 40*10^6]; 

prob = zeros(1,1518) ;

prob(size) = (1 - 0.19 - 0.23 - 0.17) / ((length(size) - 3)) ;
prob(64) = 0.19 ;
prob(110) = 0.23 ;
prob(1518) = 0.17 ; 
%prob
avgPacketSize = sum(prob(size).*size); 

avgPacketTransmission = (avgPacketSize * 8) ./ C ;
avgPacketTransmission

ES = avgPacketTransmission ;
ES2 = zeros(1, length(C)) ;

for i = 1:length(C)
    aux = ((size .* 8) / C(i)).^2 ; 
    ES2(1, i) = sum(prob(size).*aux) ; 
end

avgQueuingDelay = (lambda.*ES2)./(2-(2*lambda.*ES));

avgPktDelay = (avgQueuingDelay + avgPacketTransmission) * 1000 % ms para segundos... 

