%O2O�̵�׷����һ��һ��O2O�̵�
function [TSPsolution , Kota_1 , Kota_2] = PerformO2Oshoppursue2(TSPsolution  , O2OshopVec , O2OspotVec)
TSPsolution=[TSPsolution 0];
O2ONum = numel(O2OshopVec);

O2OIndex = randi(O2ONum);           %���׷����
targetO2OIndex = randi(O2ONum);     %���ѡ��׷����
while(O2OIndex==targetO2OIndex)
    targetO2OIndex = randi(O2ONum);
end

shopId=O2OshopVec(O2OIndex);        %׷����O2O�̵�ID
targetShopId=O2OshopVec(targetO2OIndex);         %��׷����O2O�̵�ID
spotId=O2OspotVec(O2OIndex);           %׷�������͵�ID
shopOriIndex=find(TSPsolution==shopId,1);   %׷������TSP���е�λ��
targetshopOriIndex = find(TSPsolution==targetShopId,1);   %��׷����TSP���е�λ��

% ׷��Ŀ��shop
if targetshopOriIndex < shopOriIndex   %��׷���� λ�� ׷���� ֮ǰ
    shopNewIndex = targetshopOriIndex+1;
    TSPsolution=Insert(TSPsolution , shopOriIndex , shopNewIndex);
else
    shopNewIndex = targetshopOriIndex;
    TSPsolution=Insert(TSPsolution , shopOriIndex , shopNewIndex);
end

spotOriIndex=find(TSPsolution==spotId,1);       %��Ӧ���͵��λ��
%O2Ospot׷�� ��Ӧ shop
if shopNewIndex < spotOriIndex
    spotTempIndex = shopNewIndex + 1;
    TSPsolution=Insert(TSPsolution , spotOriIndex , spotTempIndex);
else
    spotTempIndex = shopNewIndex ;
    TSPsolution=Insert(TSPsolution , spotOriIndex , spotTempIndex);
end

shopNewIndex = find(TSPsolution==shopId,1);   %���̵�������TSP���е�λ��

VehicleEndIndex=length(TSPsolution);

%׷�������͵��µ����λ�� Ӧ λ��shop �� 0 λ��֮��
spotNewIndex = shopNewIndex + randi(VehicleEndIndex - shopNewIndex - 1);
Kota_1=O2OIndex;
Kota_2 = targetO2OIndex;
TSPsolution=Insert(TSPsolution , spotTempIndex , spotNewIndex);
TSPsolution=TSPsolution(1:end-1);

