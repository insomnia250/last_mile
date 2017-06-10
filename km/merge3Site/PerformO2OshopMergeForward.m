%距离较近的商店向前融合
function [TSPsolution , spot1ID , spot2ID] = PerformO2OshopMergeForward( TSPsolution , O2OshopVec , O2OspotVec , DistanceMatrix ,...
                        DemandVec,volume,  VehicleNum,O2OdemandVec , PackageTimeVec , speed ,StartTimeVec , EndTimeVec, ecOrderNum  ,seperator1 , seperator2)
TSPsolution=[TSPsolution 0];
O2ONum = numel(O2OshopVec);
O2OIndex1 = randi(O2ONum);           %随机找一个O2O
shop1ID = O2OshopVec(1) + O2OIndex1-1;   %shop在TSP中的编号
shop2ID = shop1ID;

while(shop1ID==shop2ID)
    shopDistanceMatrix = DistanceMatrix(O2OshopVec(1):O2OshopVec(end),O2OshopVec(1):O2OshopVec(end));       %商店距离矩阵

    shopDistanceVec = shopDistanceMatrix(O2OIndex1 , :);  %各shop和选中shop的距离向量
    sameShopVec = O2OshopVec(shopDistanceVec==0);       %找出和选中shop位置一样的商店,(TSP中的编号)

    diffShopVec = O2OshopVec(shopDistanceVec>0);
    diffshopDistanceVec = shopDistanceVec(shopDistanceVec>0);
    minDistance = min(diffshopDistanceVec);
    NearestShop = diffShopVec(diffshopDistanceVec == minDistance);%选出位置不同，而离得最近的商店(TSP中的编号)

    shop2Vec = [sameShopVec , NearestShop];
    shop2ID =shop2Vec( randi(numel(shop2Vec)));         %从所有位置相同和距离最近的shop中随机选择，作为shop2
end
spot1ID = O2OspotVec(O2OIndex1);
spot2ID = shop2ID + O2ONum;

shop1OriIndex = find(TSPsolution == shop1ID , 1);           %找到原位置
shop2OriIndex = find(TSPsolution == shop2ID , 1); 
spot1OriIndex =  find(TSPsolution == spot1ID , 1);
spot2OriIndex =  find(TSPsolution == spot2ID , 1);
zerosSpot=find(TSPsolution==0);


if shop1OriIndex > shop2OriIndex
    VehicleEndIndex=zerosSpot(find(zerosSpot>shop2OriIndex, 1, 'first' ));      %找到shop2之后的第一个“0”的位置
    shop1NewIndex = shop2OriIndex + 1;
    if VehicleEndIndex > shop1OriIndex   %如果0不在两个shop之间，则可直接将shop1插入shop2之后
        TSPsolution=Insert(TSPsolution , shop1OriIndex , shop1NewIndex);
    else
        TSPsolution=Insert(TSPsolution , shop1OriIndex , shop1NewIndex);    %插入shop1
        VehicleEndIndex = VehicleEndIndex + 1;              %更新“0”的位置
        spot1NewIndex = shop1NewIndex + randi(VehicleEndIndex - shop1NewIndex );         %spot1的新随机位置
        TSPsolution=Insert(TSPsolution , spot1OriIndex , spot1NewIndex);            %插入spot1
    end
    TSPsolution1 = TSPsolution(1:end-1);
    TSPsolution2 = TSPsolution1;
    TSPsolution2(shop1NewIndex) = TSPsolution1(shop2OriIndex);
    TSPsolution2(shop2OriIndex) = TSPsolution1(shop1NewIndex);
else   %shop2在后
    VehicleEndIndex=zerosSpot(find(zerosSpot>shop1OriIndex, 1, 'first' ));      %找到shop2之后的第一个“0”的位置
     shop2NewIndex = shop1OriIndex + 1;
    if VehicleEndIndex > shop2OriIndex   %如果0不在两个shop之间，则可直接将shop2插入shop1之后 
        TSPsolution=Insert(TSPsolution , shop2OriIndex , shop2NewIndex);
    else
        TSPsolution=Insert(TSPsolution , shop2OriIndex , shop2NewIndex);    %插入shop1
%         TSPsolution
        VehicleEndIndex = VehicleEndIndex + 1;              %更新“0”的位置
        spot2NewIndex = shop2NewIndex + randi(VehicleEndIndex - shop2NewIndex );         %spot1的新随机位置
        TSPsolution=Insert(TSPsolution , spot2OriIndex , spot2NewIndex);            %插入spot1
    end
    TSPsolution1 = TSPsolution(1:end-1);
    TSPsolution2 = TSPsolution1;
    TSPsolution2(shop2NewIndex) = TSPsolution1(shop1OriIndex);
    TSPsolution2(shop1OriIndex) = TSPsolution1(shop2NewIndex);
end
VRPsolution1 = ConvertToMultiVRPsolution(TSPsolution1,DemandVec,volume, ...
                                                            VehicleNum,O2OshopVec,O2OspotVec,O2OdemandVec , DistanceMatrix ,ecOrderNum  ,seperator1 , seperator2);
VRPsolution2 = ConvertToMultiVRPsolution(TSPsolution2,DemandVec,volume, ...
                                                            VehicleNum,O2OshopVec,O2OspotVec,O2OdemandVec , DistanceMatrix ,ecOrderNum  ,seperator1 , seperator2);
cost1 = CalculateMutiVRPtotalCost(VRPsolution1,DistanceMatrix,VehicleNum , ...
                                                                    PackageTimeVec , speed , StartTimeVec , EndTimeVec);     
cost2 = CalculateMutiVRPtotalCost(VRPsolution2,DistanceMatrix,VehicleNum , ...
                                                                    PackageTimeVec , speed , StartTimeVec , EndTimeVec);      
if cost1 < cost2 
    TSPsolution = TSPsolution1;
else
    TSPsolution = TSPsolution2;
end