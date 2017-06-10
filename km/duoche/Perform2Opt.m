function [Solusi2Opt , Kota_1 , Kota_2]= Perform2Opt(TSPsolution)
JumlahKota = numel(TSPsolution) - 1;
Index_1 = randi(JumlahKota) + 1;                
Index_2 = Index_1;                  %�ú�����Index_1��Index_2֮���Ԫ�ذ���ԭ���ĵ�������
while Index_1 >= Index_2
    Index_1 = randi(JumlahKota) + 1;
    Index_2 = randi(JumlahKota) + 1;
end
Kota_1 = TSPsolution(Index_1); 
Kota_2 = TSPsolution(Index_2);
Solusi2Opt = TSPsolution;
Solusi2Opt(Index_1:Index_2) = TSPsolution(Index_2:-1:Index_1);