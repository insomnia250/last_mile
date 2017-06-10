%��O2Oshop ����������� ԭ���Ա�� 0 �� ��Ӧspot֮��
function [SolusiInsert , Kota_1 , Kota_2] = PerformO2OshopInsert(TSPsolution  , O2OshopVec , O2OspotVec)
O2ONum = numel(O2OshopVec);
O2OIndex = randi(O2ONum);
shopId=O2OshopVec(O2OIndex);        %Ҫ������O2O�̵�ID
spotId=O2OspotVec(O2OIndex);           %��Ӧ�����͵�ID
zerosSpot=find(TSPsolution==0);
shopOriIndex=find(TSPsolution==shopId,1);   %���̵���TSP���е�λ��
spotOriIndex=find(TSPsolution==spotId,1);       %��Ӧ���͵��λ��
VehicleStartIndex=zerosSpot(find(zerosSpot<shopOriIndex, 1, 'last' ));      %��ʾ����ʹ��0���λ��
%�̵��µ����λ�� Ӧ λ��0 �� spot λ��֮��
NewIndex = VehicleStartIndex + randi(spotOriIndex - VehicleStartIndex -1);
Kota_1=shopId;
Kota_2 = TSPsolution(NewIndex);
SolusiInsert=Insert(TSPsolution,shopOriIndex,NewIndex);
    
