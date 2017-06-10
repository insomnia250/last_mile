function [TSPsolution , Kota_1 , Kota_2] = PerformO2Ospotpursue(TSPsolution  , ecOrderNum ,  O2OshopVec , O2OspotVec)
TSPsolution=[TSPsolution 0];
O2ONum = numel(O2OshopVec);

ECIndex = randi(ecOrderNum)+2;     %随机选择一个要追随的电商订单

O2OIndex = randi(O2ONum);           %随机选择一个O2O订单
shopId=O2OshopVec(O2OIndex);        %要操作的O2O商店ID
spotId=O2OspotVec(O2OIndex);           %相应的配送点ID


ecOriIndex = find(TSPsolution==ECIndex,1);      %该电商配送点在TSP解中位置

spotOriIndex=find(TSPsolution==spotId,1);   %该spot在TSP解中的位置

% O2Ospot 追逐选定电商
if  spotOriIndex > ecOriIndex
    spotNewIndex = ecOriIndex+1;
    TSPsolution=Insert(TSPsolution , spotOriIndex , spotNewIndex);
else
    spotNewIndex = ecOriIndex;
    TSPsolution=Insert(TSPsolution , spotOriIndex , spotNewIndex);
end

shopOriIndex=find(TSPsolution==shopId,1);       %相应shop的位置
%O2Oshop追逐 对应 spot
if  shopOriIndex > spotNewIndex
    shopTempIndex = spotNewIndex ;
    TSPsolution=Insert(TSPsolution , shopOriIndex , shopTempIndex);
else
    shopTempIndex = spotNewIndex - 1 ;
    TSPsolution=Insert(TSPsolution , shopOriIndex , shopTempIndex);
end

spotNewIndex = find(TSPsolution==spotId,1);   %该spot现在在TSP解中的位置
zerosSpot=find(TSPsolution==0);

VehicleStartIndex=zerosSpot(find(zerosSpot<shopTempIndex, 1, 'last' ));      %表示该信使的0点的位置

%配送点新的随机位置 应 位于shop 和 0 位置之间
shopNewIndex = VehicleStartIndex + randi(spotNewIndex - VehicleStartIndex -1);
Kota_1=O2OIndex;
Kota_2 = ECIndex;
TSPsolution=Insert(TSPsolution , shopTempIndex , shopNewIndex);
TSPsolution=TSPsolution(1:end-1);
  
