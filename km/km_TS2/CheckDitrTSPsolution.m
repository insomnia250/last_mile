%   �������Ƿ�Ϸ��������㣺
%   1.��������Ϊ����δ�ͳ���O2O����������Զ�޷�������һ������������BUG
%   2.���һ��Ԫ�ز���Ϊ0
%   3.������0Ԫ�ز�������
%   4.ͬһ��O2O�����ȵ�shop���ٵ�spot
%   5.O2Oͬһ����shop��spot�������ͬһ���˵�������
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
%��ÿ���ڵ���м�飨DistrTSPsolution����0��ʾÿ����ʹ������
for i =2: length(DistrTSPsolution)
    DistrTSPsolution_i=DistrTSPsolution(i);
        
    %�����O2Ospot���򲻻����BUG�����Ҽ��ٻ���
    if DistrTSPsolution_i >= minO2OSpot_id && DistrTSPsolution_i <= maxO2OSpot_id
        O2Oindex = DistrTSPsolution_i-minO2OSpot_id+1;
        O2Oaccumulate=O2Oaccumulate-O2OdemandVec(O2Oindex);
    %�����O2Oshop������Ҫ�������ܷ����������Ӱ����������У�����Զ���У����Ϸ������У����������
    elseif DistrTSPsolution_i >= minO2OShop_id && DistrTSPsolution_i <= maxO2OShop_id
        O2Oindex = DistrTSPsolution_i - minO2OShop_id + 1;
        if O2Oaccumulate + O2OdemandVec(O2Oindex) > volume
            isIllegal=1;
            return
        else
            O2Oaccumulate=O2Oaccumulate + O2OdemandVec(O2Oindex);
        end
    %�����ecspot������Ҫ�������ܷ����������Ӱ����������У�����Զ���У����Ϸ���
    else 
        if O2Oaccumulate + ecDemandVec(DistrTSPsolution_i) > volume
            isIllegal=1;
            return
        end
    end
end

% if ismember(1,diff(zerosIndex)) || DistrTSPsolution(end)==0%��Υ�������������򲻺Ϸ�������1
%     isIllegal=1;
% else
    %���O2O
    [~,shopIndexInSolution]= ismember(O2OshopVec,DistrTSPsolution);      %�����У�shop��λ��
    [~,spotIndexInSolution]= ismember(O2OspotVec,DistrTSPsolution);
    %�������O2O���������ѺϷ�
    if all(shopIndexInSolution==0)
        isIllegal=0;
        return
    elseif any(shopIndexInSolution-spotIndexInSolution>0)
        %����κ�shop�ڶ�Ӧspot֮���򲻺Ϸ�
        %shopIndexInSolution
        %spotIndexInSolution
        isIllegal=1;
        return
    else
        isIllegal=0;
    end  %if �Ƿ���O2O����
end