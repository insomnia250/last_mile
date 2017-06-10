%   检查分配是否合法，需满足：
%   1.不存在因为积存未送出的O2O包裹导致永远无法再拿下一个订单包裹的BUG
%   2.最后一个元素不能为0
%   
%   4.同一单O2O必须先到shop，再到spot
%   5.O2O同一单的shop和spot必须分在同一个人的任务中
function isIllegal=CheckDitrTSPsolution2(DistrTSPsolution,O2OshopVec,O2OspotVec , ecDemandVec , O2OdemandVec , volume)
isIllegal=0;
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
