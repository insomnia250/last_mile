function [TSPsolution , Kota_1 , Kota_2] = PerformO2Ospotpursue(TSPsolution  , ecOrderNum ,  O2OshopVec , O2OspotVec)
TSPsolution=[TSPsolution 0];
O2ONum = numel(O2OshopVec);

ECIndex = randi(ecOrderNum)+3;     %���ѡ��һ��Ҫ׷��ĵ��̶���

O2OIndex = randi(O2ONum);           %���ѡ��һ��O2O����
shopId=O2OshopVec(O2OIndex);        %Ҫ������O2O�̵�ID
spotId=O2OspotVec(O2OIndex);           %��Ӧ�����͵�ID


ecOriIndex = find(TSPsolution==ECIndex,1);      %�õ������͵���TSP����λ��

spotOriIndex=find(TSPsolution==spotId,1);   %��spot��TSP���е�λ��

% O2Ospot ׷��ѡ������
if  spotOriIndex > ecOriIndex
    spotNewIndex = ecOriIndex+1;
    TSPsolution=Insert(TSPsolution , spotOriIndex , spotNewIndex);
else
    spotNewIndex = ecOriIndex;
    TSPsolution=Insert(TSPsolution , spotOriIndex , spotNewIndex);
end

shopOriIndex=find(TSPsolution==shopId,1);       %��Ӧshop��λ��
%O2Oshop׷�� ��Ӧ spot
if  shopOriIndex > spotNewIndex
    shopTempIndex = spotNewIndex ;
    TSPsolution=Insert(TSPsolution , shopOriIndex , shopTempIndex);
else
    shopTempIndex = spotNewIndex - 1 ;
    TSPsolution=Insert(TSPsolution , shopOriIndex , shopTempIndex);
end

spotNewIndex = find(TSPsolution==spotId,1);   %��spot������TSP���е�λ��
zerosSpot=find(TSPsolution==0);

VehicleStartIndex=zerosSpot(find(zerosSpot<shopTempIndex, 1, 'last' ));      %��ʾ����ʹ��0���λ��

%���͵��µ����λ�� Ӧ λ��shop �� 0 λ��֮��
shopNewIndex = VehicleStartIndex + randi(spotNewIndex - VehicleStartIndex -1);
Kota_1=O2OIndex;
Kota_2 = ECIndex;
TSPsolution=Insert(TSPsolution , shopTempIndex , shopNewIndex);
TSPsolution=TSPsolution(1:end-1);
  
