%随机选择一个ecSpot插到任意地方
function [SolusiInsert , Spot_1 , Spot_2] = PerformInsert(TSPsolution ,ecOrderNum,VehicleNum )

    SpotId = randi(ecOrderNum)+1;     %随机选择一个电商订单e
    Index_1 = find(TSPsolution==SpotId,1); 


      
Index_2 = Index_1;                  

while Index_2 == Index_1
    Index_2 = randi(length(TSPsolution)-1) + 1;
end
Spot_1 = TSPsolution(Index_1); 
Spot_2 = TSPsolution(Index_2);
SolusiInsert = TSPsolution;
if Index_1 > Index_2 %Jika yg dipindahkan ada di sebelah kanan
    SolusiInsert(Index_2) = TSPsolution(Index_1);
    SolusiInsert(Index_2 + 1 : Index_1) = TSPsolution(Index_2 : Index_1 - 1);
else %Jika yg dipindahkan ada di sebelah kiri
    SolusiInsert(Index_2) = TSPsolution(Index_1);
    SolusiInsert(Index_1 : Index_2 - 1) = TSPsolution(Index_1+ 1 : Index_2);
end


% JumlahKota = numel(TSPsolution) - 1;    %第一个地点为0不动，其他位置均可调整
% Index_1 = randi(JumlahKota) + 1;        %将Index1位置的值插到Index2处，原值顺移
% Index_2 = Index_1;
% while Index_2 == Index_1
%     Index_2 = randi(JumlahKota) + 1;
% end
% Spot_1 = TSPsolution(Index_1); 
% Spot_2 = TSPsolution(Index_2);
% SolusiInsert = TSPsolution;
% if Index_1 > Index_2 %Jika yg dipindahkan ada di sebelah kanan
%     SolusiInsert(Index_2) = TSPsolution(Index_1);
%     SolusiInsert(Index_2 + 1 : Index_1) = TSPsolution(Index_2 : Index_1 - 1);
% else %Jika yg dipindahkan ada di sebelah kiri
%     SolusiInsert(Index_2) = TSPsolution(Index_1);
%     SolusiInsert(Index_1 : Index_2 - 1) = TSPsolution(Index_1+ 1 : Index_2);
% end