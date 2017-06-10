function DispatchMatrix=ExpressDispatch(solution,OrderInfo,ArriveTime,DepartTime,DemandVec, CourierID)
%订单信息中的order唯一编号，也是目标配送点的唯一编号（即使同一坐标的配送点也应有不同的编号）
OrderTargetId=OrderInfo(1,:);   
%订单信息中每单对应的取货地点编号，相同坐标编号相同
OrderStartSiteId=OrderInfo(2,:);
%订单编号，唯一，
OrderID=OrderInfo(3,:);
%solution中出现的订单信息中的订单（配送点编号）
TargetSpotsInSolution=solution(ismember(solution,OrderTargetId));
TaskOrderLength=length(TargetSpotsInSolution);
%调度方案，有送必有取长度为2*length(TargetSpotsInSolution),内容包括 信使ID，到达地点，到达时间，离开时间，包裹数量，订单编号
DispatchMatrix=zeros(2*TaskOrderLength,6);
for i=1 : TaskOrderLength
    targetSpot=TargetSpotsInSolution(i);            %该订单（收货地点）编号，唯一
    targetOrderID=OrderID(ismember(OrderTargetId,targetSpot));
    startSite=OrderStartSiteId(ismember(OrderTargetId,targetSpot));     %该订单的取货网点（或O2Oshop）编号
    targetSpotArriveTime=ArriveTime(ismember(solution,targetSpot)); %该订单的ArriveTime
    targetSpotDepartTime=DepartTime(ismember(solution,targetSpot)); %该订单的DepartTime
    targetSpotDemand=DemandVec(targetSpot); %该订单包裹量
    %送货
    DispatchMatrix(TaskOrderLength+i,:)=[CourierID , targetSpot , targetSpotArriveTime , targetSpotDepartTime , -targetSpotDemand , targetOrderID];
    %取货
    %找到该订单在solution中的对应取货点
    targetSpotIndex=find(solution==targetSpot);
    allStartSiteIndex=find(solution==startSite);    %solution中所有该spot对应site在solution中的位置
    %离target最近，且index小于target的Index的site在allStartSiteIndex中的位置，即为该target的取货site在solution中的位置
    startSiteIndex=allStartSiteIndex(find(allStartSiteIndex<targetSpotIndex, 1, 'last' ));
    startSiteArriveTime=ArriveTime(startSiteIndex);
    startSiteDepartTime=DepartTime(startSiteIndex);
    DispatchMatrix(i,:)=[CourierID , startSite , startSiteArriveTime , startSiteDepartTime , targetSpotDemand , targetOrderID];
end
end