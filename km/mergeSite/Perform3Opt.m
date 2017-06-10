function [Solusi3Opt , Kota_1 , Kota_2 , Kota_3, Kota_4 , Kota_5] =Perform3Opt(TSPsolution)
JumlahKota = numel(TSPsolution) - 1;  
indexes= sort(randperm(JumlahKota , 4) + 1);
Index_1 = indexes(1);
Index_2 = indexes(2);
Index_3 = Index_2+1 ;
Index_4 = indexes(4);   
%截取三段路径(Index_1-1 , Index_1)，(Index_2 , Index_3)  (Index_4 , Index_4+1)
%断开这三条路径 ,其他路径保持连接，产生四种可能的新路径

Kota_1 = TSPsolution(Index_1); 
Kota_2 = TSPsolution(Index_2);
Kota_3 = TSPsolution(Index_3);
Kota_4 = TSPsolution(Index_4);

Kota_5 = randi(4) ;  %4中3opt操作后的路径
Solusi3Opt = TSPsolution;
switch (Kota_5)
    case 1  %被断路隔开的两部分路径   倒序
        Solusi3Opt(Index_1:Index_2) = TSPsolution(Index_2:-1:Index_1);
        Solusi3Opt(Index_3 : Index_4) = TSPsolution(Index_4:-1:Index_3);
    case 2  %被断路隔开的两部分路径   整体交换位置
        Solusi3Opt(Index_1 : Index_4) = [TSPsolution(Index_3 : Index_4) , TSPsolution(Index_1 : Index_2)];
    case 3  %被断路隔开的两部分路径    第一部分倒序 , 整体交换位置
        Solusi3Opt(Index_1:Index_2) = TSPsolution(Index_2:-1:Index_1);
        Solusi3Opt(Index_1 : Index_4) = [Solusi3Opt(Index_3 : Index_4) , Solusi3Opt(Index_1 : Index_2)];
    case 4    %被断路隔开的两部分路径    第二部分倒序 , 整体交换位置
        Solusi3Opt(Index_3 : Index_4) = TSPsolution(Index_4:-1:Index_3);
        Solusi3Opt(Index_1 : Index_4) = [Solusi3Opt(Index_3 : Index_4) , Solusi3Opt(Index_1 : Index_2)];
end
