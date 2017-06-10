function [TSPsolution , Kota_1 , Kota_2] = PerformO2Oshoppursue(TSPsolution  , ecOrderNum ,  O2OshopVec , O2OspotVec)
TSPsolution=[TSPsolution 0];
O2ONum = numel(O2OshopVec);

ECIndex = randi(ecOrderNum)+2;     %随机选择一个要追随的电商订单

O2OIndex = randi(O2ONum);           %随机选择一个O2O订单
shopId=O2OshopVec(O2OIndex);        %要操作的O2O商店ID
spotId=O2OspotVec(O2OIndex);           %相应的配送点ID


ecOriIndex = find(TSPsolution==ECIndex,1);      %该电商配送点在TSP解中位置
shopOriIndex=find(TSPsolution==shopId,1);   %该商店在TSP解中的位置

% O2Oshop 追逐选定电商
if ecOriIndex < shopOriIndex
    shopNewIndex = ecOriIndex+1;
    TSPsolution=Insert(TSPsolution , shopOriIndex , shopNewIndex);
else
    shopNewIndex = ecOriIndex;
    TSPsolution=Insert(TSPsolution , shopOriIndex , shopNewIndex);
end

spotOriIndex=find(TSPsolution==spotId,1);       %相应配送点的位置
%O2Ospot追逐 对应 shop
if shopNewIndex < spotOriIndex
    spotTempIndex = shopNewIndex + 1;
    TSPsolution=Insert(TSPsolution , spotOriIndex , spotTempIndex);
else
    spotTempIndex = shopNewIndex ;
    TSPsolution=Insert(TSPsolution , spotOriIndex , spotTempIndex);
end

shopNewIndex = find(TSPsolution==shopId,1);   %该商店现在在TSP解中的位置
zerosSpot=find(TSPsolution==0);
VehicleEndIndex=zerosSpot(find(zerosSpot>shopNewIndex, 1, 'first' ));      %表示该信使结束的0点的位置

%配送点新的随机位置 应 位于shop 和 0 位置之间
spotNewIndex = shopNewIndex + randi(VehicleEndIndex - shopNewIndex - 1);
Kota_1=O2OIndex;
Kota_2 = ECIndex;
TSPsolution=Insert(TSPsolution , spotTempIndex , spotNewIndex);
TSPsolution=TSPsolution(1:end-1);

