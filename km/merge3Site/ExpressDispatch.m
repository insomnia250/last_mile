function DispatchMatrix=ExpressDispatch(solution,OrderInfo,ArriveTime,DepartTime,DemandVec, CourierID , ECspotVec , O2OshopVec)
%订单信息中的order唯一编号，也是目标配送点的唯一编号（即使同一坐标的配送点也应有不同的编号）
AllOrderTargetId=OrderInfo(1,:);   
%订单信息中每单对应的取货地点编号，相同坐标编号相同
AllOrderStartSiteId=OrderInfo(2,:);
%订单编号，唯一，
AllOrderID=OrderInfo(3,:);

DispatchMatrix=[];
Site = solution(1);
lastIndex = find(solution>2, 1, 'last' );      %最后一个不是 1 的地点索引
solution = [solution(1:lastIndex) Site];   %结尾补1
siteIndex =find(solution==Site);   %所有1的位置

for i =1 : (length(solution)-1)
    if solution(i) == Site
        siteEndIndex = siteIndex(find(siteIndex>i , 1 , 'first'));   %找到下一个 1 的位置
        tempPartSolution = solution(i : siteEndIndex-1);
        ecOrderSpot = tempPartSolution(ismember(tempPartSolution , ECspotVec));            %该段应送的 电商 地点代号 
        for j = 1:length(ecOrderSpot)
            %信使ID，到达地点，到达时间，离开时间，包裹数量，订单编号
            OrderId = AllOrderID( find(AllOrderTargetId == ecOrderSpot(j) , 1 ,'first') );     %通过每个订单起点编号 找 对应的 订单 编号
            DispatchInfo = [CourierID , Site ,  ArriveTime(i) , DepartTime(i) , DemandVec( ecOrderSpot(j) ) , OrderId];
            DispatchMatrix = [DispatchMatrix ; DispatchInfo];
        end
    elseif ismember(solution(i) , O2OshopVec)%如果是电商 shop
        OrderId = AllOrderID( find(AllOrderStartSiteId == solution(i) , 1 ,'first') );       %通过每个订单起点编号 找 对应的 订单 编号
        demand = DemandVec( solution(i) + length(O2OshopVec) );
        DispatchInfo = [CourierID , solution(i) ,  ArriveTime(i) , DepartTime(i) , demand , OrderId];
        DispatchMatrix = [DispatchMatrix ; DispatchInfo];
    else
        OrderId = AllOrderID( find(AllOrderTargetId == solution(i) , 1 ,'first') );       %对应的 订单 编号
        DispatchInfo = [CourierID , solution(i) ,  ArriveTime(i) , DepartTime(i) , -DemandVec( solution(i) ) , OrderId];
        DispatchMatrix = [DispatchMatrix ; DispatchInfo];
    end
end