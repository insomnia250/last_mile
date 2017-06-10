%   检查分配是否合法，需满足：
%   1.不存在因为积存未送出的O2O包裹导致永远无法再拿下一个订单包裹的BUG
%   2.最后一个元素不能为0
%   3.任意两0元素不能相邻
%   4.同一单O2O必须先到shop，再到spot
%   5.O2O同一单的shop和spot必须分在同一个人的任务中
function isIllegal=CheckDitrTSPsolution(DistrTSPsolution,O2OshopVec,O2OspotVec , ecDemandVec , O2OdemandVec , volume)

if isempty(O2OshopVec) 
    maxO2OShop_id=-2;
    minO2OShop_id=-1;
    maxO2OSpot_id=-2;
    minO2OSpot_id=-2;
else
    maxO2OShop_id=O2OshopVec(end);
    minO2OShop_id=O2OshopVec(1);
    maxO2OSpot_id=O2OspotVec(end);
    minO2OSpot_id=O2OspotVec(1);
end
O2Oaccumulate=0;
%对每个节点进行检查（DistrTSPsolution中有0表示每个信使的任务
for i =1: length(DistrTSPsolution)
    DistrTSPsolution_i=DistrTSPsolution(i);
    %如果是0，则表示一个新的信使的任务，进行初始化
    if DistrTSPsolution_i==0
        O2Oaccumulate=0;        %积存的O2O包裹
        
    %如果是O2Ospot，则不会出现BUG，并且减少积存
    elseif DistrTSPsolution_i >= minO2OSpot_id && DistrTSPsolution_i <= maxO2OSpot_id
        O2Oindex = DistrTSPsolution_i-minO2OSpot_id+1;
        O2Oaccumulate=O2Oaccumulate-O2OdemandVec(O2Oindex);
    %如果是O2Oshop，则需要检查积存能否允许继续添加包裹，若不行，则永远不行，不合法；若行，则积存增加
    elseif DistrTSPsolution_i >= minO2OShop_id && DistrTSPsolution_i <= maxO2OShop_id
        O2Oindex = DistrTSPsolution_i - minO2OShop_id + 1;
        if O2Oaccumulate + O2OdemandVec(O2Oindex) > volume
            isIllegal=1;
            return
        else
            O2Oaccumulate=O2Oaccumulate + O2OdemandVec(O2Oindex);
        end
    %如果是ecspot，则需要检查积存能否允许继续添加包裹，若不行，则永远不行，不合法；
    else 
        if O2Oaccumulate + ecDemandVec(DistrTSPsolution_i) > volume
            isIllegal=1;
            return
        end
    end
end

% if ismember(1,diff(zerosIndex)) || DistrTSPsolution(end)==0%若违反任意条件，则不合法，返回1
%     isIllegal=1;
% else
    %检查O2O
    [~,shopIndexInSolution]= ismember(O2OshopVec,DistrTSPsolution);      %方案中，shop的位置
    [~,spotIndexInSolution]= ismember(O2OspotVec,DistrTSPsolution);
    %如果不含O2O订单，则已合法
    if all(shopIndexInSolution==0)
        isIllegal=0;
        return
    elseif any(shopIndexInSolution-spotIndexInSolution>0)
        %如果任何shop在对应spot之后则不合法
        %shopIndexInSolution
        %spotIndexInSolution
        isIllegal=1;
        return
    else
        zeroSpot=find(DistrTSPsolution==0);
        O2OTaskNum=length(shopIndexInSolution);
        isIllegal=0;
        for j=1:length(zeroSpot)
            for i=1:O2OTaskNum
                if zeroSpot(j)>shopIndexInSolution(i) && zeroSpot(j)<spotIndexInSolution(i)
                    isIllegal=1;
                    return
                end     
            end  % i
        end % j
    end  %if 是否有O2O任务
end