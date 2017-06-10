%对有序的任务矩阵 生成概率模型 , 以(v,t)元素为中心
%对有序的任务矩阵 生成概率模型 , 以(v,t)元素为中心
% function [t , row ,col] = PerformTaskSWAP( TaskMatrix  , o2oOrderNum, OriVec , dm)
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
%     ProbMatrix(TaskMatrix==0)=0;
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
%     [row,col] = find(ReigionMatrix>rand,1);       
% %         row=1;
% 
% 
% else  %如果是电商
%     VirtualDistanceMatrix =zeros(VehicleNum , OrderNum);
% 
%     if v >= dm
%         VirtualDistanceMatrix(:,t) = [OriVec((dm+VehicleNum - v +1) : VehicleNum) , OriVec(1 : dm+VehicleNum - v)];
%     else
%         VirtualDistanceMatrix(:,t) = [OriVec((dm - v +1) : VehicleNum) , OriVec(1 : dm - v)];
%     end
%         
% 
%     
%     VirtualDistanceMatrix = repmat(VirtualDistanceMatrix(:,t) , 1,OrderNum);
%     
%     VirtualDistanceMatrix = VirtualDistanceMatrix+1;
%     
%     ProbMatrix = 1./VirtualDistanceMatrix;
%     ProbMatrix(TaskMatrix==0)=0;
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
%     
%     [row,col] = find(ReigionMatrix>rand,1);       
% end
% 
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% end
% VehicleNum = 100;
% o2oOrderNum = 600;
% ecOrderNum = 153;
% dm = round(VehicleNum/2);
% OriVec = [(fix(VehicleNum/2) : -1 : 1) , 0 , (1 : fix(VehicleNum/2))];
% OriVec = OriVec(1 : VehicleNum);
% OriVec = OriVec(end:-1:1);
% 
% TaskMatrix = GenerateTaskMaxtrix(VehicleNum ,  o2oOrderNum , ecOrderNum);
% for i =1:10000
%         [t , row] = PerformTaskRAR( TaskMatrix  , o2oOrderNum , OriVec , dm);
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       交换两个任务的分配，仅限于Vehicle 大于 1

function [newTaskVec , task1 , task2 ] = PerformTaskSWAP( TaskVec  , ecOrderNum , o2oOrderNum) 

if length(unique(TaskVec)) == 1
    newTaskVec = TaskVec;
    task1 = 0;
    task2 = 0;
    return
end


task1 = randi(o2oOrderNum + ecOrderNum -1) + 1;  %随机选中一个不是任务1的任务
task2 = randi(o2oOrderNum + ecOrderNum -1) + 1;  %随机选中一个不是任务1的任务il
vehicle1 = TaskVec(task1);
vehicle2 = TaskVec(task2);

while(vehicle1 == vehicle2 )
    task1 = randi(o2oOrderNum + ecOrderNum -1) + 1;  %随机选中一个不是任务1的任务
    task2 = randi(o2oOrderNum + ecOrderNum -1) + 1;  %随机选中一个不是任务1的任务il
    vehicle1 = TaskVec(task1);
    vehicle2 = TaskVec(task2);   
end
newTaskVec = TaskVec;
newTaskVec(task1) = TaskVec(task2);
newTaskVec(task2) = TaskVec(task1);
