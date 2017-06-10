


TotalDispatch=zeros(1,6);
%%
% tabu list
TabuLength = 18;
TabuList = ones(TabuLength, 3);

% Parameter TS
% if merged_decrease_record{MergedPair} == 1
    MaxIterateTime =2000 + o2oOrderNum*6 ;
    NeighbourSolutionNum = 100;
% else
%     MaxIterateTime =1 ;
%     NeighbourSolutionNum = 1;
% end

% 
%生成距离表
DistanceMatrix = GenerateEarthDistanceMatrix(Lng_coordinate, Lat_coordinate);  %距离矩阵,单位为米
PackageTimeVec=round(3*DemandVec.^0.5+5);      %根据demand得每个地点的包裹处理时间
PackageTimeVec(ismember(1:length(DemandVec),[SiteVec,O2OshopVec]))=0;       %修正，取货时（Site,Shop）无处理时间

% 
allVehicleTSPsolution = GenerateSolusiRandom(CityNum);
if ecOrderNum==0
    allVehicleTSPsolution=[];
end
%Distribute task for vehicles

InitialDistrTSPsolution=TaskDistribute(allVehicleTSPsolution,VehicleNum , CityNum);
% %随机插入O2O任务,同一个订单的shop和spot位于同一个vehicle中
InitialDistrTSPsolutionWithO2O=RandomInsertO2OTask(InitialDistrTSPsolution,O2OshopVec,O2OspotVec);
% InitialDistrTSPsolutionWithO2O = merged_TSP_record{MergedPair};

while(CheckDitrTSPsolution(InitialDistrTSPsolutionWithO2O,O2OshopVec,O2OspotVec,ecDemandVec , O2OdemandVec , volume))   %不合法返回1
    InitialDistrTSPsolutionWithO2O=RandomInsertO2OTask(InitialDistrTSPsolution,O2OshopVec,O2OspotVec);
end
% %生成初始mutiVRP解
InitialMutiVRPsolutionMaxtrix=ConvertToMultiVRPsolution(InitialDistrTSPsolutionWithO2O, ...
                                                        DemandVec,volume,VehicleNum,O2OshopVec,O2OspotVec,O2OdemandVec , DistanceMatrix , ecOrderNum , seperator1 , seperator2);
% 
initialCost=CalculateMutiVRPtotalCost(InitialMutiVRPsolutionMaxtrix,DistanceMatrix,...
                                                                  VehicleNum , PackageTimeVec , speed , StartTimeVec , EndTimeVec);
%记录初始条件
%Tsekarang = Tawal;
BestTSPsolution = InitialDistrTSPsolutionWithO2O; %最优多车分配TSP解
BestVRPsolution = InitialMutiVRPsolutionMaxtrix; %最优VRP解
LeastCost = initialCost;  % 最小代价
CurrentDistrTSPsolution = InitialDistrTSPsolutionWithO2O; %当前TSP解，用于迭代，修改
CurrentVRPsolution = InitialMutiVRPsolutionMaxtrix; %当前多车VRP解
CurrentCost = initialCost; %当前代价

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
if ecOrderNum==0
    range=6;
end

for i = 1 : MaxIterateTime
    %生成邻域解
    for j = 1 : NeighbourSolutionNum
        iterateNum=iterateNum-1;
        
       %------------------------------------------------------------------------------------
