%����Ͻ����̵���ǰ�ں�
function [TSPsolution , spot1ID , spot2ID] = PerformO2OshopMergeBackward( TSPsolution , O2OshopVec , O2OspotVec , DistanceMatrix, ...
                        DemandVec,volume,  VehicleNum,O2OdemandVec , PackageTimeVec , speed ,StartTimeVec , EndTimeVec ,  ecOrderNum , seperator)
TSPsolution=[TSPsolution 0];
O2ONum = numel(O2OshopVec);
O2OIndex1 = randi(O2ONum);           %�����һ��O2O
shop1ID = O2OshopVec(1) + O2OIndex1-1;   %shop��TSP�еı��
shop2ID = shop1ID;

while(shop1ID==shop2ID)
    shopDistanceMatrix = DistanceMatrix(O2OshopVec(1):O2OshopVec(end),O2OshopVec(1):O2OshopVec(end));       %�̵�������

    shopDistanceVec = shopDistanceMatrix(O2OIndex1 , :);  %��shop��ѡ��shop�ľ�������
    sameShopVec = O2OshopVec(shopDistanceVec==0);       %�ҳ���ѡ��shopλ��һ�����̵�,(TSP�еı��)

    diffShopVec = O2OshopVec(shopDistanceVec>0);
    diffshopDistanceVec = shopDistanceVec(shopDistanceVec>0);
    minDistance = min(diffshopDistanceVec);
    NearestShop = diffShopVec(diffshopDistanceVec == minDistance);%ѡ��λ�ò�ͬ�������������̵�(TSP�еı��)

    shop2Vec = [sameShopVec , NearestShop];
    shop2ID =shop2Vec( randi(numel(shop2Vec)));         %������λ����ͬ�;��������shop�����ѡ����Ϊshop2
end
spot1ID = O2OspotVec(O2OIndex1);
spot2ID = shop2ID + O2ONum;

shop1OriIndex = find(TSPsolution == shop1ID , 1);           %�ҵ�ԭλ��
shop2OriIndex = find(TSPsolution == shop2ID , 1); 

% spot2OriIndex =  find(TSPsolution == spot2ID , 1);
% 


if shop1OriIndex > shop2OriIndex
    shop2NewIndex = shop1OriIndex;
    TSPsolution=Insert(TSPsolution , shop2OriIndex , shop2NewIndex);            %����shop2
    spot2OriIndex =  find(TSPsolution == spot2ID , 1);

    if spot2OriIndex < shop2NewIndex    %���spot2λ��shop2֮ǰ�������²���spot
        zerosSpot=find(TSPsolution==0);
        VehicleEndIndex=zerosSpot(find(zerosSpot>shop2NewIndex, 1, 'first' ));      %�ҵ�shop2֮��ĵ�һ����0����λ��
        spot2NewIndex = shop2NewIndex + randi(VehicleEndIndex - shop2NewIndex )-1;         %spot2�������λ��
        TSPsolution=Insert(TSPsolution , spot2OriIndex , spot2NewIndex);            %����shop2
    end
else    %���shop1��ǰ
    shop1NewIndex = shop2OriIndex;
    TSPsolution=Insert(TSPsolution , shop1OriIndex , shop1NewIndex);            %����shop1
    spot1OriIndex =  find(TSPsolution == spot1ID , 1);
    if spot1OriIndex < shop1NewIndex    %���spot1λ��shop1֮ǰ�������²���spot
        zerosSpot=find(TSPsolution==0);
        VehicleEndIndex=zerosSpot(find(zerosSpot>shop1NewIndex, 1, 'first' ));      %�ҵ�shop1֮��ĵ�һ����0����λ��
        spot1NewIndex = shop1NewIndex + randi(VehicleEndIndex - shop1NewIndex )-1;         %spot1�������λ��
        TSPsolution=Insert(TSPsolution , spot1OriIndex , spot1NewIndex);            %����shop1
    end
end
shop1Index = find(TSPsolution == shop1ID , 1); 
shop2Index = find(TSPsolution == shop2ID , 1); 

TSPsolution1 = TSPsolution(1:end-1);
TSPsolution2 = TSPsolution1;
TSPsolution2(shop1Index) = TSPsolution1(shop2Index);
TSPsolution2(shop2Index) = TSPsolution1(shop1Index);

VRPsolution1 = ConvertToMultiVRPsolution(TSPsolution1,DemandVec,volume, ...
                                                            VehicleNum,O2OshopVec,O2OspotVec,O2OdemandVec , DistanceMatrix ,  ecOrderNum , seperator);
VRPsolution2 = ConvertToMultiVRPsolution(TSPsolution2,DemandVec,volume, ...
                                                            VehicleNum,O2OshopVec,O2OspotVec,O2OdemandVec , DistanceMatrix ,  ecOrderNum , seperator);      
cost1 = CalculateMutiVRPtotalCost(VRPsolution1,DistanceMatrix,VehicleNum , ...
                                                                    PackageTimeVec , speed , StartTimeVec , EndTimeVec);     
cost2 = CalculateMutiVRPtotalCost(VRPsolution2,DistanceMatrix,VehicleNum , ...
                                                                    PackageTimeVec , speed , StartTimeVec , EndTimeVec);      
if cost1 < cost2 
    TSPsolution = TSPsolution1;
else
    TSPsolution = TSPsolution2;
end