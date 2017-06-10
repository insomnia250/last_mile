function VRPsolution = ConvertToVRPSolution (TSPsolution, DemandVec, volume,O2OshopVec,O2OspotVec,O2OdemandVec)
SpotNum = numel(TSPsolution) - 1;  %�ڵ��� ԭTSP[0 3 2 ...]����������spot��O2Oshop��O2Ospot

VRPsolution = ones (1, SpotNum * 2 + 1);
CurrentLoad = 0; % �����Ѿ���·������ĸ���
routeIndex = 1;  %·���ڵ���
CurrentO2OLoad=0;  %Я�������O2O��������
LoadAfterLastO2O=0; %���O2Oshop֮��ĵ��̰�������
FirstO2OshopFlag=0;
maxBefore=0;
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

for i =2 : SpotNum + 1
    TSPsolution_i=TSPsolution(i);
    %----�����O2Oshop
%     if ismember(TSPsolution(i),O2OshopVec)
    if TSPsolution_i>=minO2OShop_id && TSPsolution_i<=maxO2OShop_id
%         O2Oindex=find(O2OshopVec==TSPsolution(i));   %O2O�������̵꣩�������ڼ�������
        O2Oindex=TSPsolution_i-minO2OShop_id+1;
        
        %����Ҫ������·��
        if CurrentO2OLoad+O2OdemandVec(O2Oindex) <= volume
            %O2Oshop��ecDemandΪ0�����Կɲ����µ�ǰ�ػ���
            routeIndex = routeIndex + 1;        %��ǰ·�ߵ���
            VRPsolution (routeIndex) = TSPsolution_i;
        else
            maxBefore=0;
            routeIndex = routeIndex + 1;
            VRPsolution (routeIndex) = 1;   %����ԭ��
            CurrentLoad = 0;
            routeIndex = routeIndex + 1;
            VRPsolution (routeIndex) = TSPsolution_i;
        end
        CurrentO2OLoad=CurrentO2OLoad+O2OdemandVec(O2Oindex);  %����O2O���渺��
        LoadAfterLastO2O=0;
        FirstO2OshopFlag=1;
        maxBefore=max(maxBefore,CurrentO2OLoad);
    %---�����O2Ospot������ecDemand����ֱ�����
    elseif  TSPsolution_i>=minO2OSpot_id && TSPsolution_i<=maxO2OSpot_id     %����ismember()
        routeIndex = routeIndex + 1;        %��ǰ·�ߵ���
        VRPsolution (routeIndex) = TSPsolution_i;
        O2Oindex= TSPsolution_i-minO2OSpot_id+1;
        CurrentO2OLoad=CurrentO2OLoad-O2OdemandVec(O2Oindex);  %����O2O���渺��
    %----�������ͨ����spot
    else               
        %���贴��һ����·�ߵ����
        if CurrentLoad + DemandVec(TSPsolution_i) <= volume  && ...
                CurrentO2OLoad+LoadAfterLastO2O+DemandVec(TSPsolution_i)<=volume && ...
                maxBefore + DemandVec(TSPsolution_i)<=volume
            CurrentLoad = CurrentLoad + DemandVec(TSPsolution_i);   %���µ�ǰ�ػ���
            LoadAfterLastO2O=LoadAfterLastO2O+DemandVec(TSPsolution_i);   %�������һ��O2O֮����̰�������
            routeIndex = routeIndex + 1;        %��ǰ·�ߵ���
            VRPsolution (routeIndex) = TSPsolution_i;
        else % perlu buat rute baru  ��Ҫ������·��
            % sisipkan depot kota 1     �����вֿ�1����������
            %demandsekarang = 0; 
            maxBefore=CurrentO2OLoad;
            routeIndex = routeIndex + 1;
            VRPsolution (routeIndex) = 1;   %���η���
            % sisipkan kota berikutnya di rutebaru
            CurrentLoad = DemandVec(TSPsolution_i);  %���µ��̰�������
            LoadAfterLastO2O=DemandVec(TSPsolution_i);  %�������һ��O2O֮����̰�������
            routeIndex = routeIndex + 1;
            VRPsolution (routeIndex) = TSPsolution_i;
        end
        maxBefore= FirstO2OshopFlag * (maxBefore + DemandVec(TSPsolution_i));
    end   
end
