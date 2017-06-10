%对有序的任务矩阵 生成概率模型 , 以(v,t)元素为中心
% function [t , row] = PerformTaskRAR( TaskMatrix  , o2oOrderNum, OriVec , dm)
% 
% [VehicleNum , OrderNum] = size(TaskMatrix);
% 
% t = randi(OrderNum); t=2;
% v = find(TaskMatrix(:,t)==1);
% 
% if t <= o2oOrderNum
%     VirtualDistanceMatrix =zeros(VehicleNum , OrderNum);
% 
%     if v >= dm
%         VirtualDistanceMatrix(:,t) = [OriVec((dm+VehicleNum - v +1) : VehicleNum) , OriVec(1 : dm+VehicleNum - v)];
%     else
%         VirtualDistanceMatrix(:,t) = [OriVec((dm - v +1) : VehicleNum) , OriVec(1 : dm - v)];
%     end
%         
%     for i =1: t-1
%         VirtualDistanceMatrix(:,i) = VirtualDistanceMatrix(:,t) + (t-i);
%     end
%     for i  = t+1 : o2oOrderNum
%         VirtualDistanceMatrix(:,i) = VirtualDistanceMatrix(:,t) + (i-t);
%     end
% 
%     meanDistance = mean(VirtualDistanceMatrix(v , 1:o2oOrderNum));
%     
%     VirtualDistanceMatrix(:,(o2oOrderNum+1) : OrderNum )  = repmat(VirtualDistanceMatrix(:,t) , 1,OrderNum - o2oOrderNum)+meanDistance;
%     
%     VirtualDistanceMatrix = VirtualDistanceMatrix+1;
%     ProbMatrix = 1./VirtualDistanceMatrix;
%     ProbMatrix(TaskMatrix==1)=0;
%     ProbMatrix(v,:)=0;
%     ProbMatrix = ProbMatrix/sum(sum(ProbMatrix));
% 
%     ReigionMatrix = zeros(VehicleNum , OrderNum);
% 
%     tempSum = 0;
%     for i = 1:OrderNum
%         ReigionMatrix(:,i) = cumsum(ProbMatrix(:,i)) + tempSum;
%         tempSum=ReigionMatrix(end,i);
%     end
%     [row,~] = find(ReigionMatrix>rand,1);       
% %         row=1;
% else  %如果是电商
%     if v >= dm
%         VirtualDistanceVec = [OriVec((dm+VehicleNum - v +1) : VehicleNum) , OriVec(1 : dm+VehicleNum - v)]';
%     else
%         VirtualDistanceVec = [OriVec((dm - v +1) : VehicleNum) , OriVec(1 : dm - v)]';
%     end
%      VirtualDistanceVec = VirtualDistanceVec + sum(TaskMatrix , 2);
%     
% %     for i = 1:VehicleNum
% %             VirtualDistanceVec(i,1)=min([abs(i-v),abs(i-v+VehicleNum),abs(i-v-VehicleNum)]);
% %             VirtualDistanceVec(i,1) = VirtualDistanceVec(i,1) + sum(TaskMatrix(i,:));
% %     end
%     
%     VirtualDistanceVec = VirtualDistanceVec+1;
%     
%     ProbVec = 1./VirtualDistanceVec;
%     ProbVec(v,1) = 0;
%     ProbVec = cumsum(ProbVec/sum(ProbVec));
%     
%     row = find(ProbVec>rand,1);
% end
% 
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% dm = round(VehicleNum/2);
% OriVec = [(fix(VehicleNum/2) : -1 : 1) , 0 , (1 : fix(VehicleNum/2))];
% OriVec = OriVec(1 : VehicleNum);
% OriVec = OriVec(end:-1:1);
% 
% % TaskMatrix = GenerateTaskMaxtrix(VehicleNum ,  o2oOrderNum , ecOrderNum);
% record = zeros(VehicleNum , 7);
% for i =1:10000
%     i
%         [t , row , col] = PerformTaskSWAP( TaskMatrix  , o2oOrderNum , OriVec , dm);
%         record(row,col) = record(row,col)+1;
% end

 function [newTaskVec , task1 , newVehicle ] = PerformTaskRAR( TaskVec  , o2oOrderNum, ecOrderNum ,VehicleNum) 
 task1 = randi(o2oOrderNum + ecOrderNum -1) + 1;  %随机选中一个不是任务1的任务
 vehicle = TaskVec(task1);
newVehicle = randi(VehicleNum);

 while newVehicle == vehicle
     newVehicle = randi(VehicleNum);
 end
 newTaskVec = TaskVec;
 newTaskVec(task1) = newVehicle;
 
 
 
 
 
 
 
 
 
 
 
 
 
