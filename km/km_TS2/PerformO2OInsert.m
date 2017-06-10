%%���һ��O2O����ز�
function [SolusiInsert , Kota_1 , Kota_2] = PerformO2OInsert(TSPsolution  , O2OshopVec , O2OspotVec)
TSPsolution = [TSPsolution 0];
O2ONum = numel(O2OshopVec);

O2OIndex = randi(O2ONum);


shopId=O2OshopVec(O2OIndex);
spotId=O2OspotVec(O2OIndex);

Kota_1=shopId;
Kota_2 = spotId;

tempSolution = TSPsolution(~ismember(TSPsolution , [shopId , spotId]));   %���ԭsolution�е�shop spot
% zerosSpot=find(tempSolution==0);

% VehicleStartIndex=1;   %�µ�������Ա 0 ��λ��
% VehicleEndIndex=zerosSpot(2);   %���Ա������ 0 ��λ�ã�Ҳ����һ�����Ա��ʼ��λ��
VehicleEndIndex = length(TSPsolution) - 2;
%�̵��µ����λ�� Ӧ λ������ 0 ֮��
shopNewIndex = 1 + randi(VehicleEndIndex - 1 );
tempSolution = [ tempSolution(1 : (shopNewIndex - 1) ) , shopId , tempSolution(shopNewIndex : end)]; %����shop
%spot�µ����λ��Ӧλ��shopNewIndex �� ��һ��0֮��
spotNewIndex = shopNewIndex + randi(VehicleEndIndex +1 - shopNewIndex );
tempSolution = [ tempSolution(1 : (spotNewIndex - 1) ) , spotId , tempSolution(spotNewIndex : end)]; %����shop

SolusiInsert = tempSolution(1:end-1);   %ɾ�����һ��0
