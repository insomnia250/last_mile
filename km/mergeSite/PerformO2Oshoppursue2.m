%O2O商店追逐另一个一个O2O商店
function [TSPsolution , Kota_1 , Kota_2] = PerformO2Oshoppursue2(TSPsolution  , O2OshopVec , O2OspotVec)
TSPsolution=[TSPsolution 0];
O2ONum = numel(O2OshopVec);

O2OIndex = randi(O2ONum);           %随机追随者
targetO2OIndex = randi(O2ONum);     %随机选择被追随者
while(O2OIndex==targetO2OIndex)
    targetO2OIndex = randi(O2ONum);
end

shopId=O2OshopVec(O2OIndex);        %追随者O2O商店ID
targetShopId=O2OshopVec(targetO2OIndex);         %被追随者O2O商店ID
spotId=O2OspotVec(O2OIndex);           %追随者配送点ID
shopOriIndex=find(TSPsolution==shopId,1);   %追随者在TSP解中的位置
targetshopOriIndex = find(TSPsolution==targetShopId,1);   %被追随在TSP解中的位置

% 追随目标shop
if targetshopOriIndex < shopOriIndex   %被追随者 位于 追随者 之前
    shopNewIndex = targetshopOriIndex+1;
    TSPsolution=Insert(TSPsolution , shopOriIndex , shopNewIndex);
else
    shopNewIndex = targetshopOriIndex;
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

%追逐者配送点新的随机位置 应 位于shop 和 0 位置之间
spotNewIndex = shopNewIndex + randi(VehicleEndIndex - shopNewIndex - 1);
Kota_1=O2OIndex;
Kota_2 = targetO2OIndex;
TSPsolution=Insert(TSPsolution , spotTempIndex , spotNewIndex);
TSPsolution=TSPsolution(1:end-1);

