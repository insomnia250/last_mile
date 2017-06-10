function [SolusiInsert , Kota_1 , Kota_2] = PerformO2OspotInsert(TSPsolution  , O2OshopVec , O2OspotVec)
TSPsolution=[TSPsolution 0];
O2ONum = numel(O2OshopVec);
O2OIndex = randi(O2ONum);
shopId=O2OshopVec(O2OIndex);        %要操作的O2O商店ID
spotId=O2OspotVec(O2OIndex);           %相应的配送点ID
zerosSpot=find(TSPsolution==0);
shopOriIndex=find(TSPsolution==shopId,1);   %该商店在TSP解中的位置
spotOriIndex=find(TSPsolution==spotId,1);       %响应配送点的位置

VehicleEndIndex=zerosSpot(find(zerosSpot>shopOriIndex, 1, 'first' ));      %表示该信使结束的0点的位置

%配送点新的随机位置 应 位于shop 和 0 位置之间
NewIndex = shopOriIndex + randi(VehicleEndIndex - shopOriIndex - 1);
Kota_1=O2OIndex;
Kota_2 = NewIndex;
SolusiInsert=Insert(TSPsolution,spotOriIndex,NewIndex);
SolusiInsert=SolusiInsert(1:end-1);
    
