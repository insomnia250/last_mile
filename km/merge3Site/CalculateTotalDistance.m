function [TotalTimeCost , ArriveTime , DepartTime ,totalPunishTime , totalWaitTime] = CalculateTotalDistance (solution , DistanceMatrix , ...
                                                                             PackageTimeVec , speed , StartTimeVec , EndTimeVec)
numberofjourney = numel (solution) ;        %solution�ĵص���
% PackageTimeVec=3*DemandVec.^0.5+5;      %����demand��ÿ���ص�İ�������ʱ��
% PackageTimeVec(ismember(1:length(DemandVec),[SiteVec,O2OshopVec]))=0;       %������ȡ��ʱ��Site,Shop���޴���ʱ��
ArriveTime=zeros(1,length(solution)) ;      %ÿ���ص�ĵ���ʱ��
DepartTime= zeros(1,length(solution)) ;     %ÿ���ص���뿪ʱ��
totalPunishTime=0 ;             %O2O����Ҫ���͵�ʱ�䱻�ͷ���ʱ�䣬���������ArriveTime��DepartTime
totalDrivingTime=0;
totalWaitTime=0;
totalPackageTime=0;
for i = 2 : numberofjourney
    solution_i=solution(i);
    WaitTime=0 ;                        %����O2O����׼��ʱ����ȴ���ʱ�䣬�������DepartTime
    %���ε���ʱ��=�ϴεص���뿪ʱ��+�����εص��·������ʱ��
    DrivingTime=round(DistanceMatrix (solution (i-1), solution_i)/speed);
    totalDrivingTime=totalDrivingTime+DrivingTime;
    
    ArriveTime(i)=DepartTime(i-1)+DrivingTime; 
    
    %�������׼��ʱ������ȴ�
    if ArriveTime(i)<StartTimeVec(solution_i)     
        WaitTime=StartTimeVec(solution_i)-ArriveTime(i);
        totalWaitTime=totalWaitTime+WaitTime;
    end
    %�������Ҫ��ʱ�������ͷ�ʱ��,�������ֵ�5��
    if ArriveTime(i)>EndTimeVec(solution_i)           
        totalPunishTime=totalPunishTime+5*(ArriveTime(i)-EndTimeVec(solution_i));
    end
    PackageTime=PackageTimeVec(solution_i); 
    %���ص��뿪ʱ��=���ص㵽��ʱ��+�絽�ȴ�ʱ��+��������ʱ��
    DepartTime(i)=ArriveTime(i)+WaitTime+PackageTime;
    totalPackageTime=totalPackageTime+PackageTime;
    
end
%������ʱ�����=���һ���ص㣨�з��أ�����1�㣩��ArriveTime+totalPunishTime
TotalTimeCost=totalDrivingTime+totalPunishTime+totalPackageTime;

end
