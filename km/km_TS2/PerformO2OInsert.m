%%抽出一对O2O随机重插
function [SolusiInsert , Kota_1 , Kota_2] = PerformO2OInsert(TSPsolution  , O2OshopVec , O2OspotVec)
TSPsolution = [TSPsolution 0];
O2ONum = numel(O2OshopVec);

O2OIndex = randi(O2ONum);


shopId=O2OshopVec(O2OIndex);
spotId=O2OspotVec(O2OIndex);

Kota_1=shopId;
Kota_2 = spotId;

tempSolution = TSPsolution(~ismember(TSPsolution , [shopId , spotId]));   %抽掉原solution中的shop spot
% zerosSpot=find(tempSolution==0);

% VehicleStartIndex=1;   %新的随机快递员 0 的位置
% VehicleEndIndex=zerosSpot(2);   %快递员结束的 0 的位置，也是下一个快递员开始的位置
VehicleEndIndex = length(TSPsolution) - 2;
%商店新的随机位置 应 位于两个 0 之间
shopNewIndex = 1 + randi(VehicleEndIndex - 1 );
tempSolution = [ tempSolution(1 : (shopNewIndex - 1) ) , shopId , tempSolution(shopNewIndex : end)]; %插入shop
%spot新的随机位置应位于shopNewIndex 和 后一个0之间
spotNewIndex = shopNewIndex + randi(VehicleEndIndex +1 - shopNewIndex );
tempSolution = [ tempSolution(1 : (spotNewIndex - 1) ) , spotId , tempSolution(spotNewIndex : end)]; %插入shop

SolusiInsert = tempSolution(1:end-1);   %删掉最后一个0
