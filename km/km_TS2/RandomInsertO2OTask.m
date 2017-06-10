function DistrTSPsolutionWithO2O = RandomInsertO2OTask(DistrTSPsolution,O2OshopVec,O2OspotVec)
if isempty(O2OshopVec)~=0  %如果没有O2O任务
    DistrTSPsolutionWithO2O=DistrTSPsolution;
else
    DistrTSPsolutionWithO2O=DistrTSPsolution;
    TaskNum=length(O2OspotVec);
    VehicleNum=numel(DistrTSPsolution, DistrTSPsolution == 0);
    CityNum=numel(DistrTSPsolution, DistrTSPsolution ~= 0);
    LastZeroSpot=CityNum+VehicleNum+1;
    zerosSpot=[find(DistrTSPsolution==0) LastZeroSpot];
    for i=1:TaskNum
        insertVehicleNum=randi(VehicleNum);  %选择该任务插入的哪辆车
        minNum=zerosSpot(insertVehicleNum);
        maxNum=zerosSpot(insertVehicleNum+1)-1;
%         zerosSpot
%         [insertVehicleNum minNum maxNum]
        insertSpot=randi([minNum,maxNum],1,2);
        shopInsertSpot=min(insertSpot);
        spotInsertSpot=max(insertSpot)+1;
        %插入shop
        DistrTSPsolutionWithO2O=[DistrTSPsolutionWithO2O(1:shopInsertSpot) O2OshopVec(i) ...
                                    DistrTSPsolutionWithO2O(shopInsertSpot+1:end)];
        DistrTSPsolutionWithO2O=[DistrTSPsolutionWithO2O(1:spotInsertSpot) O2OspotVec(i) ...
                                    DistrTSPsolutionWithO2O(spotInsertSpot+1:end)];
        LastZeroSpot=LastZeroSpot+2;
        zerosSpot=[find(DistrTSPsolutionWithO2O==0) LastZeroSpot];
    end
end