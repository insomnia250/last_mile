for looptimes = 1:10
     clear all;
    tic;
    % filename1 = '..\data\ecOrderData_format.csv';
    % filename2 = '..\data\o2oOrderData_format.csv';
    Vsave=0;
    load TSP_record.mat;
    load Site_id_record.mat;
    load 'cost_record.mat';
    load 'increase_record.mat';

    filename1 = '..\data\s2\ecOrderData_format_kcenter.csv';
    filename2 = '..\data\s2\o2oOrderData_format_kcenter.csv';
    largeSiteRecord=[];
    recordNum=0;fault=zeros(1,12);
    volume = 140;  %����
    speed=15000/60;       %15km/h������m/min

    CourierID=0;        %��ʹ���
    FinalCostTotal=0;
    FinalPunishTime=0;
    FinalWaitTime=0;

    for Target_ecSite_id=1:124
    TotalDispatch=zeros(1,6);
    FinalCost=0;
    % if Target_ecSite_id==99
    %     kcenter=2;
    % else 
        kcenter=1;
    % end
    for kthcenter=1:kcenter
    [ecOrder_id_total , ~,site_Lng_total , site_Lat_total , ~ , ~ , ~]=Read_ecOrderData(filename1,Target_ecSite_id,kthcenter);
    [o2oOrder_id_total , ~ , ~ , ~ , ~ , ~ , ~ , ~ , ~]=Read_o2oOrderData(filename2 , Target_ecSite_id,kthcenter);
    TotalecOrderNum = length(ecOrder_id_total);    %���̶�������
    Totalo2oOrderNum=length(o2oOrder_id_total);    %O2O��������
    site_Lng=site_Lng_total(1,1);
    site_Lat=site_Lat_total(1,1);
    if Totalo2oOrderNum>150
        partNum=round(Totalo2oOrderNum/100);
    else
        partNum=1;
    end


    for part=1:partNum

        recordNum=recordNum+1;
        BestRecordTSP=TSP_record{recordNum};
        BestRecordCost=cost_record{recordNum};

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
    o2oOrderNum=length(o2oOrder_id);    %O2O��������
    totalOrderNum = ecOrderNum+o2oOrderNum;

    VehicleNum=numel(BestRecordTSP , BestRecordTSP==0) +1;

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
    TabuLength = 18;
    TabuList = ones(TabuLength, 3);

    % Parameter TS
    % if increase_record{recordNum} == 1
        MaxIterateTime =700 + round(5 * o2oOrderNum);
        NeighbourSolutionNum = 100;
    % else
    %     MaxIterateTime = 1;
    %     NeighbourSolutionNum = 1;
    % end
    %���ɾ����
    DistanceMatrix = GenerateEarthDistanceMatrix(Lng_coordinate, Lat_coordinate);  %�������,��λΪ��
    PackageTimeVec=round(3*DemandVec.^0.5+5);      %����demand��ÿ���ص�İ�������ʱ��
    PackageTimeVec(ismember(1:length(DemandVec),[SiteVec,O2OshopVec]))=0;       %������ȡ��ʱ��Site,Shop���޴���ʱ��

    %Generate initial solution
    %SolusiAwal = GenerateSolusiNearestNeighbour(MatriksJarak);

    allVehicleTSPsolution = GenerateSolusiRandom(ecOrderNum);
    if ecOrderNum==0
        allVehicleTSPsolution=[];
    end
    %Distribute task for vehicles

    InitialDistrTSPsolution=TaskDistribute(allVehicleTSPsolution,VehicleNum);
    %�������O2O����,ͬһ��������shop��spotλ��ͬһ��vehicle��
     InitialDistrTSPsolutionWithO2O=RandomInsertO2OTask(InitialDistrTSPsolution,O2OshopVec,O2OspotVec);

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
    if o2oOrderNum==0
        range=3;
    elseif o2oOrderNum==1
        range=8;
    elseif o2oOrderNum==2
        range=10;
    else
        range = 12;
    end

    for i = 1 : MaxIterateTime
        %���������
        for j = 1 : NeighbourSolutionNum
            iterateNum=iterateNum-1;
           %------------------------------------------------------------------------------------
            [BestRecordCost Target_ecSite_id ,ecOrderNum , o2oOrderNum , part/partNum, iterateNum , LeastCost , FinalCost , FinalCostTotal , FinalPunishTime , FinalWaitTime]
            %-------------------------------------------------------------------------------------
            Pilihan = randi(range);
            switch (Pilihan)
                case 1 % 1-insert
                     [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformInsert(CurrentDistrTSPsolution ,ecOrderNum ,VehicleNum);
                    while(CheckDitrTSPsolution2(NeighbourTSPsolutionTable(j, :),O2OshopVec,O2OspotVec,ecDemandVec , O2OdemandVec , volume))   %���Ϸ�����1
    %                     fault(1,1)=fault(1,1)+1;
                        [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformInsert(CurrentDistrTSPsolution ,ecOrderNum ,VehicleNum);
                    end
                    NeighbourVRPsolutionTable(:,:,j) = ConvertToMultiVRPsolution(NeighbourTSPsolutionTable(j, :),DemandVec,volume, ...
                                                                                            VehicleNum,O2OshopVec,O2OspotVec,O2OdemandVec);
                    NeighbourVRPsolutionCostTable(j) =  CalculateMutiVRPtotalCost(NeighbourVRPsolutionTable(:,:,j),DistanceMatrix,...
                                                                       VehicleNum , PackageTimeVec , speed , StartTimeVec , EndTimeVec);
    %                 
                case 2 % 1-swap
                    [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformSwap(CurrentDistrTSPsolution);
                    while(CheckDitrTSPsolution(NeighbourTSPsolutionTable(j, :),O2OshopVec,O2OspotVec,ecDemandVec , O2OdemandVec , volume))   %���Ϸ�����1
    %                     fault(1,2)=fault(1,2)+1;
                        [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformSwap(CurrentDistrTSPsolution);
                    end
                    NeighbourVRPsolutionTable(:,:,j) = ConvertToMultiVRPsolution(NeighbourTSPsolutionTable(j, :),DemandVec,volume, ...
                                                                                             VehicleNum,O2OshopVec,O2OspotVec,O2OdemandVec);
                    NeighbourVRPsolutionCostTable(j) =  CalculateMutiVRPtotalCost(NeighbourVRPsolutionTable(:,:,j),DistanceMatrix,...
                                                                      VehicleNum , PackageTimeVec , speed , StartTimeVec , EndTimeVec);

                case 3 % 2-opt
                    [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = Perform2Opt_v2(CurrentDistrTSPsolution , O2OshopVec , VehicleNum);
                    while(CheckDitrTSPsolution2(NeighbourTSPsolutionTable(j, :),O2OshopVec,O2OspotVec,ecDemandVec , O2OdemandVec , volume))   %���Ϸ�����1
    %                     fault(1,3)=fault(1,3)+1;
                        [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = Perform2Opt_v2(CurrentDistrTSPsolution , O2OshopVec , VehicleNum);
                    end
                    NeighbourVRPsolutionTable(:,:,j) = ConvertToMultiVRPsolution(NeighbourTSPsolutionTable(j, :),DemandVec,volume, ...
                                                                                             VehicleNum,O2OshopVec,O2OspotVec,O2OdemandVec);
                    NeighbourVRPsolutionCostTable(j) =  CalculateMutiVRPtotalCost(NeighbourVRPsolutionTable(:,:,j),DistanceMatrix,...
                                                                     VehicleNum , PackageTimeVec , speed , StartTimeVec , EndTimeVec);

                case 4% O2O insert
                    [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformO2OInsert(CurrentDistrTSPsolution , VehicleNum , O2OshopVec , O2OspotVec);
                    while(CheckDitrTSPsolution2(NeighbourTSPsolutionTable(j, :),O2OshopVec,O2OspotVec,ecDemandVec , O2OdemandVec , volume))   %���Ϸ�����1
    %                     fault(1,4)=fault(1,4)+1;
                        [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformO2OInsert(CurrentDistrTSPsolution , VehicleNum , O2OshopVec , O2OspotVec);
                    end
                    NeighbourVRPsolutionTable(:,:,j) = ConvertToMultiVRPsolution(NeighbourTSPsolutionTable(j, :),DemandVec,volume, ...
                                                                                             VehicleNum,O2OshopVec,O2OspotVec,O2OdemandVec);
                    NeighbourVRPsolutionCostTable(j) =  CalculateMutiVRPtotalCost(NeighbourVRPsolutionTable(:,:,j),DistanceMatrix,...
                                                                     VehicleNum , PackageTimeVec , speed , StartTimeVec , EndTimeVec);
                case 5% O2O shop insert
                    [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformO2OshopInsert(CurrentDistrTSPsolution , O2OshopVec , O2OspotVec);
                    while(CheckDitrTSPsolution2(NeighbourTSPsolutionTable(j, :),O2OshopVec,O2OspotVec,ecDemandVec , O2OdemandVec , volume))   %���Ϸ�����1
    %                     fault(1,5)=fault(1,5)+1;
                        [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformO2OshopInsert(CurrentDistrTSPsolution , O2OshopVec , O2OspotVec);
                    end
                    NeighbourVRPsolutionTable(:,:,j) = ConvertToMultiVRPsolution(NeighbourTSPsolutionTable(j, :),DemandVec,volume, ...
                                                                                             VehicleNum,O2OshopVec,O2OspotVec,O2OdemandVec);
                    NeighbourVRPsolutionCostTable(j) =  CalculateMutiVRPtotalCost(NeighbourVRPsolutionTable(:,:,j),DistanceMatrix,...
                                                                     VehicleNum , PackageTimeVec , speed , StartTimeVec , EndTimeVec);  
                case 6% O2O spot insert
                    [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformO2OspotInsert(CurrentDistrTSPsolution , O2OshopVec , O2OspotVec);
                    while(CheckDitrTSPsolution2(NeighbourTSPsolutionTable(j, :),O2OshopVec,O2OspotVec,ecDemandVec , O2OdemandVec , volume))   %���Ϸ�����1
    %                     fault(1,6)=fault(1,6)+1;
                        [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformO2OspotInsert(CurrentDistrTSPsolution , O2OshopVec , O2OspotVec);
                    end
                    NeighbourVRPsolutionTable(:,:,j) = ConvertToMultiVRPsolution(NeighbourTSPsolutionTable(j, :),DemandVec,volume, ...
                                                                                             VehicleNum,O2OshopVec,O2OspotVec,O2OdemandVec);
                    NeighbourVRPsolutionCostTable(j) =  CalculateMutiVRPtotalCost(NeighbourVRPsolutionTable(:,:,j),DistanceMatrix,...
                                                                     VehicleNum , PackageTimeVec , speed , StartTimeVec , EndTimeVec);                                                 
                case 7% O2O shop pursue
                    [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformO2Oshoppursue(CurrentDistrTSPsolution , ecOrderNum , O2OshopVec , O2OspotVec);
                    while(CheckDitrTSPsolution2(NeighbourTSPsolutionTable(j, :),O2OshopVec,O2OspotVec,ecDemandVec , O2OdemandVec , volume))   %���Ϸ�����1
    %                     fault(1,7)=fault(1,7)+1;
                        [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformO2Oshoppursue(CurrentDistrTSPsolution , ecOrderNum , O2OshopVec , O2OspotVec);
                    end
                    NeighbourVRPsolutionTable(:,:,j) = ConvertToMultiVRPsolution(NeighbourTSPsolutionTable(j, :),DemandVec,volume, ...
                                                                                             VehicleNum,O2OshopVec,O2OspotVec,O2OdemandVec);
                    NeighbourVRPsolutionCostTable(j) =  CalculateMutiVRPtotalCost(NeighbourVRPsolutionTable(:,:,j),DistanceMatrix,...
                                                                     VehicleNum , PackageTimeVec , speed , StartTimeVec , EndTimeVec); 
                case 8% O2O spot pursue
                    [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformO2Ospotpursue(CurrentDistrTSPsolution , ecOrderNum , O2OshopVec , O2OspotVec);
                    while(CheckDitrTSPsolution2(NeighbourTSPsolutionTable(j, :),O2OshopVec,O2OspotVec,ecDemandVec , O2OdemandVec , volume))   %���Ϸ�����1
    %                     fault(1,8)=fault(1,8)+1;
                        [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformO2Ospotpursue(CurrentDistrTSPsolution , ecOrderNum , O2OshopVec , O2OspotVec);
                    end
                    NeighbourVRPsolutionTable(:,:,j) = ConvertToMultiVRPsolution(NeighbourTSPsolutionTable(j, :),DemandVec,volume, ...
                                                                                             VehicleNum,O2OshopVec,O2OspotVec,O2OdemandVec);
                    NeighbourVRPsolutionCostTable(j) =  CalculateMutiVRPtotalCost(NeighbourVRPsolutionTable(:,:,j),DistanceMatrix,...
                                                                     VehicleNum , PackageTimeVec , speed , StartTimeVec , EndTimeVec);                                                 
                case 9% O2O swap
                    [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformO2OSwap(CurrentDistrTSPsolution , O2OshopVec , O2OspotVec);
                    while(CheckDitrTSPsolution2(NeighbourTSPsolutionTable(j, :),O2OshopVec,O2OspotVec,ecDemandVec , O2OdemandVec , volume))   %���Ϸ�����1
    %                     fault(1,9)=fault(1,9)+1;
                        [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformO2OSwap(CurrentDistrTSPsolution , O2OshopVec , O2OspotVec);
                    end
                    NeighbourVRPsolutionTable(:,:,j) = ConvertToMultiVRPsolution(NeighbourTSPsolutionTable(j, :),DemandVec,volume, ...
                                                                                             VehicleNum,O2OshopVec,O2OspotVec,O2OdemandVec);
                    NeighbourVRPsolutionCostTable(j) =  CalculateMutiVRPtotalCost(NeighbourVRPsolutionTable(:,:,j),DistanceMatrix,...
                                                                     VehicleNum , PackageTimeVec , speed , StartTimeVec , EndTimeVec);
               case 10% O2O shop persue shop
                    [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformO2Oshoppursue2(CurrentDistrTSPsolution  , O2OshopVec , O2OspotVec);
                    while(CheckDitrTSPsolution2(NeighbourTSPsolutionTable(j, :),O2OshopVec,O2OspotVec,ecDemandVec , O2OdemandVec , volume))   %���Ϸ�����1
    %                     fault(1,10)=fault(1,10)+1;
                        [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformO2Oshoppursue2(CurrentDistrTSPsolution  , O2OshopVec , O2OspotVec);
                    end
                    NeighbourVRPsolutionTable(:,:,j) = ConvertToMultiVRPsolution(NeighbourTSPsolutionTable(j, :),DemandVec,volume, ...
                                                                                             VehicleNum,O2OshopVec,O2OspotVec,O2OdemandVec);
                    NeighbourVRPsolutionCostTable(j) =  CalculateMutiVRPtotalCost(NeighbourVRPsolutionTable(:,:,j),DistanceMatrix,...
                                                                     VehicleNum , PackageTimeVec , speed , StartTimeVec , EndTimeVec);                                                   
                case 11 %O2OshopMergeForward
                    [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformO2OshopMergeBackward( CurrentDistrTSPsolution , O2OshopVec , O2OspotVec , DistanceMatrix ,...
                            DemandVec,volume,  VehicleNum,O2OdemandVec , PackageTimeVec , speed ,StartTimeVec , EndTimeVec);

                    while(CheckDitrTSPsolution2(NeighbourTSPsolutionTable(j, :),O2OshopVec,O2OspotVec,ecDemandVec , O2OdemandVec , volume))   %���Ϸ�����1
    %                     fault(1,11)=fault(1,11)+1;
                        [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformO2OshopMergeBackward( CurrentDistrTSPsolution , O2OshopVec , O2OspotVec , DistanceMatrix ,...
                            DemandVec,volume,  VehicleNum,O2OdemandVec , PackageTimeVec , speed ,StartTimeVec , EndTimeVec);
                    end
                    NeighbourVRPsolutionTable(:,:,j) = ConvertToMultiVRPsolution(NeighbourTSPsolutionTable(j, :),DemandVec,volume, ...
                                                                                             VehicleNum,O2OshopVec,O2OspotVec,O2OdemandVec);
                    NeighbourVRPsolutionCostTable(j) =  CalculateMutiVRPtotalCost(NeighbourVRPsolutionTable(:,:,j),DistanceMatrix,...
                                                                     VehicleNum , PackageTimeVec , speed , StartTimeVec , EndTimeVec);                                                   
                case 12 %O2OshopMergeBackward
                    [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformO2OshopMergeForward( CurrentDistrTSPsolution , O2OshopVec , O2OspotVec , DistanceMatrix ,...
                            DemandVec,volume,  VehicleNum,O2OdemandVec , PackageTimeVec , speed ,StartTimeVec , EndTimeVec);

                    while(CheckDitrTSPsolution2(NeighbourTSPsolutionTable(j, :),O2OshopVec,O2OspotVec,ecDemandVec , O2OdemandVec , volume))   %���Ϸ�����1
    %                     fault(1,12)=fault(1,12)+1;
                        [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformO2OshopMergeForward( CurrentDistrTSPsolution , O2OshopVec , O2OspotVec , DistanceMatrix ,...
                            DemandVec,volume,  VehicleNum,O2OdemandVec , PackageTimeVec , speed ,StartTimeVec , EndTimeVec);
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



    OrderInfo=[ ECspotVec  O2OspotVec ;...
                        ones(1,ecOrderNum)  O2OshopVec;
                        ecOrder_id'  (o2oOrder_id+9214)' ...
                        ];

    [~ , ArriveTimeMatrix , DepartTimeMatrix , totalPunish , totalWait] = CalculateMutiVRPtotalCost(BestVRPsolution,DistanceMatrix,...
                                                                     VehicleNum , PackageTimeVec , speed , StartTimeVec , EndTimeVec); 
    for i =1:VehicleNum
        CourierID=CourierID+1;
        DispatchMatrix=ExpressDispatch( BestVRPsolution(i,:) , OrderInfo , ArriveTimeMatrix(i,:) , DepartTimeMatrix(i,:) , DemandVec , ...
                                                                                                                                                                CourierID , ECspotVec , O2OshopVec) ;
         TotalDispatch=[TotalDispatch;DispatchMatrix];

    end

    toc
    increase_record{recordNum} = 0;
    if LeastCost<BestRecordCost - 80
        Vsave=Vsave+1;
        TSP_record{recordNum}=BestTSPsolution;
        cost_record{recordNum}=LeastCost;
        increase_record{recordNum} = 1;
    end
    Site_id_record{recordNum}=[Target_ecSite_id kthcenter part];

    FinalCost=FinalCost+LeastCost;              %�ýڵ�ĸò����ܴ���
    FinalPunishTime=FinalPunishTime+totalPunish;
    FinalWaitTime=FinalWaitTime+totalWait;
    
    
     save  'Site_id_record.mat' 'Site_id_record'
     save  'TSP_record.mat' 'TSP_record'
     save 'cost_record.mat' 'cost_record'
      save 'increase_record.mat' 'increase_record'
    end
    end
    FinalCostTotal=FinalCostTotal + FinalCost;
    if FinalCost>7000
        largeSiteRecord=[largeSiteRecord,Target_ecSite_id];
    end
    % filename_i=['F:\T\km\record\Site' int2str(Target_ecSite_id) '.csv'];
    % csvwrite(filename_i,TotalDispatch)
    end
    disp ('Least Cost');
    disp (FinalCostTotal);
     save  'Site_id_record.mat' 'Site_id_record'
     save  'TSP_record.mat' 'TSP_record'
     save 'cost_record.mat' 'cost_record'
      save 'increase_record.mat' 'increase_record'
     Vsave
end