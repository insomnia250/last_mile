clear all;
tic;
filename1 = '..\data\ecOrderData_format.csv';
filename2 = '..\data\o2oOrderData_format.csv';


volume = 140;  %����
speed=15000/60;       %15km/h������m/min
sumV=0;
FinalCost=0;
for Target_ecSite_id=116:124
% Target_ecSite_id=2;     %���Ż�������
[ecOrder_id , ecSite_id , ecLng_site , ecLat_site , ecLng_spot , ecLat_spot , ecNum]=Read_ecOrderData(filename1,Target_ecSite_id);
[o2oOrder_id , o2oShop_class , o2oLng_shop , o2oLat_shop , o2oLng_spot , o2oLat_spot , o2oNum , ...
    o2oStartTime , o2oEndTime]=Read_o2oOrderData(filename2 , Target_ecSite_id);

ecOrderNum = length(ecOrder_id);    %���̶�������
o2oOrderNum=length(o2oOrder_id);    %O2O��������
totalOrderNum = ecOrderNum+o2oOrderNum;
VehicleNum=round((ecOrderNum+2*o2oOrderNum)/15.82+70);


% [����site���꣬���е��̶������͵�����] ����Ϊ1+ecOrderNum
ecLng_coordinate = [ecLng_site(1,1)   ecLng_spot'];          
ecLat_coordinate = [ecLat_site(1,1)   ecLat_spot'];
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

O2OshopVec=1+ ecOrderNum +(1:o2oOrderNum);  %����O2Oshop�Ľڵ��ţ�Ҳ�Ǿ����������
O2OspotVec=1+ ecOrderNum + o2oOrderNum + (1:o2oOrderNum);

ecStartTimeVec=zeros(1,1+ecOrderNum) ;    %��������ȴ�
ecEndTimeVec=999999+zeros(1,1+ecOrderNum) ;       %���������ͷ�
O2OStartTimeVec=[O2OorderStartTime , zeros(1,o2oOrderNum)] ;    % spot ��StartTimeΪ0��
O2OEndTimeVec=[999999+zeros(1,o2oOrderNum) , O2OorderEndTime] ;      %shop ��EndTimeΪ���� �� 
StartTimeVec=[ecStartTimeVec , O2OStartTimeVec];
EndTimeVec=[ecEndTimeVec , O2OEndTimeVec];

%%
% tabu list
TabuLength = 10;
TabuList = ones(TabuLength, 3);

% Parameter TS
MaxIterateTime = 500;
NeighbourSolutionNum = 50;

%���ɾ����
DistanceMatrix = GenerateEarthDistanceMatrix(Lng_coordinate, Lat_coordinate);  %�������,��λΪ��
PackageTimeVec=3*DemandVec.^0.5+5;      %����demand��ÿ���ص�İ�������ʱ��
PackageTimeVec(ismember(1:length(DemandVec),[SiteVec,O2OshopVec]))=0;       %������ȡ��ʱ��Site,Shop���޴���ʱ��

%Generate initial solution
%SolusiAwal = GenerateSolusiNearestNeighbour(MatriksJarak);

allVehicleTSPsolution = GenerateSolusiRandom(ecOrderNum);
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
    range=4;
else 
    range=5;
end
for i = 1 : MaxIterateTime
    
    %���������
    for j = 1 : NeighbourSolutionNum
        iterateNum=iterateNum-1;
        [Target_ecSite_id , iterateNum , LeastCost , FinalCost]
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
            
            case 4% O2O insert
                [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformO2OInsert(CurrentDistrTSPsolution , VehicleNum , O2OshopVec , O2OspotVec);
                while(CheckDitrTSPsolution(NeighbourTSPsolutionTable(j, :),O2OshopVec,O2OspotVec,ecDemandVec , O2OdemandVec , volume))   %���Ϸ�����1
                    [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = Perform2Opt(CurrentDistrTSPsolution);
                end
                NeighbourVRPsolutionTable(:,:,j) = ConvertToMultiVRPsolution(NeighbourTSPsolutionTable(j, :),DemandVec,volume, ...
                                                                                         VehicleNum,O2OshopVec,O2OspotVec,O2OdemandVec);
                NeighbourVRPsolutionCostTable(j) =  CalculateMutiVRPtotalCost(NeighbourVRPsolutionTable(:,:,j),DistanceMatrix,...
                                                                 VehicleNum , PackageTimeVec , speed , StartTimeVec , EndTimeVec); 
            case 5% O2O swap
                [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformO2OSwap(CurrentDistrTSPsolution , O2OshopVec , O2OspotVec);
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
%disp('berapa kali PP');
%berapakalipp = hitungberapakalipp (sol2);
%disp(berapakalipp);
disp ('BestTSPsolution');
disp(BestTSPsolution);
%disp (BestVRPsolution);
disp ('Least Cost');
disp (LeastCost);
toc
% for i=1:VehicleNum
%     plot(Lng_coordinate(BestVRPsolution(i,:)),Lat_coordinate(BestVRPsolution(i,:)),'ro-');hold on;
% end
FinalCost=FinalCost+LeastCost;
end