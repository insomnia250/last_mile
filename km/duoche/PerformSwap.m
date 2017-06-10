function [SolusiSwap , Kota_1 , Kota_2] = PerformSwap(TSPsolution)
JumlahKota = numel(TSPsolution) - 1;
Index_1 = randi(JumlahKota) + 1;        %交换两位置的值
Index_2 = Index_1;
while Index_2 == Index_1
    Index_2 = randi(JumlahKota) + 1;
end
Kota_1 = TSPsolution(Index_1); 
Kota_2 = TSPsolution(Index_2);
SolusiSwap = TSPsolution;
SolusiSwap(Index_1) = TSPsolution(Index_2);
SolusiSwap(Index_2) = TSPsolution(Index_1);
end