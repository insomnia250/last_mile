%�����޷��صĶ೵����VRP����
%SpotNumӦΪ����spot��+2*O2O������
function MutiVRPsolutionMaxtrix=ConvertToMultiVRPsolution(DistrTSPsolution,DemandVec,volume, VehicleNum,...
                                                                                                O2OshopVec,O2OspotVec,O2OdemandVec , DistanceMatrix , ecOrderNum , seperator)
SpotNum=numel(DistrTSPsolution,DistrTSPsolution~=0);
zerosSpot=find(DistrTSPsolution==0);
zerosSpot=[zerosSpot SpotNum+VehicleNum+1];
MutiTSPsolutionMaxtrix=ones(VehicleNum,SpotNum+2);
tempNum=1;
for i=1:VehicleNum
    taskLength=zerosSpot(i+1)-tempNum-1;
    taskSpot = DistrTSPsolution(tempNum+1:zerosSpot(i+1)-1);
    ecSpot1 = taskSpot(find(taskSpot>2 & taskSpot<=ecOrderNum+2 , 1));
    if ~isempty(ecSpot1) && ecSpot1<=seperator  %Site1
        MutiTSPsolutionMaxtrix(i , :) = 1;
    elseif ~isempty(ecSpot1) && ecSpot1>seperator && ecSpot1<=ecOrderNum+2  %Site2
        MutiTSPsolutionMaxtrix(i , :) = 2;
    elseif ~isempty(taskSpot) && DistanceMatrix(1 , taskSpot(1))>DistanceMatrix(2 , taskSpot(1))
        MutiTSPsolutionMaxtrix(i , :) = 2;
    end
    MutiTSPsolutionMaxtrix(i,2:1+taskLength)=taskSpot;
    tempNum=zerosSpot(i+1);
end


%�������������󣬸������������ӻ�·
MutiVRPsolutionMaxtrix=ones(VehicleNum,2*SpotNum+1);
for i=1:VehicleNum
    MutiVRPsolutionMaxtrix(i,:)=ConvertToVRPSolution(MutiTSPsolutionMaxtrix(i,:), DemandVec, volume, ...
                                                                                O2OshopVec,O2OspotVec,O2OdemandVec);
end
end