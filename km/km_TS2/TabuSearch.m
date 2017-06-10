% PartECDemandVec , PartO2ODemandVec, PartStartTimeVec , PartEndTimeVec , PartECOrderNum , PartO2OOrderNum
% PartPackageTimeVec , PartDistanceMatrix

ECspotVec= 2 : PartECOrderNum+1;
PartO2O_ShopVec=1+ PartECOrderNum +(1:PartO2OOrderNum);  %����O2Oshop�Ľڵ��ţ�Ҳ�Ǿ����������
PartO2O_SpotVec=1+ PartECOrderNum + PartO2OOrderNum + (1:PartO2OOrderNum);


% tabu list
TabuLength = 12;
TabuList = ones(TabuLength, 3);

% Parameter TS

    MaxIterateTime =110 ;
    NeighbourSolutionNum = 20;

InitialDistrTSPsolution = [0 ECspotVec];
InitialDistrTSPsolutionWithO2O=[0 ECspotVec ,  PartO2O_ShopVec , PartO2O_SpotVec] ;

while(CheckDitrTSPsolution(InitialDistrTSPsolutionWithO2O,PartO2O_ShopVec,PartO2O_SpotVec,PartECDemandVec , PartO2ODemandVec , volume))   %���Ϸ�����1
    InitialDistrTSPsolutionWithO2O=RandomInsertO2OTask(InitialDistrTSPsolution,PartO2O_ShopVec,PartO2O_SpotVec);
end
%���ɳ�ʼmutiVRP��
VRPsolution = ConvertToVRPSolution (InitialDistrTSPsolutionWithO2O, PartDemandVec, volume,PartO2O_ShopVec,PartO2O_SpotVec,PartO2ODemandVec);

initialCost=CalculateTotalDistance (VRPsolution , PartDistanceMatrix ,PartPackageTimeVec , speed , PartStartTimeVec , PartEndTimeVec);
%��¼��ʼ����
%Tsekarang = Tawal;
BestTSPsolution = InitialDistrTSPsolutionWithO2O; %���Ŷ೵����TSP��
LeastCost = initialCost;  % ��С����
CurrentDistrTSPsolution = InitialDistrTSPsolutionWithO2O; %��ǰTSP�⣬���ڵ������޸�
CurrentCost = initialCost; %��ǰ����

NeighbourTSPsolutionTable = zeros(NeighbourSolutionNum, PartECOrderNum+2*PartO2OOrderNum+1);
NeighbourVRPsolutionCostTable = zeros(1, NeighbourSolutionNum);
OperateLocalSearchTable = zeros(NeighbourSolutionNum, 3);

BestNeighbourTSPsolution = zeros(1, PartECOrderNum+2*PartO2OOrderNum+1);


BestNeighbourTSPsolutionTabu = zeros(1, PartECOrderNum+2*PartO2OOrderNum+1);
BestNeighbourVRPcostTabu = 0;


% Mulai iterasi TS
iterateNum=MaxIterateTime*NeighbourSolutionNum;

if PartO2OOrderNum==0
    range=3;
elseif PartO2OOrderNum==1
    range=8;
else
    range=10;
end
a=0;
if PartECOrderNum==0
    range=5;
    a=1;
end

for i = 1 : MaxIterateTime
    %���������
    for j = 1 : NeighbourSolutionNum
        iterateNum=iterateNum-1;
       %------------------------------------------------------------------------------------
