function DispatchMatrix=ExpressDispatch(solution,OrderInfo,ArriveTime,DepartTime,DemandVec, CourierID , ECspotVec , O2OshopVec)
%������Ϣ�е�orderΨһ��ţ�Ҳ��Ŀ�����͵��Ψһ��ţ���ʹͬһ��������͵�ҲӦ�в�ͬ�ı�ţ�
AllOrderTargetId=OrderInfo(1,:);   
%������Ϣ��ÿ����Ӧ��ȡ���ص��ţ���ͬ��������ͬ
AllOrderStartSiteId=OrderInfo(2,:);
%������ţ�Ψһ��
AllOrderID=OrderInfo(3,:);

DispatchMatrix=[];

lastIndex = find(solution~=1, 1, 'last' );      %���һ������ 1 �ĵص�����
solution = [solution(1:lastIndex) 1];   %��β��1
siteIndex =find(solution==1);   %����1��λ��

for i =1 : (length(solution)-1)
    if solution(i) == 1
        siteEndIndex = siteIndex(find(siteIndex>i , 1 , 'first'));   %�ҵ���һ�� 1 ��λ��
        tempPartSolution = solution(i : siteEndIndex-1);
        ecOrderSpot = tempPartSolution(ismember(tempPartSolution , ECspotVec));            %�ö�Ӧ�͵� ���� �ص���� 
        for j = 1:length(ecOrderSpot)
            %��ʹID������ص㣬����ʱ�䣬�뿪ʱ�䣬�����������������
            OrderId = AllOrderID( find(AllOrderTargetId == ecOrderSpot(j) , 1 ,'first') );     %ͨ��ÿ����������� �� ��Ӧ�� ���� ���
            DispatchInfo = [CourierID , 1 ,  ArriveTime(i) , DepartTime(i) , DemandVec( ecOrderSpot(j) ) , OrderId];
            DispatchMatrix = [DispatchMatrix ; DispatchInfo];
        end
    elseif ismember(solution(i) , O2OshopVec)%����ǵ��� shop
        OrderId = AllOrderID( find(AllOrderStartSiteId == solution(i) , 1 ,'first') );       %ͨ��ÿ����������� �� ��Ӧ�� ���� ���
        demand = DemandVec( solution(i) + length(O2OshopVec) );
        DispatchInfo = [CourierID , solution(i) ,  ArriveTime(i) , DepartTime(i) , demand , OrderId];
        DispatchMatrix = [DispatchMatrix ; DispatchInfo];
    else
        OrderId = AllOrderID( find(AllOrderTargetId == solution(i) , 1 ,'first') );       %��Ӧ�� ���� ���
        DispatchInfo = [CourierID , solution(i) ,  ArriveTime(i) , DepartTime(i) , -DemandVec( solution(i) ) , OrderId];
        DispatchMatrix = [DispatchMatrix ; DispatchInfo];
    end
end