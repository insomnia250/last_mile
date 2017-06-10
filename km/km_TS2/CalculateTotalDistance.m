function [TotalTimeCost , ArriveTime , DepartTime ,totalPunishTime , totalWaitTime] = CalculateTotalDistance (solution , DistanceMatrix , ...
                                                                             PackageTimeVec , speed , StartTimeVec , EndTimeVec)
numberofjourney = numel (solution) ;        %solution的地点数

ArriveTime=zeros(1,length(solution)) ;      %每个地点的到达时间
DepartTime= zeros(1,length(solution)) ;     %每个地点的离开时间
totalPunishTime=0 ;             %O2O晚于要求送到时间被惩罚的时间，不参与计算ArriveTime和DepartTime
totalDrivingTime=0;
totalWaitTime=0;
totalPackageTime=0;
for i = 2 : numberofjourney
    solution_i=solution(i);
    WaitTime=0 ;                        %本次O2O早于准备时间需等待的时间，参与计算DepartTime
    %本次到达时间=上次地点的离开时间+到本次地点赶路产生的时间
    DrivingTime=round(DistanceMatrix (solution (i-1), solution_i)/speed);
    totalDrivingTime=totalDrivingTime+DrivingTime;
    
    ArriveTime(i)=DepartTime(i-1)+DrivingTime; 
    
    %如果早于准备时间则需等待
    if ArriveTime(i)<StartTimeVec(solution_i)     
        WaitTime=StartTimeVec(solution_i)-ArriveTime(i);
        totalWaitTime=totalWaitTime+WaitTime;
    end
    %如果晚于要求时间则计算惩罚时间,超出部分的5倍
    if ArriveTime(i)>EndTimeVec(solution_i)           
        totalPunishTime=totalPunishTime+5*(ArriveTime(i)-EndTimeVec(solution_i));
    end
    PackageTime=PackageTimeVec(solution_i); 
    %本地点离开时间=本地点到达时间+早到等待时间+包裹处理时间
    DepartTime(i)=ArriveTime(i)+WaitTime+PackageTime;
    totalPackageTime=totalPackageTime+PackageTime;
    
end
%最终总时间代价=最后一个地点（有返回，返回1点）的ArriveTime+totalPunishTime
TotalTimeCost=totalDrivingTime+totalPunishTime+totalPackageTime;
end