%         [PartECOrderNum , PartO2OOrderNum ,iterateNum , LeastCost, FinalPunishTime , FinalWaitTime]
        %-------------------------------------------------------------------------------------
        Pilihan = randi(range)+a;

        switch (Pilihan)
            case 1 % 1-insert
                [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformInsert(CurrentDistrTSPsolution ,PartECOrderNum);
                while(CheckDitrTSPsolution2(NeighbourTSPsolutionTable(j, :),PartO2O_ShopVec,PartO2O_SpotVec,PartECDemandVec , PartO2ODemandVec , volume))   %���Ϸ�����1
                    fault(1,1)=fault(1,1)+1;
                    [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] =PerformInsert(CurrentDistrTSPsolution ,PartECOrderNum);
                end
                NeighbourVRPsolution = ConvertToVRPSolution (NeighbourTSPsolutionTable(j, :), PartDemandVec, volume,PartO2O_ShopVec,PartO2O_SpotVec,PartO2ODemandVec);
                NeighbourVRPsolutionCostTable(j) =  CalculateTotalDistance (NeighbourVRPsolution , PartDistanceMatrix ,PartPackageTimeVec , speed , PartStartTimeVec , PartEndTimeVec);
%                 
            case 2 % 1-swap
                [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformSwap(CurrentDistrTSPsolution);
                while(CheckDitrTSPsolution(NeighbourTSPsolutionTable(j, :),PartO2O_ShopVec,PartO2O_SpotVec,PartECDemandVec , PartO2ODemandVec , volume))   %���Ϸ�����1
                     fault(1,2)=fault(1,2)+1;
                    [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformSwap(CurrentDistrTSPsolution);
                end
                NeighbourVRPsolution = ConvertToVRPSolution (NeighbourTSPsolutionTable(j, :), PartDemandVec, volume,PartO2O_ShopVec,PartO2O_SpotVec,PartO2ODemandVec);
                NeighbourVRPsolutionCostTable(j) =  CalculateTotalDistance (NeighbourVRPsolution , PartDistanceMatrix ,PartPackageTimeVec , speed , PartStartTimeVec , PartEndTimeVec);
                
            case 3 % 2-opt
                    [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ]=Perform2Opt_v2(CurrentDistrTSPsolution , PartO2O_ShopVec);

                while(CheckDitrTSPsolution2(NeighbourTSPsolutionTable(j, :),PartO2O_ShopVec,PartO2O_SpotVec,PartECDemandVec , PartO2ODemandVec , volume))   %���Ϸ�����1
                     fault(1,3)=fault(1,3)+1;
                       [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ]=Perform2Opt_v2(CurrentDistrTSPsolution , PartO2O_ShopVec );
                end
                NeighbourVRPsolution = ConvertToVRPSolution (NeighbourTSPsolutionTable(j, :), PartDemandVec, volume,PartO2O_ShopVec,PartO2O_SpotVec,PartO2ODemandVec);
                NeighbourVRPsolutionCostTable(j) =  CalculateTotalDistance (NeighbourVRPsolution , PartDistanceMatrix ,PartPackageTimeVec , speed , PartStartTimeVec , PartEndTimeVec);
            
            case 4% O2O insert
                [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformO2OInsert(CurrentDistrTSPsolution  , PartO2O_ShopVec , PartO2O_SpotVec);
                while(CheckDitrTSPsolution2(NeighbourTSPsolutionTable(j, :),PartO2O_ShopVec,PartO2O_SpotVec,PartECDemandVec , PartO2ODemandVec , volume))   %���Ϸ�����1
                    fault(1,4)=fault(1,4)+1;
                    [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformO2OInsert(CurrentDistrTSPsolution , PartO2O_ShopVec , PartO2O_SpotVec);
                end
               NeighbourVRPsolution = ConvertToVRPSolution (NeighbourTSPsolutionTable(j, :), PartDemandVec, volume,PartO2O_ShopVec,PartO2O_SpotVec,PartO2ODemandVec);
                NeighbourVRPsolutionCostTable(j) =  CalculateTotalDistance (NeighbourVRPsolution , PartDistanceMatrix ,PartPackageTimeVec , speed , PartStartTimeVec , PartEndTimeVec);
                
            case 5% O2O shop insert
                [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformO2OshopInsert(CurrentDistrTSPsolution , PartO2O_ShopVec , PartO2O_SpotVec);
                while(CheckDitrTSPsolution2(NeighbourTSPsolutionTable(j, :),PartO2O_ShopVec,PartO2O_SpotVec,PartECDemandVec , PartO2ODemandVec , volume))   %���Ϸ�����1
                     fault(1,5)=fault(1,5)+1;
                    [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformO2OshopInsert(CurrentDistrTSPsolution , PartO2O_ShopVec , PartO2O_SpotVec);
                end
                NeighbourVRPsolution = ConvertToVRPSolution (NeighbourTSPsolutionTable(j, :), PartDemandVec, volume,PartO2O_ShopVec,PartO2O_SpotVec,PartO2ODemandVec);
                NeighbourVRPsolutionCostTable(j) =  CalculateTotalDistance (NeighbourVRPsolution , PartDistanceMatrix ,PartPackageTimeVec , speed , PartStartTimeVec , PartEndTimeVec);
                
            case 6% O2O spot insert
                [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformO2OspotInsert(CurrentDistrTSPsolution , PartO2O_ShopVec , PartO2O_SpotVec);
                while(CheckDitrTSPsolution2(NeighbourTSPsolutionTable(j, :),PartO2O_ShopVec,PartO2O_SpotVec,PartECDemandVec , PartO2ODemandVec , volume))   %���Ϸ�����1
                     fault(1,6)=fault(1,6)+1;
                    [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformO2OspotInsert(CurrentDistrTSPsolution , PartO2O_ShopVec , PartO2O_SpotVec);
                end
                NeighbourVRPsolution = ConvertToVRPSolution (NeighbourTSPsolutionTable(j, :), PartDemandVec, volume,PartO2O_ShopVec,PartO2O_SpotVec,PartO2ODemandVec);
                NeighbourVRPsolutionCostTable(j) =  CalculateTotalDistance (NeighbourVRPsolution , PartDistanceMatrix ,PartPackageTimeVec , speed , PartStartTimeVec , PartEndTimeVec);
            
            case 7% O2O shop pursue
                [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformO2Oshoppursue(CurrentDistrTSPsolution , PartECOrderNum , PartO2O_ShopVec , PartO2O_SpotVec);
                while(CheckDitrTSPsolution2(NeighbourTSPsolutionTable(j, :),PartO2O_ShopVec,PartO2O_SpotVec,PartECDemandVec , PartO2ODemandVec , volume))   %���Ϸ�����1
                     fault(1,7)=fault(1,7)+1;
                    [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformO2Oshoppursue(CurrentDistrTSPsolution , PartECOrderNum , PartO2O_ShopVec , PartO2O_SpotVec);
                end
                NeighbourVRPsolution = ConvertToVRPSolution (NeighbourTSPsolutionTable(j, :), PartDemandVec, volume,PartO2O_ShopVec,PartO2O_SpotVec,PartO2ODemandVec);
                NeighbourVRPsolutionCostTable(j) =  CalculateTotalDistance (NeighbourVRPsolution , PartDistanceMatrix ,PartPackageTimeVec , speed , PartStartTimeVec , PartEndTimeVec);
            
            case 8% O2O spot pursue
                [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformO2Ospotpursue(CurrentDistrTSPsolution , PartECOrderNum , PartO2O_ShopVec , PartO2O_SpotVec);
                while(CheckDitrTSPsolution2(NeighbourTSPsolutionTable(j, :),PartO2O_ShopVec,PartO2O_SpotVec,PartECDemandVec , PartO2ODemandVec , volume))   %���Ϸ�����1
                     fault(1,8)=fault(1,8)+1;
                    [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformO2Ospotpursue(CurrentDistrTSPsolution , PartECOrderNum , PartO2O_ShopVec , PartO2O_SpotVec);
                end
               NeighbourVRPsolution = ConvertToVRPSolution (NeighbourTSPsolutionTable(j, :), PartDemandVec, volume,PartO2O_ShopVec,PartO2O_SpotVec,PartO2ODemandVec);
                NeighbourVRPsolutionCostTable(j) =  CalculateTotalDistance (NeighbourVRPsolution , PartDistanceMatrix ,PartPackageTimeVec , speed , PartStartTimeVec , PartEndTimeVec);
            
            case 9% O2O swap
                [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformO2OSwap(CurrentDistrTSPsolution , PartO2O_ShopVec , PartO2O_SpotVec);
                while(CheckDitrTSPsolution2(NeighbourTSPsolutionTable(j, :),PartO2O_ShopVec,PartO2O_SpotVec,PartECDemandVec , PartO2ODemandVec , volume))   %���Ϸ�����1
                     fault(1,9)=fault(1,9)+1;
                    [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformO2OSwap(CurrentDistrTSPsolution , PartO2O_ShopVec , PartO2O_SpotVec);
                end
                NeighbourVRPsolution = ConvertToVRPSolution (NeighbourTSPsolutionTable(j, :), PartDemandVec, volume,PartO2O_ShopVec,PartO2O_SpotVec,PartO2ODemandVec);
                NeighbourVRPsolutionCostTable(j) =  CalculateTotalDistance (NeighbourVRPsolution , PartDistanceMatrix ,PartPackageTimeVec , speed , PartStartTimeVec , PartEndTimeVec);
           
            case 10% O2O shop persue shop
                [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformO2Oshoppursue2(CurrentDistrTSPsolution  , PartO2O_ShopVec , PartO2O_SpotVec);
                while(CheckDitrTSPsolution2(NeighbourTSPsolutionTable(j, :),PartO2O_ShopVec,PartO2O_SpotVec,PartECDemandVec , PartO2ODemandVec , volume))   %���Ϸ�����1
                     fault(1,10)=fault(1,10)+1;
                    [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformO2Oshoppursue2(CurrentDistrTSPsolution  , PartO2O_ShopVec , PartO2O_SpotVec);
                end
                NeighbourVRPsolution = ConvertToVRPSolution (NeighbourTSPsolutionTable(j, :), PartDemandVec, volume,PartO2O_ShopVec,PartO2O_SpotVec,PartO2ODemandVec);
                NeighbourVRPsolutionCostTable(j) =  CalculateTotalDistance (NeighbourVRPsolution , PartDistanceMatrix ,PartPackageTimeVec , speed , PartStartTimeVec , PartEndTimeVec);                               
%             case 11 %O2OshopMergeForward
%                 [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformO2OshopMergeBackward( CurrentDistrTSPsolution , O2O_ShopVec , O2O_SpotVec , DistanceMatrix ,...
%                         PartDemandVec,volume,  VehicleNum,O2O_DemandVec , PartPackageTimeVec , speed ,StartTimeVec , EndTimeVec);
%                 
%                 while(CheckDitrTSPsolution2(NeighbourTSPsolutionTable(j, :),O2O_ShopVec,O2O_SpotVec,EC_DemandVec , O2O_DemandVec , volume))   %���Ϸ�����1
%                      fault(1,11)=fault(1,11)+1;
%                     [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformO2OshopMergeBackward( CurrentDistrTSPsolution , O2O_ShopVec , O2O_SpotVec , DistanceMatrix ,...
%                         PartDemandVec,volume,  VehicleNum,O2O_DemandVec , PartPackageTimeVec , speed ,StartTimeVec , EndTimeVec);
%                 end
%                 NeighbourVRPsolution = CalculateTotalDistance (NeighbourVRPsolution , DistanceMatrix ,PackageTimeVec , speed , StartTimeVec , EndTimeVec);
%                 NeighbourVRPsolutionCostTable(j) =  CalculateTotalDistance (NeighbourVRPsolution , DistanceMatrix ,PackageTimeVec , speed , StartTimeVec , EndTimeVec);                               
%             case 12 %O2OshopMergeBackward
%                 [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformO2OshopMergeForward( CurrentDistrTSPsolution , O2O_ShopVec , O2O_SpotVec , DistanceMatrix ,...
%                         PartDemandVec,volume,  VehicleNum,O2O_DemandVec , PartPackageTimeVec , speed ,StartTimeVec , EndTimeVec);
%                 
%                 while(CheckDitrTSPsolution2(NeighbourTSPsolutionTable(j, :),O2O_ShopVec,O2O_SpotVec,EC_DemandVec , O2O_DemandVec , volume))   %���Ϸ�����1
%                      fault(1,12)=fault(1,12)+1;
%                     [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformO2OshopMergeForward( CurrentDistrTSPsolution , O2O_ShopVec , O2O_SpotVec , DistanceMatrix ,...
%                         PartDemandVec,volume,  VehicleNum,O2O_DemandVec , PartPackageTimeVec , speed ,StartTimeVec , EndTimeVec);
%                 end
%                 NeighbourVRPsolution = CalculateTotalDistance (NeighbourVRPsolution , DistanceMatrix ,PackageTimeVec , speed , StartTimeVec , EndTimeVec);
%                 NeighbourVRPsolutionCostTable(j) =  CalculateTotalDistance (NeighbourVRPsolution , DistanceMatrix ,PackageTimeVec , speed , StartTimeVec , EndTimeVec);
        
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
%                 BestNeighbourVRPsolution = NeighbourVRPsolutionTable(:,:,j);
                BestNeighbourVRPcost = NeighbourVRPsolutionCostTable(j);
                BestNotTabuIndex = j;
            end
        else   %����ǽ��ɽ�
            if NeighbourVRPsolutionCostTable(j) < BestNeighbourVRPcostTabu
                BestNeighbourTSPsolutionTabu = NeighbourTSPsolutionTable(j, :);
%                 BestNeighbourVRPsolutionTabu = NeighbourVRPsolutionTable(:,:,j);
                BestNeighbourVRPcostTabu = NeighbourVRPsolutionCostTable(j);
                BestTabuIndex = j;
            end
        end
    end
    
    % ����Ƿ���ȫ�ֽ���, 
    if BestNeighbourVRPcostTabu < LeastCost  %������Ž��ɽ��������Ž�
        BestTSPsolution = BestNeighbourTSPsolutionTabu; %solusi global
        LeastCost = BestNeighbourVRPcostTabu; % Jarak solusi global
        CurrentDistrTSPsolution = BestNeighbourTSPsolutionTabu; %solusi iterasi
        CurrentCost = BestNeighbourVRPcostTabu; % Jarak solusi iterasi
        %���½��ɱ�
        IndeksTabuList = mod(i, TabuLength) + 1;   % i �ǵ�ǰ����������Ҫ���µĽ��ɱ�����
        TabuList(IndeksTabuList, :) = OperateLocalSearchTable(BestTabuIndex, :);
    else %������Ž�������ⲻ�������Ž�
        CurrentDistrTSPsolution = BestNeighbourTSPsolution; %solusi iterasi
        CurrentCost = BestNeighbourVRPcost; % Jarak solusi iterasi
        if BestNeighbourVRPcost < LeastCost
            BestTSPsolution = BestNeighbourTSPsolution; %solusi global
            LeastCost = BestNeighbourVRPcost; % Jarak solusi global
        end
        %update tabu list
        IndeksTabuList = mod(i, TabuLength) + 1;
        TabuList(IndeksTabuList, :) = OperateLocalSearchTable(BestNotTabuIndex, :);
    end

end
% BestTSPsolution
% LeastCost