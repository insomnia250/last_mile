%生成无返回的多车任务VRP矩阵
%SpotNum应为电商spot数+2*O2O订单数
function MutiVRPsolutionMaxtrix=ConvertToMultiVRPsolution(DistrTSPsolution,DemandVec,volume, VehicleNum,...
                                                                                                O2OshopVec,O2OspotVec,O2OdemandVec)
SpotNum=numel(DistrTSPsolution,DistrTSPsolution~=0);
zerosSpot=find(DistrTSPsolution==0);
zerosSpot=[zerosSpot SpotNum+VehicleNum+1];
MutiTSPsolutionMaxtrix=ones(VehicleNum,SpotNum+2);
tempNum=1;
for i=1:VehicleNum
    taskLength=zerosSpot(i+1)-tempNum-1;
    MutiTSPsolutionMaxtrix(i,2:1+taskLength)=DistrTSPsolution(tempNum+1:zerosSpot(i+1)-1);
    tempNum=zerosSpot(i+1);
end
%考虑容量和需求，各车任务生成子回路
MutiVRPsolutionMaxtrix=ones(VehicleNum,2*SpotNum+1);
for i=1:VehicleNum
    MutiVRPsolutionMaxtrix(i,:)=ConvertToVRPSolution(MutiTSPsolutionMaxtrix(i,:), DemandVec, volume, ...
                                                                                O2OshopVec,O2OspotVec,O2OdemandVec);
end
end