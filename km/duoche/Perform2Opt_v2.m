function [newSolusi2Opt , Kota_1 , Kota_2]= Perform2Opt_v2(TSPsolution , O2OshopVec , VehicleNum)
TSPsolution = [TSPsolution 0];
zerosSpot = find(TSPsolution==0);

VehicleIndex = randi(VehicleNum);
VehicleStartIndex=zerosSpot(VehicleIndex);  %�µ�������Ա 0 ��λ��
VehicleEndIndex=zerosSpot(VehicleIndex + 1);%���Ա������ 0 ��λ�ã�Ҳ����һ�����Ա��ʼ��λ��
if VehicleEndIndex-VehicleStartIndex<=2
    newSolusi2Opt = TSPsolution(1:end-1);
    Kota_1=0;
    Kota_2=0;
    return
end



Index_1 = randi(VehicleEndIndex -VehicleStartIndex -1) + VehicleStartIndex;                
Index_2 = Index_1;                  %�ú�����Index_1��Index_2֮���Ԫ�ذ���ԭ���ĵ�������
while Index_1 >= Index_2
    Index_1 = randi(VehicleEndIndex -VehicleStartIndex -1) + VehicleStartIndex;         
    Index_2 = randi(VehicleEndIndex -VehicleStartIndex -1) + VehicleStartIndex;         
end


Kota_1 = TSPsolution(Index_1);
Kota_2 = TSPsolution(Index_2);

Solusi2Opt = TSPsolution;
Solusi2Opt(Index_1:Index_2) = TSPsolution(Index_2:-1:Index_1);
partSolution = Solusi2Opt(Index_1:Index_2);

if ~isempty(O2OshopVec)
    shopIndex = find(partSolution>=O2OshopVec(1) & partSolution<=O2OshopVec(end));
    shopInTSP = partSolution(shopIndex);      %�ҵ�TSP�е�shop
    spotInTSP = shopInTSP + length(O2OshopVec);     %��Ӧ��spot

    [BothInTSPVec , spotIndex] = ismember(spotInTSP , partSolution);   %�����Ƿ���Ҫ�������жϾ��� �� ��Ӧspot�� TSP�е�λ������
    spotIndex = spotIndex+Index_1-1;
    shopIndex = shopIndex+Index_1-1;
    % shopToExchange = shopInTSP(BothInTSPVec);   %��Ҫ��spot������shop
    % spotToExchange = spotInTSP(BothInTSPVec);   %��Ҫ������spot
    shopToExchangeIndex = shopIndex(BothInTSPVec);   %�������shopλ��
    spotToExchangeIndex = spotIndex(BothInTSPVec);   %�������shopλ��

    %������Ӧshop �� spot 
    newSolusi2Opt = Solusi2Opt;
    newSolusi2Opt(shopToExchangeIndex) = Solusi2Opt(spotToExchangeIndex);
    newSolusi2Opt(spotToExchangeIndex) = Solusi2Opt(shopToExchangeIndex);
    newSolusi2Opt=newSolusi2Opt(1:end-1);
else
    newSolusi2Opt = Solusi2Opt(1:end-1);
end


