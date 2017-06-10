function [Solusi3Opt , Kota_1 , Kota_2 , Kota_3, Kota_4 , Kota_5] =Perform3Opt(TSPsolution)
JumlahKota = numel(TSPsolution) - 1;  
indexes= sort(randperm(JumlahKota , 4) + 1);
Index_1 = indexes(1);
Index_2 = indexes(2);
Index_3 = Index_2+1 ;
Index_4 = indexes(4);   
%��ȡ����·��(Index_1-1 , Index_1)��(Index_2 , Index_3)  (Index_4 , Index_4+1)
%�Ͽ�������·�� ,����·���������ӣ��������ֿ��ܵ���·��

Kota_1 = TSPsolution(Index_1); 
Kota_2 = TSPsolution(Index_2);
Kota_3 = TSPsolution(Index_3);
Kota_4 = TSPsolution(Index_4);

Kota_5 = randi(4) ;  %4��3opt�������·��
Solusi3Opt = TSPsolution;
switch (Kota_5)
    case 1  %����·������������·��   ����
        Solusi3Opt(Index_1:Index_2) = TSPsolution(Index_2:-1:Index_1);
        Solusi3Opt(Index_3 : Index_4) = TSPsolution(Index_4:-1:Index_3);
    case 2  %����·������������·��   ���彻��λ��
        Solusi3Opt(Index_1 : Index_4) = [TSPsolution(Index_3 : Index_4) , TSPsolution(Index_1 : Index_2)];
    case 3  %����·������������·��    ��һ���ֵ��� , ���彻��λ��
        Solusi3Opt(Index_1:Index_2) = TSPsolution(Index_2:-1:Index_1);
        Solusi3Opt(Index_1 : Index_4) = [Solusi3Opt(Index_3 : Index_4) , Solusi3Opt(Index_1 : Index_2)];
    case 4    %����·������������·��    �ڶ����ֵ��� , ���彻��λ��
        Solusi3Opt(Index_3 : Index_4) = TSPsolution(Index_4:-1:Index_3);
        Solusi3Opt(Index_1 : Index_4) = [Solusi3Opt(Index_3 : Index_4) , Solusi3Opt(Index_1 : Index_2)];
end
