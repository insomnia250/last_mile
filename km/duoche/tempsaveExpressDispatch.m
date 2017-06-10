function DispatchMatrix=ExpressDispatch(solution,OrderInfo,ArriveTime,DepartTime,DemandVec, CourierID)
%������Ϣ�е�orderΨһ��ţ�Ҳ��Ŀ�����͵��Ψһ��ţ���ʹͬһ��������͵�ҲӦ�в�ͬ�ı�ţ�
OrderTargetId=OrderInfo(1,:);   
%������Ϣ��ÿ����Ӧ��ȡ���ص��ţ���ͬ��������ͬ
OrderStartSiteId=OrderInfo(2,:);
%������ţ�Ψһ��
OrderID=OrderInfo(3,:);
%solution�г��ֵĶ�����Ϣ�еĶ��������͵��ţ�
TargetSpotsInSolution=solution(ismember(solution,OrderTargetId));
TaskOrderLength=length(TargetSpotsInSolution);
%���ȷ��������ͱ���ȡ����Ϊ2*length(TargetSpotsInSolution),���ݰ��� ��ʹID������ص㣬����ʱ�䣬�뿪ʱ�䣬�����������������
DispatchMatrix=zeros(2*TaskOrderLength,6);
for i=1 : TaskOrderLength
    targetSpot=TargetSpotsInSolution(i);            %�ö������ջ��ص㣩��ţ�Ψһ
    targetOrderID=OrderID(ismember(OrderTargetId,targetSpot));
    startSite=OrderStartSiteId(ismember(OrderTargetId,targetSpot));     %�ö�����ȡ�����㣨��O2Oshop�����
    targetSpotArriveTime=ArriveTime(ismember(solution,targetSpot)); %�ö�����ArriveTime
    targetSpotDepartTime=DepartTime(ismember(solution,targetSpot)); %�ö�����DepartTime
    targetSpotDemand=DemandVec(targetSpot); %�ö���������
    %�ͻ�
    DispatchMatrix(TaskOrderLength+i,:)=[CourierID , targetSpot , targetSpotArriveTime , targetSpotDepartTime , -targetSpotDemand , targetOrderID];
    %ȡ��
    %�ҵ��ö�����solution�еĶ�Ӧȡ����
    targetSpotIndex=find(solution==targetSpot);
    allStartSiteIndex=find(solution==startSite);    %solution�����и�spot��Ӧsite��solution�е�λ��
    %��target�������indexС��target��Index��site��allStartSiteIndex�е�λ�ã���Ϊ��target��ȡ��site��solution�е�λ��
    startSiteIndex=allStartSiteIndex(find(allStartSiteIndex<targetSpotIndex, 1, 'last' ));
    startSiteArriveTime=ArriveTime(startSiteIndex);
    startSiteDepartTime=DepartTime(startSiteIndex);
    DispatchMatrix(i,:)=[CourierID , startSite , startSiteArriveTime , startSiteDepartTime , targetSpotDemand , targetOrderID];
end
end