%         [ecOrderNum , o2oOrderNum ,  iterateNum , LeastCost , FinalCostSite , FinalCostTotal , FinalPunishTime , FinalWaitTime]
        [int2str(MergedPair) , '         ', int2str(saveCost),'        ', int2str(merged_cost_record{MergedPair}) , '      '...
        int2str(iterateNum) ,'         singleCost: ' , int2str(cost_record{recordNum1} + cost_record{recordNum2} + cost_record{recordNum3}) , ...  
        '        ' , int2str(recordNum1) , '     ec: ', int2str(ecOrderNum1) , '     o2o: ',int2str(o2oOrderNum1) , ...
        '        ' , int2str(recordNum2) , '     ec: ', int2str(ecOrderNum2) , '     o2o: ',int2str(o2oOrderNum2), ...
        '        ' , int2str(recordNum3) , '     ec: ', int2str(ecOrderNum3) , '     o2o: ',int2str(o2oOrderNum3), ...
        '       LeastCost: ' , int2str(LeastCost), ...
        '       CostTotal: ', int2str(FinalCostTotal) , '      PunishTime: ' , int2str(FinalPunishTime) , '       FinalWaitTime: ' , int2str(FinalWaitTime)]
        %-------------------------------------------------------------------------------------
        Pilihan = randi(range);
