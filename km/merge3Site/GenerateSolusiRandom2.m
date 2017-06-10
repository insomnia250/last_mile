function solusirandom = GenerateSolusiRandom2 (Target_ecSite_id , part , kthcenter , partNum , VehicleNum)
filename1 = '..\data\s2\ecOrderData_format_kcenter.csv';
filename2 = '..\data\s2\o2oOrderData_format_kcenter.csv';

volume = 140;  %����
speed=15000/60;       %15km/h������m/min

FinalCostTotal=0;
FinalPunishTime=0;
FinalWaitTime=0;
siteFinalCost=0;

[ecOrder_id_total , ~,site_Lng_total , site_Lat_total , ~ , ~ , ~]=Read_ecOrderData(filename1,Target_ecSite_id,kthcenter);
[o2oOrder_id_total , ~ , ~ , ~ , ~ , ~ , ~ , ~ , ~]=Read_o2oOrderData(filename2 , Target_ecSite_id,kthcenter);
TotalecOrderNum = length(ecOrder_id_total);    %���̶�������
Totalo2oOrderNum=length(o2oOrder_id_total);    %O2O��������
site_Lng=site_Lng_total(1,1);
site_Lat=site_Lat_total(1,1);

    ecPartLength=round(TotalecOrderNum/partNum);
    o2oPartLength=round(Totalo2oOrderNum/partNum);
    
    ecStartLine = (part-1) * ecPartLength + 1;  
    ecEndLine=min(part * ecPartLength , TotalecOrderNum);
    o2oStartLine = (part-1) * o2oPartLength + 1;  
    o2oEndLine=min(part * o2oPartLength , Totalo2oOrderNum);

[ecOrder_id , ecSite_id , ecLng_site , ecLat_site , ecLng_spot , ecLat_spot , ecNum]=Read_ecOrderData(filename1,Target_ecSite_id ,kthcenter, ecStartLine , ecEndLine);
[o2oOrder_id , o2oShop_class , o2oLng_shop , o2oLat_shop , o2oLng_spot , o2oLat_spot , o2oNum , ...
    o2oStartTime , o2oEndTime]=Read_o2oOrderData(filename2 , Target_ecSite_id ,kthcenter ,o2oStartLine , o2oEndLine);

