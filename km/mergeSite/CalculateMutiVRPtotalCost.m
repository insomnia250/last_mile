%�ܴ��ۼ��㣬�޷��أ������͵��������ʱ�䣬ȡ�೵�����ֵ
function [totalCost , ArriveTimeMatrix , DepartTimeMatrix ,totalPunish , totalWait]= CalculateMutiVRPtotalCost (MutiVRPsolutionMaxtrix , DistanceMatrix, ...
                                                                                                         VehicleNum, PackageTimeVec, speed , StartTimeVec , EndTimeVec)
                                                                                                 
MutiTotalCost=zeros(VehicleNum,1);
MutiTotalPunish=zeros(VehicleNum,1);
MutiTotalWait=zeros(VehicleNum,1);

ArriveTimeMatrix=zeros(VehicleNum,length(MutiVRPsolutionMaxtrix(1,:)));
DepartTimeMatrix=zeros(VehicleNum,length(MutiVRPsolutionMaxtrix(1,:)));
for i=1:VehicleNum
    Site = MutiVRPsolutionMaxtrix(i,1);
    SpotNum=find(MutiVRPsolutionMaxtrix(i,:)>2);
    if isempty(SpotNum)     %���û�о����κνڵ�
        LastSpot=MutiVRPsolutionMaxtrix(i,1);
    else
        LastSpot=MutiVRPsolutionMaxtrix(i,SpotNum(end));
    end
    [MutiTotalCost(i,1) , ArriveTimeMatrix(i,:) , DepartTimeMatrix(i,:) , MutiTotalPunish(i,1) , MutiTotalWait(i,1)]=CalculateTotalDistance ...
                                (MutiVRPsolutionMaxtrix(i,:) , DistanceMatrix  , PackageTimeVec , speed , StartTimeVec , EndTimeVec);
    MutiTotalCost(i,1)=MutiTotalCost(i,1)-round(DistanceMatrix(LastSpot,Site)/speed);   %�޷��أ���ȥ���һ�����͵㵽ԭ��ľ���

end
totalCost=sum(MutiTotalCost)+sum(MutiTotalWait);
totalPunish=sum(MutiTotalPunish);
totalWait=sum(MutiTotalWait);
end