function [SolusiInsert , Kota_1 , Kota_2] = PerformO2OspotInsert(TSPsolution  , O2OshopVec , O2OspotVec)
TSPsolution=[TSPsolution 0];
O2ONum = numel(O2OshopVec);
O2OIndex = randi(O2ONum);

shopId=O2OshopVec(O2OIndex);        %Ҫ������O2O�̵�ID
spotId=O2OspotVec(O2OIndex);           %��Ӧ�����͵�ID

shopOriIndex=find(TSPsolution==shopId,1);   %���̵���TSP���е�λ��
spotOriIndex=find(TSPsolution==spotId,1);       %��Ӧ���͵��λ��
VehicleEndIndex=length(TSPsolution);
%���͵��µ����λ�� Ӧ λ��shop �� 0 λ��֮��
NewIndex = shopOriIndex + randi(VehicleEndIndex - shopOriIndex - 1);
Kota_1=O2OIndex;
Kota_2 = NewIndex;
SolusiInsert=Insert(TSPsolution,spotOriIndex,NewIndex);
SolusiInsert=SolusiInsert(1:(end-1));
    
