%将O2Oshop 重新随机插入 原快递员的 0 和 相应spot之间
function [SolusiInsert , Kota_1 , Kota_2] = PerformO2OshopInsert(TSPsolution  , O2OshopVec , O2OspotVec)
O2ONum = numel(O2OshopVec);
O2OIndex = randi(O2ONum);
shopId=O2OshopVec(O2OIndex);        %要操作的O2O商店ID
spotId=O2OspotVec(O2OIndex);           %相应的配送点ID
zerosSpot=find(TSPsolution==0);
shopOriIndex=find(TSPsolution==shopId,1);   %该商店在TSP解中的位置
spotOriIndex=find(TSPsolution==spotId,1);       %响应配送点的位置
VehicleStartIndex=zerosSpot(find(zerosSpot<shopOriIndex, 1, 'last' ));      %表示该信使的0点的位置
%商店新的随机位置 应 位于0 和 spot 位置之间
NewIndex = VehicleStartIndex + randi(spotOriIndex - VehicleStartIndex -1);
Kota_1=shopId;
Kota_2 = TSPsolution(NewIndex);
SolusiInsert=Insert(TSPsolution,shopOriIndex,NewIndex);
    