%         Pilihan=2;
        switch (Pilihan)
            case 1 % 1-insert
                [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformInsert(CurrentDistrTSPsolution  ,seperator1 , seperator2);
                while(CheckDitrTSPsolution(NeighbourTSPsolutionTable(j, :),O2OshopVec,O2OspotVec,ecDemandVec , O2OdemandVec , volume))   %不合法返回1
                    fault(1,1)=fault(1,1)+1;
                    [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] =PerformInsert(CurrentDistrTSPsolution ,ecOrderNum ,seperator1 , seperator2);
                end
                NeighbourVRPsolutionTable(:,:,j) = ConvertToMultiVRPsolution(NeighbourTSPsolutionTable(j, :),DemandVec,volume, ...
                                                                                        VehicleNum,O2OshopVec,O2OspotVec,O2OdemandVec , DistanceMatrix , ecOrderNum  ,seperator1 , seperator2);
                NeighbourVRPsolutionCostTable(j) =  CalculateMutiVRPtotalCost(NeighbourVRPsolutionTable(:,:,j),DistanceMatrix,...
                                                                   VehicleNum , PackageTimeVec , speed , StartTimeVec , EndTimeVec);
%                 
            case 2 % 1-swap
                [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformSwap(CurrentDistrTSPsolution , ecOrderNum , seperator1 , seperator2);
                while(CheckDitrTSPsolution(NeighbourTSPsolutionTable(j, :),O2OshopVec,O2OspotVec,ecDemandVec , O2OdemandVec , volume))   %不合法返回1
                     fault(1,2)=fault(1,2)+1;
                    [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformSwap(CurrentDistrTSPsolution , ecOrderNum  ,seperator1 , seperator2);
                end
                NeighbourVRPsolutionTable(:,:,j) = ConvertToMultiVRPsolution(NeighbourTSPsolutionTable(j, :),DemandVec,volume, ...
                                                                                         VehicleNum,O2OshopVec,O2OspotVec,O2OdemandVec , DistanceMatrix , ecOrderNum ,seperator1 , seperator2);
                NeighbourVRPsolutionCostTable(j) =  CalculateMutiVRPtotalCost(NeighbourVRPsolutionTable(:,:,j),DistanceMatrix,...
                                                                  VehicleNum , PackageTimeVec , speed , StartTimeVec , EndTimeVec);
                
            case 3 % 2-opt
                    [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ]=Perform2Opt_v2(CurrentDistrTSPsolution , O2OshopVec , VehicleNum);

                while(CheckDitrTSPsolution(NeighbourTSPsolutionTable(j, :),O2OshopVec,O2OspotVec,ecDemandVec , O2OdemandVec , volume))   %不合法返回1
                     fault(1,3)=fault(1,3)+1;

                       [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ]=Perform2Opt_v2(CurrentDistrTSPsolution , O2OshopVec , VehicleNum);
                end
                NeighbourVRPsolutionTable(:,:,j) = ConvertToMultiVRPsolution(NeighbourTSPsolutionTable(j, :),DemandVec,volume, ...
                                                                                         VehicleNum,O2OshopVec,O2OspotVec,O2OdemandVec , DistanceMatrix , ecOrderNum  ,seperator1 , seperator2);
                NeighbourVRPsolutionCostTable(j) =  CalculateMutiVRPtotalCost(NeighbourVRPsolutionTable(:,:,j),DistanceMatrix,...
                                                                 VehicleNum , PackageTimeVec , speed , StartTimeVec , EndTimeVec);
            
            case 4% O2O insert
                [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformO2OInsert(CurrentDistrTSPsolution , VehicleNum , O2OshopVec , O2OspotVec);
                while(CheckDitrTSPsolution(NeighbourTSPsolutionTable(j, :),O2OshopVec,O2OspotVec,ecDemandVec , O2OdemandVec , volume))   %不合法返回1
                    fault(1,4)=fault(1,4)+1;
                    [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformO2OInsert(CurrentDistrTSPsolution , VehicleNum , O2OshopVec , O2OspotVec);
                end
                NeighbourVRPsolutionTable(:,:,j) = ConvertToMultiVRPsolution(NeighbourTSPsolutionTable(j, :),DemandVec,volume, ...
                                                                                         VehicleNum,O2OshopVec,O2OspotVec,O2OdemandVec , DistanceMatrix , ecOrderNum  ,seperator1 , seperator2);
                NeighbourVRPsolutionCostTable(j) =  CalculateMutiVRPtotalCost(NeighbourVRPsolutionTable(:,:,j),DistanceMatrix,...
                                                                 VehicleNum , PackageTimeVec , speed , StartTimeVec , EndTimeVec);
            case 5% O2O shop insert
                [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformO2OshopInsert(CurrentDistrTSPsolution , O2OshopVec , O2OspotVec);
                while(CheckDitrTSPsolution(NeighbourTSPsolutionTable(j, :),O2OshopVec,O2OspotVec,ecDemandVec , O2OdemandVec , volume))   %不合法返回1
                     fault(1,5)=fault(1,5)+1;
                    [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformO2OshopInsert(CurrentDistrTSPsolution , O2OshopVec , O2OspotVec);
                end
                NeighbourVRPsolutionTable(:,:,j) = ConvertToMultiVRPsolution(NeighbourTSPsolutionTable(j, :),DemandVec,volume, ...
                                                                                         VehicleNum,O2OshopVec,O2OspotVec,O2OdemandVec , DistanceMatrix , ecOrderNum  ,seperator1 , seperator2);
                NeighbourVRPsolutionCostTable(j) =  CalculateMutiVRPtotalCost(NeighbourVRPsolutionTable(:,:,j),DistanceMatrix,...
                                                                 VehicleNum , PackageTimeVec , speed , StartTimeVec , EndTimeVec);  
            case 6% O2O spot insert
                [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformO2OspotInsert(CurrentDistrTSPsolution , O2OshopVec , O2OspotVec);
                while(CheckDitrTSPsolution(NeighbourTSPsolutionTable(j, :),O2OshopVec,O2OspotVec,ecDemandVec , O2OdemandVec , volume))   %不合法返回1
                     fault(1,6)=fault(1,6)+1;
                    [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformO2OspotInsert(CurrentDistrTSPsolution , O2OshopVec , O2OspotVec);
                end
                NeighbourVRPsolutionTable(:,:,j) = ConvertToMultiVRPsolution(NeighbourTSPsolutionTable(j, :),DemandVec,volume, ...
                                                                                         VehicleNum,O2OshopVec,O2OspotVec,O2OdemandVec , DistanceMatrix , ecOrderNum  ,seperator1 , seperator2);
                NeighbourVRPsolutionCostTable(j) =  CalculateMutiVRPtotalCost(NeighbourVRPsolutionTable(:,:,j),DistanceMatrix,...
                                                                 VehicleNum , PackageTimeVec , speed , StartTimeVec , EndTimeVec);
            case 7% O2O shop pursue
                [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformO2Oshoppursue(CurrentDistrTSPsolution , ecOrderNum , O2OshopVec , O2OspotVec);
                while(CheckDitrTSPsolution(NeighbourTSPsolutionTable(j, :),O2OshopVec,O2OspotVec,ecDemandVec , O2OdemandVec , volume))   %不合法返回1
                     fault(1,7)=fault(1,7)+1;
                    [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformO2Oshoppursue(CurrentDistrTSPsolution , ecOrderNum , O2OshopVec , O2OspotVec);
                end
                NeighbourVRPsolutionTable(:,:,j) = ConvertToMultiVRPsolution(NeighbourTSPsolutionTable(j, :),DemandVec,volume, ...
                                                                                         VehicleNum,O2OshopVec,O2OspotVec,O2OdemandVec , DistanceMatrix  ,ecOrderNum ,seperator1 , seperator2);
                NeighbourVRPsolutionCostTable(j) =  CalculateMutiVRPtotalCost(NeighbourVRPsolutionTable(:,:,j),DistanceMatrix,...
                                                                 VehicleNum , PackageTimeVec , speed , StartTimeVec , EndTimeVec); 
            case 8% O2O spot pursue
                [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformO2Ospotpursue(CurrentDistrTSPsolution , ecOrderNum , O2OshopVec , O2OspotVec);
                while(CheckDitrTSPsolution(NeighbourTSPsolutionTable(j, :),O2OshopVec,O2OspotVec,ecDemandVec , O2OdemandVec , volume))   %不合法返回1
                     fault(1,8)=fault(1,8)+1;
                    [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformO2Ospotpursue(CurrentDistrTSPsolution , ecOrderNum , O2OshopVec , O2OspotVec);
                end
                NeighbourVRPsolutionTable(:,:,j) = ConvertToMultiVRPsolution(NeighbourTSPsolutionTable(j, :),DemandVec,volume, ...
                                                                                         VehicleNum,O2OshopVec,O2OspotVec,O2OdemandVec , DistanceMatrix , ecOrderNum ,seperator1 , seperator2);
                NeighbourVRPsolutionCostTable(j) =  CalculateMutiVRPtotalCost(NeighbourVRPsolutionTable(:,:,j),DistanceMatrix,...
                                                                 VehicleNum , PackageTimeVec , speed , StartTimeVec , EndTimeVec);                                                 
            case 9% O2O swap
                [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformO2OSwap(CurrentDistrTSPsolution , O2OshopVec , O2OspotVec);
                while(CheckDitrTSPsolution(NeighbourTSPsolutionTable(j, :),O2OshopVec,O2OspotVec,ecDemandVec , O2OdemandVec , volume))   %不合法返回1
                     fault(1,9)=fault(1,9)+1;
                    [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformO2OSwap(CurrentDistrTSPsolution , O2OshopVec , O2OspotVec);
                end
                NeighbourVRPsolutionTable(:,:,j) = ConvertToMultiVRPsolution(NeighbourTSPsolutionTable(j, :),DemandVec,volume, ...
                                                                                         VehicleNum,O2OshopVec,O2OspotVec,O2OdemandVec , DistanceMatrix , ecOrderNum  ,seperator1 , seperator2);
                NeighbourVRPsolutionCostTable(j) =  CalculateMutiVRPtotalCost(NeighbourVRPsolutionTable(:,:,j),DistanceMatrix,...
                                                                 VehicleNum , PackageTimeVec , speed , StartTimeVec , EndTimeVec);
           case 10% O2O shop persue shop
                [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformO2Oshoppursue2(CurrentDistrTSPsolution  , O2OshopVec , O2OspotVec);
                while(CheckDitrTSPsolution(NeighbourTSPsolutionTable(j, :),O2OshopVec,O2OspotVec,ecDemandVec , O2OdemandVec , volume))   %不合法返回1
                     fault(1,10)=fault(1,10)+1;
                    [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformO2Oshoppursue2(CurrentDistrTSPsolution  , O2OshopVec , O2OspotVec);
                end
                NeighbourVRPsolutionTable(:,:,j) = ConvertToMultiVRPsolution(NeighbourTSPsolutionTable(j, :),DemandVec,volume, ...
                                                                                         VehicleNum,O2OshopVec,O2OspotVec,O2OdemandVec , DistanceMatrix , ecOrderNum ,seperator1 , seperator2);
                NeighbourVRPsolutionCostTable(j) =  CalculateMutiVRPtotalCost(NeighbourVRPsolutionTable(:,:,j),DistanceMatrix,...
                                                                 VehicleNum , PackageTimeVec , speed , StartTimeVec , EndTimeVec);                                                   
            case 11 %O2OshopMergeForward
                [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformO2OshopMergeBackward( CurrentDistrTSPsolution , O2OshopVec , O2OspotVec , DistanceMatrix ,...
                        DemandVec,volume,  VehicleNum,O2OdemandVec , PackageTimeVec , speed ,StartTimeVec , EndTimeVec ,ecOrderNum  ,seperator1 , seperator2);
                
                while(CheckDitrTSPsolution(NeighbourTSPsolutionTable(j, :),O2OshopVec,O2OspotVec,ecDemandVec , O2OdemandVec , volume))   %不合法返回1
                     fault(1,11)=fault(1,11)+1;
                    [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformO2OshopMergeBackward( CurrentDistrTSPsolution , O2OshopVec , O2OspotVec , DistanceMatrix ,...
                        DemandVec,volume,  VehicleNum,O2OdemandVec , PackageTimeVec , speed ,StartTimeVec , EndTimeVec,ecOrderNum  ,seperator1 , seperator2);
                end
                NeighbourVRPsolutionTable(:,:,j) = ConvertToMultiVRPsolution(NeighbourTSPsolutionTable(j, :),DemandVec,volume, ...
                                                                                         VehicleNum,O2OshopVec,O2OspotVec,O2OdemandVec , DistanceMatrix , ecOrderNum  ,seperator1 , seperator2);
                NeighbourVRPsolutionCostTable(j) =  CalculateMutiVRPtotalCost(NeighbourVRPsolutionTable(:,:,j),DistanceMatrix,...
                                                                 VehicleNum , PackageTimeVec , speed , StartTimeVec , EndTimeVec);                                                   
            case 12 %O2OshopMergeBackward
                [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformO2OshopMergeForward( CurrentDistrTSPsolution , O2OshopVec , O2OspotVec , DistanceMatrix ,...
                        DemandVec,volume,  VehicleNum,O2OdemandVec , PackageTimeVec , speed ,StartTimeVec , EndTimeVec ,ecOrderNum  ,seperator1 , seperator2);
                
                while(CheckDitrTSPsolution(NeighbourTSPsolutionTable(j, :),O2OshopVec,O2OspotVec,ecDemandVec , O2OdemandVec , volume))   %不合法返回1
                     fault(1,12)=fault(1,12)+1;
                    [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformO2OshopMergeForward( CurrentDistrTSPsolution , O2OshopVec , O2OspotVec , DistanceMatrix ,...
                        DemandVec,volume,  VehicleNum,O2OdemandVec , PackageTimeVec , speed ,StartTimeVec , EndTimeVec, ecOrderNum ,seperator1 , seperator2);
                end
                NeighbourVRPsolutionTable(:,:,j) = ConvertToMultiVRPsolution(NeighbourTSPsolutionTable(j, :),DemandVec,volume, ...
                                                                                         VehicleNum,O2OshopVec,O2OspotVec,O2OdemandVec , DistanceMatrix , ecOrderNum  ,seperator1 , seperator2);
                NeighbourVRPsolutionCostTable(j) =  CalculateMutiVRPtotalCost(NeighbourVRPsolutionTable(:,:,j),DistanceMatrix,...
                                                                 VehicleNum , PackageTimeVec , speed , StartTimeVec , EndTimeVec);            
        
        end
        OperateLocalSearchTable(j, :) = [Pilihan  Kota_1 Kota_2];
    end
    
    %判断这些邻域解是否是禁忌表中的解
    isTabu = zeros(1, NeighbourSolutionNum);
    for j = 1 : NeighbourSolutionNum
        for k = 1 : TabuLength
            if OperateLocalSearchTable(j, :) == TabuList(k, :)
                isTabu(j) = 1;
            end
        end
    end
    MaxCost=999999999;
    %找最优解或不是禁忌的解
    BestTabuIndex = 1;
    BestNotTabuIndex = 1;  
    BestNeighbourVRPcost = MaxCost;
    BestNeighbourVRPcostTabu = MaxCost;
    for j = 1 : NeighbourSolutionNum
        if  isTabu(j) == 0 % 如果不是禁忌解
            if NeighbourVRPsolutionCostTable(j) < BestNeighbourVRPcost
                BestNeighbourTSPsolution = NeighbourTSPsolutionTable(j, :);
                BestNeighbourVRPsolution = NeighbourVRPsolutionTable(:,:,j);
                BestNeighbourVRPcost = NeighbourVRPsolutionCostTable(j);
                BestNotTabuIndex = j;
            end
        else   %如果是禁忌解
            if NeighbourVRPsolutionCostTable(j) < BestNeighbourVRPcostTabu
                BestNeighbourTSPsolutionTabu = NeighbourTSPsolutionTable(j, :);
                BestNeighbourVRPsolutionTabu = NeighbourVRPsolutionTable(:,:,j);
                BestNeighbourVRPcostTabu = NeighbourVRPsolutionCostTable(j);
                BestTabuIndex = j;
            end
        end
    end
    
    % 检测是否是全局禁忌, 
    if BestNeighbourVRPcostTabu < LeastCost  %如果最优禁忌解优于最优解
        BestTSPsolution = BestNeighbourTSPsolutionTabu; %solusi global
        BestVRPsolution = BestNeighbourVRPsolutionTabu; %solusi global
        LeastCost = BestNeighbourVRPcostTabu; % Jarak solusi global
        CurrentDistrTSPsolution = BestNeighbourTSPsolutionTabu; %solusi iterasi
        CurrentVRPsolution = BestNeighbourVRPsolutionTabu; %solusi iterasi
        CurrentCost = BestNeighbourVRPcostTabu; % Jarak solusi iterasi
        %更新禁忌表
        IndeksTabuList = mod(i, TabuLength) + 1;   % i 是当前迭代次数，要更新的禁忌表索引
        TabuList(IndeksTabuList, :) = OperateLocalSearchTable(BestTabuIndex, :);
    else %如果最优禁忌邻域解不优于最优解
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
                    ones(1,ecOrderNum1)  ones(1,ecOrderNum2)+1  O2OshopVec;
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

% merged_decrease_record{MergedPair} = 0;
% if LeastCost < merged_cost_record{MergedPair}
% %     merged_decrease_record{MergedPair} = 1;
%     saveCost = saveCost + merged_cost_record{MergedPair} - LeastCost;
    
    merged_TSP_record{MergedPair}=BestTSPsolution;
    merged_cost_record{MergedPair}=LeastCost;
    merged_Site_id_record{MergedPair}=[recordNum1 , part1 , recordNum2 , part2 , recordNum3 , part3 ];
% end


FinalPunishTime=FinalPunishTime+totalPunish;
FinalWaitTime=FinalWaitTime+totalWait;

FinalCostTotal=FinalCostTotal + LeastCost;

% if LeastCost<(cost_record{recordNum1} + cost_record{recordNum2})
% %     filename_i=['F:\T\km\merge3Site\record\Site' ['recordnum' , int2str(recordNum1),'_',int2str(recordNum2)] '.csv'];
% %     csvwrite(filename_i,TotalDispatch)
% end
 

 
%  save  'Site_id_record.mat' 'Site_id_record'
%  save  'TSP_record.mat' 'TSP_record'
%  save 'cost_record.mat' 'cost_record'