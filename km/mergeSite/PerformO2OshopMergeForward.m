%����Ͻ����̵���ǰ�ں�
function [TSPsolution , spot1ID , spot2ID] = PerformO2OshopMergeForward( TSPsolution , O2OshopVec , O2OspotVec , DistanceMatrix ,...
                        DemandVec,volume,  VehicleNum,O2OdemandVec , PackageTimeVec , speed ,StartTimeVec , EndTimeVec, ecOrderNum , seperator)
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
spot1OriIndex =  find(TSPsolution == spot1ID , 1);
spot2OriIndex =  find(TSPsolution == spot2ID , 1);
zerosSpot=find(TSPsolution==0);


if shop1OriIndex > shop2OriIndex
    VehicleEndIndex=zerosSpot(find(zerosSpot>shop2OriIndex, 1, 'first' ));      %�ҵ�shop2֮��ĵ�һ����0����λ��
    shop1NewIndex = shop2OriIndex + 1;
    if VehicleEndIndex > shop1OriIndex   %���0��������shop֮�䣬���ֱ�ӽ�shop1����shop2֮��
        TSPsolution=Insert(TSPsolution , shop1OriIndex , shop1NewIndex);
    else
        TSPsolution=Insert(TSPsolution , shop1OriIndex , shop1NewIndex);    %����shop1
        VehicleEndIndex = VehicleEndIndex + 1;              %���¡�0����λ��
        spot1NewIndex = shop1NewIndex + randi(VehicleEndIndex - shop1NewIndex );         %spot1�������λ��
        TSPsolution=Insert(TSPsolution , spot1OriIndex , spot1NewIndex);            %����spot1
    end
    TSPsolution1 = TSPsolution(1:end-1);
    TSPsolution2 = TSPsolution1;
    TSPsolution2(shop1NewIndex) = TSPsolution1(shop2OriIndex);
    TSPsolution2(shop2OriIndex) = TSPsolution1(shop1NewIndex);
else   %shop2�ں�
    VehicleEndIndex=zerosSpot(find(zerosSpot>shop1OriIndex, 1, 'first' ));      %�ҵ�shop2֮��ĵ�һ����0����λ��
     shop2NewIndex = shop1OriIndex + 1;
    if VehicleEndIndex > shop2OriIndex   %���0��������shop֮�䣬���ֱ�ӽ�shop2����shop1֮�� 
        TSPsolution=Insert(TSPsolution , shop2OriIndex , shop2NewIndex);
    else
        TSPsolution=Insert(TSPsolution , shop2OriIndex , shop2NewIndex);    %����shop1
%         TSPsolution
        VehicleEndIndex = VehicleEndIndex + 1;              %���¡�0����λ��
        spot2NewIndex = shop2NewIndex + randi(VehicleEndIndex - shop2NewIndex );         %spot1�������λ��
        TSPsolution=Insert(TSPsolution , spot2OriIndex , spot2NewIndex);            %����spot1
    end
    TSPsolution1 = TSPsolution(1:end-1);
    TSPsolution2 = TSPsolution1;
    TSPsolution2(shop2NewIndex) = TSPsolution1(shop1OriIndex);
    TSPsolution2(shop1OriIndex) = TSPsolution1(shop2NewIndex);
end
VRPsolution1 = ConvertToMultiVRPsolution(TSPsolution1,DemandVec,volume, ...
                                                            VehicleNum,O2OshopVec,O2OspotVec,O2OdemandVec , DistanceMatrix ,ecOrderNum , seperator);
VRPsolution2 = ConvertToMultiVRPsolution(TSPsolution2,DemandVec,volume, ...
                                                            VehicleNum,O2OshopVec,O2OspotVec,O2OdemandVec , DistanceMatrix ,ecOrderNum , seperator);
cost1 = CalculateMutiVRPtotalCost(VRPsolution1,DistanceMatrix,VehicleNum , ...
                                                                    PackageTimeVec , speed , StartTimeVec , EndTimeVec);     
cost2 = CalculateMutiVRPtotalCost(VRPsolution2,DistanceMatrix,VehicleNum , ...
                                                                    PackageTimeVec , speed , StartTimeVec , EndTimeVec);      
if cost1 < cost2 
    TSPsolution = TSPsolution1;
else
    TSPsolution = TSPsolution2;
end