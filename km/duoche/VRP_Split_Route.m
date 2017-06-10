function [splitedTSPSolution , newVehicleNum]= VRP_Split_Route(VRPsolution , O2OshopVec)
splitedTSPSolution = [];
[oriVehicleNum , n] = size(VRPsolution);
newVehicleNum = 0;
for i =1 : oriVehicleNum
    route = VRPsolution(i , :);
    if sum(ismember(O2OshopVec , route))==0 && sum(route)>n %����ÿ��Ա�����в�����O2O,�Ҳ��ǿ�·
        index1 = 1;   %index1�洢��һ��1��λ��
        for j = 2 : n
            if route(j)==1
                if j - index1>1  %����1���Һ���һ�� 1 ֮�� ��ʵ��spotʱ
                    index2 = j;
                    newSplitRoute  = route(index1+1 : index2-1);
                    newVehicleNum = newVehicleNum + 1;
                    splitedTSPSolution = [splitedTSPSolution 0 newSplitRoute]; %��ӿ��Ա �� ���ѳ��� ����·��
                end
                index1 = j;
            end
        end  %for
    elseif   sum(route)>n%�����O2O���� �Ҳ��ǿ�·
        newVehicleNum = newVehicleNum + 1;
        newSplitRoute = route(route~=1);  %��ʾʵ��spot �ĵ�
        splitedTSPSolution = [splitedTSPSolution 0 newSplitRoute];      %��ӿ��Ա�� ����
    end  %if ���� O2O    
end

% function [splitedTSPSolution , newVehicleNum]= VRP_Split_Route(VRPsolution , O2OshopVec , O2OspotVec)
% splitedTSPSolution = [];
% [oriVehicleNum , n] = size(VRPsolution);
% newVehicleNum = 0;
% for i =1 : oriVehicleNum
%     route = VRPsolution(i , :);
%     if sum(ismember(O2OshopVec , route))==0 && sum(route)>n %����ÿ��Ա�����в�����O2O,�Ҳ��ǿ�·
%         index1 = 1;   %index1�洢��һ��1��λ��
%         for j = 2 : n
%             if route(j)==1
%                 if j - index1>1  %����1���Һ���һ�� 1 ֮�� ��ʵ��spotʱ
%                     index2 = j;
%                     newSplitRoute  = route(index1+1 : index2-1);
%                     newVehicleNum = newVehicleNum + 1;
%                     splitedTSPSolution = [splitedTSPSolution 0 newSplitRoute]; %��ӿ��Ա �� ���ѳ��� ����·��
%                 end
%                 index1 = j;
%             end
%         end  %for
%     elseif   sum(route)>n%�����O2O���� �Ҳ��ǿ�·     
%         index1 = 1;   % �洢 ��ǰһС�� ��· �� ��ʼ1 ��λ��
%         for j = 2 : n
%             if route(j)==1
%                 if route(j-1)~=1  %����1���Һ���һ�� 1 ֮�� ��ʵ��spotʱ
%                     index2 = j;
%                     loop = route(index1+1 : index2-1);      %��ǰ��·
%                     ShopsInLoop = loop(ismember(loop , O2OshopVec));          % ��·loop�е�O2O shop
%                     SpotsInLoop = loop(ismember(loop , O2OspotVec));            %��·�е� O2Ospot
%                     if length(ShopsInLoop) == length(SpotsInLoop)       %���������ͬ
%                         if length(intersect((ShopsInLoop+length(O2OshopVec)),SpotsInLoop)) == length(SpotsInLoop)  %shop �� spotһ һ��Ӧ
%                             newSplitRoute  = route(index1+1 : index2-1);
%                             newVehicleNum = newVehicleNum + 1;
%                             splitedTSPSolution = [splitedTSPSolution 0 newSplitRoute]; %��ӿ��Ա �� ���ѳ��� ����·��
%                             index1 = j;
%                         end
%                     end
% %                     newSplitRoute  = route(index1+1 : index2-1);
% %                     newVehicleNum = newVehicleNum + 1;
% %                     splitedTSPSolution = [splitedTSPSolution 0 newSplitRoute]; %��ӿ��Ա �� ���ѳ��� ����·��
%                 end
%                 
%             end
%         end
%     end  %if ���� O2O    
% end
