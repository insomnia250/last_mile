function [TSPsolution , Kota_1 , Kota_2] = PerformO2Oshoppursue(TSPsolution  , ecOrderNum ,  O2OshopVec , O2OspotVec)
TSPsolution=[TSPsolution 0];
O2ONum = numel(O2OshopVec);

ECIndex = randi(ecOrderNum)+2;     %���ѡ��һ��Ҫ׷��ĵ��̶���

O2OIndex = randi(O2ONum);           %���ѡ��һ��O2O����
shopId=O2OshopVec(O2OIndex);        %Ҫ������O2O�̵�ID
spotId=O2OspotVec(O2OIndex);           %��Ӧ�����͵�ID


ecOriIndex = find(TSPsolution==ECIndex,1);      %�õ������͵���TSP����λ��
shopOriIndex=find(TSPsolution==shopId,1);   %���̵���TSP���е�λ��

% O2Oshop ׷��ѡ������
if ecOriIndex < shopOriIndex
    shopNewIndex = ecOriIndex+1;
    TSPsolution=Insert(TSPsolution , shopOriIndex , shopNewIndex);
else
    shopNewIndex = ecOriIndex;
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
zerosSpot=find(TSPsolution==0);
VehicleEndIndex=zerosSpot(find(zerosSpot>shopNewIndex, 1, 'first' ));      %��ʾ����ʹ������0���λ��

%���͵��µ����λ�� Ӧ λ��shop �� 0 λ��֮��
spotNewIndex = shopNewIndex + randi(VehicleEndIndex - shopNewIndex - 1);
Kota_1=O2OIndex;
Kota_2 = ECIndex;
TSPsolution=Insert(TSPsolution , spotTempIndex , spotNewIndex);
TSPsolution=TSPsolution(1:end-1);

