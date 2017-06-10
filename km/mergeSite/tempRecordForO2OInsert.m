%%
% function [SolusiInsert , Kota_1 , Kota_2] = PerformO2OInsert(TSPsolution , VehicleNum , O2OshopVec , O2OspotVec)
O2ONum = numel(O2OshopVec);
NewVehicleNum =randi( VehicleNum);
O2OIndex = randi(O2ONum);
Kota_1=O2OIndex;
Kota_2 = NewVehicleNum;
SolusiInsert=TSPsolution;
shopId=O2OshopVec(O2OIndex);
spotId=O2OspotVec(O2OIndex);
zerosSpot=find(TSPsolution==0);

NewVehicleIndex=zerosSpot(NewVehicleNum);
shopOriIndex=find(SolusiInsert==shopId,1);

if  NewVehicleIndex<shopOriIndex      %如果在左边，则先插spot
    spotOriIndex=find(SolusiInsert==spotId,1);
    SolusiInsert=Insert(SolusiInsert,spotOriIndex,NewVehicleIndex+1);
    shopOriIndex=find(SolusiInsert==shopId,1);
    SolusiInsert=Insert(SolusiInsert,shopOriIndex,NewVehicleIndex+1);
else
    shopOriIndex=find(SolusiInsert==shopId,1);
    SolusiInsert=Insert(SolusiInsert,shopOriIndex,NewVehicleIndex);
    spotOriIndex=find(SolusiInsert==spotId,1);
    SolusiInsert=Insert(SolusiInsert,spotOriIndex,NewVehicleIndex);
end