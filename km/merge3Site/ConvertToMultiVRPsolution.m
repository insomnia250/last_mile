%生成无返回的多车任务VRP矩阵
%SpotNum应为电商spot数+2*O2O订单数
function MutiVRPsolutionMaxtrix=ConvertToMultiVRPsolution(DistrTSPsolution,DemandVec,volume, VehicleNum,...
                                                                                                O2OshopVec,O2OspotVec,O2OdemandVec , DistanceMatrix , ecOrderNum , seperator1 , seperator2)
SpotNum=numel(DistrTSPsolution,DistrTSPsolution~=0);
zerosSpot=find(DistrTSPsolution==0);
zerosSpot=[zerosSpot SpotNum+VehicleNum+1];
MutiTSPsolutionMaxtrix=ones(VehicleNum,SpotNum+2);
tempNum=1;
for i=1:VehicleNum
    taskLength=zerosSpot(i+1)-tempNum-1;

    taskSpot = DistrTSPsolution(tempNum+1:zerosSpot(i+1)-1);
    
    ecSpot1 = taskSpot(find(taskSpot>3 & taskSpot<=ecOrderNum+3 , 1));
    if ~isempty(ecSpot1) && ecSpot1<=seperator1  %Site1
        MutiTSPsolutionMaxtrix(i , :) = 1;
    elseif ~isempty(ecSpot1) && ecSpot1>seperator1 && ecSpot1<=seperator2  %Site2电商
        MutiTSPsolutionMaxtrix(i , :) = 2;
    elseif ~isempty(ecSpot1) && ecSpot1>seperator2 && ecSpot1<=ecOrderNum+3  %Site3电商
        MutiTSPsolutionMaxtrix(i , :) = 3;
    elseif ~isempty(taskSpot) && DistanceMatrix(2 , taskSpot(1))<DistanceMatrix(1 , taskSpot(1))  && DistanceMatrix(2 , taskSpot(1))<DistanceMatrix(3 , taskSpot(1))%O2O离2最近
        MutiTSPsolutionMaxtrix(i , :) = 2;
    elseif ~isempty(taskSpot) && DistanceMatrix(3 , taskSpot(1))<DistanceMatrix(1 , taskSpot(1))  && DistanceMatrix(3 , taskSpot(1))<DistanceMatrix(2 , taskSpot(1))%O2O离3最近
        MutiTSPsolutionMaxtrix(i , :) = 3;
    end
    MutiTSPsolutionMaxtrix(i,2:1+taskLength)=taskSpot;
    tempNum=zerosSpot(i+1);
end


%考虑容量和需求，各车任务生成子回路
MutiVRPsolutionMaxtrix=ones(VehicleNum,2*SpotNum+1);
for i=1:VehicleNum
    MutiVRPsolutionMaxtrix(i,:)=ConvertToVRPSolution(MutiTSPsolutionMaxtrix(i,:), DemandVec, volume, ...
                                                                                O2OshopVec,O2OspotVec,O2OdemandVec);
end
end