ecOrderNum = length(ecOrder_id);    %���̶�������
o2oOrderNum = 0;
% [����site���꣬���е��̶������͵�����] ����Ϊ1+ecOrderNum
ecLng_coordinate = [site_Lng   ecLng_spot'];          
ecLat_coordinate = [site_Lat   ecLat_spot'];
ecDemandVec = [0 ecNum'];
SiteVec=[1];            %��1��ʾSite�ڵ㣬2��ecOrderNum+1��ʾ������spot�ڵ�

%[����O2O����shop����] ���ȼ�Ϊo2oOrderNum
O2OshopLng_coordinate = o2oLng_shop';
O2OshopLat_coordinate = o2oLat_shop';
%[����O2O����spot����] ���ȼ�Ϊo2oOrderNum
O2OspotLng_coordinate = o2oLng_spot';
O2OspotLat_coordinate = o2oLat_spot';
O2OdemandVec = o2oNum';
O2OorderStartTime = o2oStartTime';
O2OorderEndTime= o2oEndTime';

Lng_coordinate = [ecLng_coordinate , O2OshopLng_coordinate , O2OspotLng_coordinate];     %����Ϊ1+ec������+2*o2o������
Lat_coordinate = [ecLat_coordinate , O2OshopLat_coordinate , O2OspotLat_coordinate];
DemandVec=[ecDemandVec zeros(1,o2oOrderNum) O2OdemandVec];

ECspotVec= 2 : ecOrderNum+1;
O2OshopVec=1+ ecOrderNum +(1:o2oOrderNum);  %����O2Oshop�Ľڵ��ţ�Ҳ�Ǿ����������
O2OspotVec=1+ ecOrderNum + o2oOrderNum + (1:o2oOrderNum);

ecStartTimeVec=zeros(1,1+ecOrderNum) ;    %��������ȴ�
ecEndTimeVec=[999999 720+zeros(1,ecOrderNum)] ;       %���̵���ʱ������Ϊ��8��
O2OStartTimeVec=[O2OorderStartTime , zeros(1,o2oOrderNum)] ;    % spot ��StartTimeΪ0��
O2OEndTimeVec=[O2OorderStartTime ,  O2OorderEndTime] ;      
StartTimeVec=[ecStartTimeVec , O2OStartTimeVec];
EndTimeVec=[ecEndTimeVec , O2OEndTimeVec];

%%
% tabu list
TabuLength = 10;
TabuList = ones(TabuLength, 3);


    MaxIterateTime = 1000;
    NeighbourSolutionNum = 100;

%���ɾ����
DistanceMatrix = GenerateEarthDistanceMatrix(Lng_coordinate, Lat_coordinate);  %�������,��λΪ��
PackageTimeVec=round(3*DemandVec.^0.5+5);      %����demand��ÿ���ص�İ�������ʱ��
PackageTimeVec(ismember(1:length(DemandVec),[SiteVec,O2OshopVec]))=0;       %������ȡ��ʱ��Site,Shop���޴���ʱ��


allVehicleTSPsolution = GenerateSolusiRandom(ecOrderNum);
if ecOrderNum==0
    allVehicleTSPsolution=[];
end
%Distribute task for vehicles

InitialDistrTSPsolution=TaskDistribute(allVehicleTSPsolution,VehicleNum);
%�������O2O����,ͬһ��������shop��spotλ��ͬһ��vehicle��
InitialDistrTSPsolutionWithO2O=RandomInsertO2OTask(InitialDistrTSPsolution,O2OshopVec,O2OspotVec);
% InitialDistrTSPsolutionWithO2O=BestRecordTSP;
while(CheckDitrTSPsolution(InitialDistrTSPsolutionWithO2O,O2OshopVec,O2OspotVec,ecDemandVec , O2OdemandVec , volume))   %���Ϸ�����1
    InitialDistrTSPsolutionWithO2O=RandomInsertO2OTask(InitialDistrTSPsolution,O2OshopVec,O2OspotVec);
end
%���ɳ�ʼmutiVRP��
InitialMutiVRPsolutionMaxtrix=ConvertToMultiVRPsolution(InitialDistrTSPsolutionWithO2O, ...
                                                        DemandVec,volume,VehicleNum,O2OshopVec,O2OspotVec,O2OdemandVec);

initialCost=CalculateMutiVRPtotalCost(InitialMutiVRPsolutionMaxtrix,DistanceMatrix,...
                                                                  VehicleNum , PackageTimeVec , speed , StartTimeVec , EndTimeVec);
%��¼��ʼ����
%Tsekarang = Tawal;
BestTSPsolution = InitialDistrTSPsolutionWithO2O; %���Ŷ೵����TSP��
BestVRPsolution = InitialMutiVRPsolutionMaxtrix; %����VRP��
LeastCost = initialCost;  % ��С����
CurrentDistrTSPsolution = InitialDistrTSPsolutionWithO2O; %��ǰTSP�⣬���ڵ������޸�
CurrentVRPsolution = InitialMutiVRPsolutionMaxtrix; %��ǰ�೵VRP��
CurrentCost = initialCost; %��ǰ����

NeighbourTSPsolutionTable = zeros(NeighbourSolutionNum, ecOrderNum+2*o2oOrderNum+VehicleNum);
NeighbourVRPsolutionTable = zeros(VehicleNum, (ecOrderNum+2*o2oOrderNum) * 2 + 1,NeighbourSolutionNum);
NeighbourVRPsolutionCostTable = zeros(1, NeighbourSolutionNum);
OperateLocalSearchTable = zeros(NeighbourSolutionNum, 3);

BestNeighbourTSPsolution = zeros(1, ecOrderNum+2*o2oOrderNum+VehicleNum);
BestNeighbourVRPsolution = zeros(VehicleNum, (ecOrderNum+2*o2oOrderNum) * 2 + 1);
BestNeighbourVRPcost = 0;

BestNeighbourTSPsolutionTabu = zeros(1, ecOrderNum+2*o2oOrderNum+VehicleNum);
BestNeighbourVRPsolutionTabu = zeros(VehicleNum, (ecOrderNum+2*o2oOrderNum) * 2 + 1);
BestNeighbourVRPcostTabu = 0;


% Mulai iterasi TS
iterateNum=MaxIterateTime*NeighbourSolutionNum;
range=3;


for i = 1 : MaxIterateTime
    %���������
    for j = 1 : NeighbourSolutionNum
        iterateNum=iterateNum-1;
       %------------------------------------------------------------------------------------
       [Target_ecSite_id ,ecOrderNum , o2oOrderNum , part/partNum, iterateNum , LeastCost , siteFinalCost , FinalCostTotal , FinalPunishTime , FinalWaitTime]
        %-------------------------------------------------------------------------------------
        Pilihan = randi(range);
        switch (Pilihan)
            case 1 % 1-insert
                [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformInsert(CurrentDistrTSPsolution);
                while(CheckDitrTSPsolution(NeighbourTSPsolutionTable(j, :),O2OshopVec,O2OspotVec,ecDemandVec , O2OdemandVec , volume))   %���Ϸ�����1
                    [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformInsert(CurrentDistrTSPsolution);
                end
                NeighbourVRPsolutionTable(:,:,j) = ConvertToMultiVRPsolution(NeighbourTSPsolutionTable(j, :),DemandVec,volume, ...
                                                                                        VehicleNum,O2OshopVec,O2OspotVec,O2OdemandVec);
                NeighbourVRPsolutionCostTable(j) =  CalculateMutiVRPtotalCost(NeighbourVRPsolutionTable(:,:,j),DistanceMatrix,...
                                                                   VehicleNum , PackageTimeVec , speed , StartTimeVec , EndTimeVec);
%                 
            case 2 % 1-swap
                [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformSwap(CurrentDistrTSPsolution);
                while(CheckDitrTSPsolution(NeighbourTSPsolutionTable(j, :),O2OshopVec,O2OspotVec,ecDemandVec , O2OdemandVec , volume))   %���Ϸ�����1
                    [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformSwap(CurrentDistrTSPsolution);
                end
                NeighbourVRPsolutionTable(:,:,j) = ConvertToMultiVRPsolution(NeighbourTSPsolutionTable(j, :),DemandVec,volume, ...
                                                                                         VehicleNum,O2OshopVec,O2OspotVec,O2OdemandVec);
                NeighbourVRPsolutionCostTable(j) =  CalculateMutiVRPtotalCost(NeighbourVRPsolutionTable(:,:,j),DistanceMatrix,...
                                                                  VehicleNum , PackageTimeVec , speed , StartTimeVec , EndTimeVec);
                
            case 3 % 2-opt
                [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = Perform2Opt(CurrentDistrTSPsolution);
                while(CheckDitrTSPsolution(NeighbourTSPsolutionTable(j, :),O2OshopVec,O2OspotVec,ecDemandVec , O2OdemandVec , volume))   %���Ϸ�����1
                    [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = Perform2Opt(CurrentDistrTSPsolution);
                end
                NeighbourVRPsolutionTable(:,:,j) = ConvertToMultiVRPsolution(NeighbourTSPsolutionTable(j, :),DemandVec,volume, ...
                                                                                         VehicleNum,O2OshopVec,O2OspotVec,O2OdemandVec);
                NeighbourVRPsolutionCostTable(j) =  CalculateMutiVRPtotalCost(NeighbourVRPsolutionTable(:,:,j),DistanceMatrix,...
                                                                 VehicleNum , PackageTimeVec , speed , StartTimeVec , EndTimeVec);
            
        end
        OperateLocalSearchTable(j, :) = [Pilihan  Kota_1 Kota_2];
    end
    
    %�ж���Щ������Ƿ��ǽ��ɱ��еĽ�
    isTabu = zeros(1, NeighbourSolutionNum);
    for j = 1 : NeighbourSolutionNum
        for k = 1 : TabuLength
            if OperateLocalSearchTable(j, :) == TabuList(k, :)
                isTabu(j) = 1;
            end
        end
    end
    MaxCost=999999999;
    %�����Ž���ǽ��ɵĽ�
    BestTabuIndex = 1;
    BestNotTabuIndex = 1;  
    BestNeighbourVRPcost = MaxCost;
    BestNeighbourVRPcostTabu = MaxCost;
    for j = 1 : NeighbourSolutionNum
        if  isTabu(j) == 0 % ������ǽ��ɽ�
            if NeighbourVRPsolutionCostTable(j) < BestNeighbourVRPcost
                BestNeighbourTSPsolution = NeighbourTSPsolutionTable(j, :);
                BestNeighbourVRPsolution = NeighbourVRPsolutionTable(:,:,j);
                BestNeighbourVRPcost = NeighbourVRPsolutionCostTable(j);
                BestNotTabuIndex = j;
            end
        else   %����ǽ��ɽ�
            if NeighbourVRPsolutionCostTable(j) < BestNeighbourVRPcostTabu
                BestNeighbourTSPsolutionTabu = NeighbourTSPsolutionTable(j, :);
                BestNeighbourVRPsolutionTabu = NeighbourVRPsolutionTable(:,:,j);
                BestNeighbourVRPcostTabu = NeighbourVRPsolutionCostTable(j);
                BestTabuIndex = j;
            end
        end
    end
    
    % ����Ƿ���ȫ�ֽ���, 
    if BestNeighbourVRPcostTabu < LeastCost  %������Ž��ɽ��������Ž�
        BestTSPsolution = BestNeighbourTSPsolutionTabu; %solusi global
        BestVRPsolution = BestNeighbourVRPsolutionTabu; %solusi global
        LeastCost = BestNeighbourVRPcostTabu; % Jarak solusi global
        CurrentDistrTSPsolution = BestNeighbourTSPsolutionTabu; %solusi iterasi
        CurrentVRPsolution = BestNeighbourVRPsolutionTabu; %solusi iterasi
        CurrentCost = BestNeighbourVRPcostTabu; % Jarak solusi iterasi
        %���½��ɱ�
        IndeksTabuList = mod(i, TabuLength) + 1;   % i �ǵ�ǰ����������Ҫ���µĽ��ɱ�����
        TabuList(IndeksTabuList, :) = OperateLocalSearchTable(BestTabuIndex, :);
    else %������Ž�������ⲻ�������Ž�
        CurrentDistrTSPsolution = BestNeighbourTSPsolution; %solusi iterasi
        CurrentVRPsolution = BestNeighbourVRPsolution; %solusi iterasi
        CurrentCost = BestNeighbourVRPcost; % Jarak solusi iterasi
        if BestNeighbourVRPcost < LeastCost
            BestTSPsolution = BestNeighbourTSPsolution; %solusi global
            BestVRPsolution = BestNeighbourVRPsolution; %solusi global
            LeastCost = BestNeighbourVRPcost; % Jarak solusi global
        end
        %update tabu list
        IndeksTabuList = mod(i, TabuLength) + 1;
        TabuList(IndeksTabuList, :) = OperateLocalSearchTable(BestNotTabuIndex, :);
    end

end
solusirandom= BestTSPsolution;
