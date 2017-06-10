function [splitedTSPSolution , newVehicleNum]= VRP_Split_Route(VRPsolution , O2OshopVec)
splitedTSPSolution = [];
[oriVehicleNum , n] = size(VRPsolution);
newVehicleNum = 0;
for i =1 : oriVehicleNum
    route = VRPsolution(i , :);
    if sum(ismember(O2OshopVec , route))==0 && sum(route)>n %如果该快递员任务中不含有O2O,且不是空路
        index1 = 1;   %index1存储上一个1的位置
        for j = 2 : n
            if route(j)==1
                if j - index1>1  %遇到1，且和上一个 1 之间 有实际spot时
                    index2 = j;
                    newSplitRoute  = route(index1+1 : index2-1);
                    newVehicleNum = newVehicleNum + 1;
                    splitedTSPSolution = [splitedTSPSolution 0 newSplitRoute]; %添加快递员 和 分裂出的 任务路径
                end
                index1 = j;
            end
        end  %for
    elseif   sum(route)>n%如果有O2O任务 且不是空路
        newVehicleNum = newVehicleNum + 1;
        newSplitRoute = route(route~=1);  %表示实际spot 的点
        splitedTSPSolution = [splitedTSPSolution 0 newSplitRoute];      %添加快递员和 任务
    end  %if 不含 O2O    
end

% function [splitedTSPSolution , newVehicleNum]= VRP_Split_Route(VRPsolution , O2OshopVec , O2OspotVec)
% splitedTSPSolution = [];
% [oriVehicleNum , n] = size(VRPsolution);
% newVehicleNum = 0;
% for i =1 : oriVehicleNum
%     route = VRPsolution(i , :);
%     if sum(ismember(O2OshopVec , route))==0 && sum(route)>n %如果该快递员任务中不含有O2O,且不是空路
%         index1 = 1;   %index1存储上一个1的位置
%         for j = 2 : n
%             if route(j)==1
%                 if j - index1>1  %遇到1，且和上一个 1 之间 有实际spot时
%                     index2 = j;
%                     newSplitRoute  = route(index1+1 : index2-1);
%                     newVehicleNum = newVehicleNum + 1;
%                     splitedTSPSolution = [splitedTSPSolution 0 newSplitRoute]; %添加快递员 和 分裂出的 任务路径
%                 end
%                 index1 = j;
%             end
%         end  %for
%     elseif   sum(route)>n%如果有O2O任务 且不是空路     
%         index1 = 1;   % 存储 当前一小段 回路 的 起始1 的位置
%         for j = 2 : n
%             if route(j)==1
%                 if route(j-1)~=1  %遇到1，且和上一个 1 之间 有实际spot时
%                     index2 = j;
%                     loop = route(index1+1 : index2-1);      %当前回路
%                     ShopsInLoop = loop(ismember(loop , O2OshopVec));          % 回路loop中的O2O shop
%                     SpotsInLoop = loop(ismember(loop , O2OspotVec));            %回路中的 O2Ospot
%                     if length(ShopsInLoop) == length(SpotsInLoop)       %如果长度相同
%                         if length(intersect((ShopsInLoop+length(O2OshopVec)),SpotsInLoop)) == length(SpotsInLoop)  %shop 和 spot一 一对应
%                             newSplitRoute  = route(index1+1 : index2-1);
%                             newVehicleNum = newVehicleNum + 1;
%                             splitedTSPSolution = [splitedTSPSolution 0 newSplitRoute]; %添加快递员 和 分裂出的 任务路径
%                             index1 = j;
%                         end
%                     end
% %                     newSplitRoute  = route(index1+1 : index2-1);
% %                     newVehicleNum = newVehicleNum + 1;
% %                     splitedTSPSolution = [splitedTSPSolution 0 newSplitRoute]; %添加快递员 和 分裂出的 任务路径
%                 end
%                 
%             end
%         end
%     end  %if 不含 O2O    
% end
