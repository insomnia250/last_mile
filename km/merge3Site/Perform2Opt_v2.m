function [newSolusi2Opt , Kota_1 , Kota_2]= Perform2Opt_v2(TSPsolution , O2OshopVec , VehicleNum)
TSPsolution = [TSPsolution 0];
zerosSpot = find(TSPsolution==0);

VehicleIndex = randi(VehicleNum);
VehicleStartIndex=zerosSpot(VehicleIndex);  %新的随机快递员 0 的位置
VehicleEndIndex=zerosSpot(VehicleIndex + 1);%快递员结束的 0 的位置，也是下一个快递员开始的位置
if VehicleEndIndex-VehicleStartIndex<=2
    newSolusi2Opt = TSPsolution(1:end-1);
    Kota_1=0;
    Kota_2=0;
    return
end



Index_1 = randi(VehicleEndIndex -VehicleStartIndex -1) + VehicleStartIndex;                
Index_2 = Index_1;                  %该函数将Index_1和Index_2之间的元素按照原来的倒叙排列
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
    shopInTSP = partSolution(shopIndex);      %找到TSP中的shop
    spotInTSP = shopInTSP + length(O2OshopVec);     %对应的spot

    [BothInTSPVec , spotIndex] = ismember(spotInTSP , partSolution);   %返回是否需要调换的判断矩阵 和 相应spot在 TSP中的位置向量
    spotIndex = spotIndex+Index_1-1;
    shopIndex = shopIndex+Index_1-1;
    % shopToExchange = shopInTSP(BothInTSPVec);   %需要和spot调换的shop
    % spotToExchange = spotInTSP(BothInTSPVec);   %需要调换的spot
    shopToExchangeIndex = shopIndex(BothInTSPVec);   %需调换的shop位置
    spotToExchangeIndex = spotIndex(BothInTSPVec);   %需调换的shop位置

    %调换对应shop 和 spot 
    newSolusi2Opt = Solusi2Opt;
    newSolusi2Opt(shopToExchangeIndex) = Solusi2Opt(spotToExchangeIndex);
    newSolusi2Opt(spotToExchangeIndex) = Solusi2Opt(shopToExchangeIndex);
    newSolusi2Opt=newSolusi2Opt(1:end-1);
else
    newSolusi2Opt = Solusi2Opt(1:end-1);
end


