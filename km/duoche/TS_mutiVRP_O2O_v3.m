%调整ec和O2O信使比例
clear all;
tic;
filename1 = '..\data\ecOrderData_format.csv';
filename2 = '..\data\o2oOrderData_format.csv';
largeSiteRecord=[];
recordNum=0;
volume = 140;  %容量
speed=15000/60;       %15km/h，化成m/min
sumV=0;
CourierID=900;        %信使编号
FinalCostTotal=0;
FinalPunishTime=0;
FinalWaitTime=0;

for Target_ecSite_id=7:116
TotalDispatch=zeros(1,6);
FinalCost=0;
% Target_ecSite_id=2;     %待优化的网点
[ecOrder_id_total , ~,site_Lng_total , site_Lat_total , ~ , ~ , ~]=Read_ecOrderData(filename1,Target_ecSite_id);
[o2oOrder_id_total , ~ , ~ , ~ , ~ , ~ , ~ , ~ , ~]=Read_o2oOrderData(filename2 , Target_ecSite_id);
TotalecOrderNum = length(ecOrder_id_total);    %电商订单个数
Totalo2oOrderNum=length(o2oOrder_id_total);    %O2O订单个数
site_Lng=site_Lng_total(1,1);
site_Lat=site_Lat_total(1,1);
if Totalo2oOrderNum>150
    partNum=round(Totalo2oOrderNum/100);
else
    partNum=1;
end

for part=1:partNum
    ecPartLength=round(TotalecOrderNum/partNum);
    o2oPartLength=round(Totalo2oOrderNum/partNum);
    
    ecStartLine = (part-1) * ecPartLength + 1;  
    ecEndLine=min(part * ecPartLength , TotalecOrderNum);
    o2oStartLine = (part-1) * o2oPartLength + 1;  
    o2oEndLine=min(part * o2oPartLength , Totalo2oOrderNum);

[ecOrder_id , ecSite_id , ecLng_site , ecLat_site , ecLng_spot , ecLat_spot , ecNum]=Read_ecOrderData(filename1,Target_ecSite_id , ecStartLine , ecEndLine);
[o2oOrder_id , o2oShop_class , o2oLng_shop , o2oLat_shop , o2oLng_spot , o2oLat_spot , o2oNum , ...
    o2oStartTime , o2oEndTime]=Read_o2oOrderData(filename2 , Target_ecSite_id , o2oStartLine , o2oEndLine);


ecOrderNum = length(ecOrder_id);    %电商订单个数
o2oOrderNum=length(o2oOrder_id);    %O2O订单个数
totalOrderNum = ecOrderNum+o2oOrderNum;
% VehicleNum=round((ecOrderNum+0.35*o2oOrderNum)/10.36);
% VehicleNum=round((ecOrderNum+0.4*o2oOrderNum)/10.52);
% VehicleNum=round((ecOrderNum+0.5*o2oOrderNum)/10.85);
% VehicleNum=round((ecOrderNum+0.75*o2oOrderNum)/11.67);
% VehicleNum=round((ecOrderNum+0.7*o2oOrderNum)/11.50);
% VehicleNum=round((ecOrderNum+o2oOrderNum)/12.49);
% VehicleNum=round((ecOrderNum+2*o2oOrderNum)/15.82);
% VehicleNum=round((ecOrderNum+0.45*o2oOrderNum)/10.69);
if Totalo2oOrderNum>200
    VehicleNum=round((ecOrderNum+0.4*o2oOrderNum)/10.52);
%     VehicleNum=round((ecOrderNum+0.35*o2oOrderNum)/10.36);
%     VehicleNum=round((ecOrderNum+0.75*o2oOrderNum)/11.67);
else
    VehicleNum=round((ecOrderNum+0.75*o2oOrderNum)/11.67);
end


% [电商site坐标，所有电商订单配送点坐标] 长度为1+ecOrderNum
ecLng_coordinate = [site_Lng   ecLng_spot'];          
ecLat_coordinate = [site_Lat   ecLat_spot'];
ecDemandVec = [0 ecNum'];
SiteVec=[1];            %用1表示Site节点，2到ecOrderNum+1表示各订单spot节点

%[所有O2O订单shop坐标] 长度即为o2oOrderNum
O2OshopLng_coordinate = o2oLng_shop';
O2OshopLat_coordinate = o2oLat_shop';
%[所有O2O订单spot坐标] 长度即为o2oOrderNum
O2OspotLng_coordinate = o2oLng_spot';
O2OspotLat_coordinate = o2oLat_spot';
O2OdemandVec = o2oNum';
O2OorderStartTime = o2oStartTime';
O2OorderEndTime= o2oEndTime';

Lng_coordinate = [ecLng_coordinate , O2OshopLng_coordinate , O2OspotLng_coordinate];     %长度为1+ec订单数+2*o2o订单数
Lat_coordinate = [ecLat_coordinate , O2OshopLat_coordinate , O2OspotLat_coordinate];
DemandVec=[ecDemandVec zeros(1,o2oOrderNum) O2OdemandVec];

ECspotVec= 2 : ecOrderNum+1;
O2OshopVec=1+ ecOrderNum +(1:o2oOrderNum);  %代表O2Oshop的节点编号，也是距离矩阵索引
O2OspotVec=1+ ecOrderNum + o2oOrderNum + (1:o2oOrderNum);

ecStartTimeVec=zeros(1,1+ecOrderNum) ;    %电商无需等待
ecEndTimeVec=[999999 720+zeros(1,ecOrderNum)] ;       %电商到达时间限制为晚8点
O2OStartTimeVec=[O2OorderStartTime , zeros(1,o2oOrderNum)] ;    % spot 的StartTime为0；
O2OEndTimeVec=[O2OorderStartTime ,  O2OorderEndTime] ;      
StartTimeVec=[ecStartTimeVec , O2OStartTimeVec];
EndTimeVec=[ecEndTimeVec , O2OEndTimeVec];

%%
% tabu list
TabuLength = 10;
TabuList = ones(TabuLength, 3);

% Parameter TS
MaxIterateTime = 700;
NeighbourSolutionNum = 60;

%生成距离表
DistanceMatrix = GenerateEarthDistanceMatrix(Lng_coordinate, Lat_coordinate);  %距离矩阵,单位为米
PackageTimeVec=round(3*DemandVec.^0.5+5);      %根据demand得每个地点的包裹处理时间
PackageTimeVec(ismember(1:length(DemandVec),[SiteVec,O2OshopVec]))=0;       %修正，取货时（Site,Shop）无处理时间

%Generate initial solution
%SolusiAwal = GenerateSolusiNearestNeighbour(MatriksJarak);

allVehicleTSPsolution = GenerateSolusiRandom(ecOrderNum);
if ecOrderNum==0
    allVehicleTSPsolution=[];
end
%Distribute task for vehicles

InitialDistrTSPsolution=TaskDistribute(allVehicleTSPsolution,VehicleNum);
%随机插入O2O任务,同一个订单的shop和spot位于同一个vehicle中
InitialDistrTSPsolutionWithO2O=RandomInsertO2OTask(InitialDistrTSPsolution,O2OshopVec,O2OspotVec);

while(CheckDitrTSPsolution(InitialDistrTSPsolutionWithO2O,O2OshopVec,O2OspotVec,ecDemandVec , O2OdemandVec , volume))   %不合法返回1
    InitialDistrTSPsolutionWithO2O=RandomInsertO2OTask(InitialDistrTSPsolution,O2OshopVec,O2OspotVec);
end
%生成初始mutiVRP解
InitialMutiVRPsolutionMaxtrix=ConvertToMultiVRPsolution(InitialDistrTSPsolutionWithO2O, ...
                                                        DemandVec,volume,VehicleNum,O2OshopVec,O2OspotVec,O2OdemandVec);

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
    range=4;
else 
    range=5;
end
for i = 1 : MaxIterateTime
    %生成邻域解
    for j = 1 : NeighbourSolutionNum
        iterateNum=iterateNum-1;
       %------------------------------------------------------------------------------------
        [Target_ecSite_id ,ecOrderNum , o2oOrderNum , part/partNum, iterateNum , LeastCost , FinalCost , FinalCostTotal , FinalPunishTime , FinalWaitTime]
        %-------------------------------------------------------------------------------------
        Pilihan = randi(range);
        switch (Pilihan)
            case 1 % 1-insert
                [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformInsert(CurrentDistrTSPsolution);
                while(CheckDitrTSPsolution(NeighbourTSPsolutionTable(j, :),O2OshopVec,O2OspotVec,ecDemandVec , O2OdemandVec , volume))   %不合法返回1
                    [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformInsert(CurrentDistrTSPsolution);
                end
                NeighbourVRPsolutionTable(:,:,j) = ConvertToMultiVRPsolution(NeighbourTSPsolutionTable(j, :),DemandVec,volume, ...
                                                                                        VehicleNum,O2OshopVec,O2OspotVec,O2OdemandVec);
                NeighbourVRPsolutionCostTable(j) =  CalculateMutiVRPtotalCost(NeighbourVRPsolutionTable(:,:,j),DistanceMatrix,...
                                                                   VehicleNum , PackageTimeVec , speed , StartTimeVec , EndTimeVec);
%                 
            case 2 % 1-swap
                [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformSwap(CurrentDistrTSPsolution);
                while(CheckDitrTSPsolution(NeighbourTSPsolutionTable(j, :),O2OshopVec,O2OspotVec,ecDemandVec , O2OdemandVec , volume))   %不合法返回1
                    [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformSwap(CurrentDistrTSPsolution);
                end
                NeighbourVRPsolutionTable(:,:,j) = ConvertToMultiVRPsolution(NeighbourTSPsolutionTable(j, :),DemandVec,volume, ...
                                                                                         VehicleNum,O2OshopVec,O2OspotVec,O2OdemandVec);
                NeighbourVRPsolutionCostTable(j) =  CalculateMutiVRPtotalCost(NeighbourVRPsolutionTable(:,:,j),DistanceMatrix,...
                                                                  VehicleNum , PackageTimeVec , speed , StartTimeVec , EndTimeVec);
                
            case 3 % 2-opt
                [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = Perform2Opt(CurrentDistrTSPsolution);
                while(CheckDitrTSPsolution(NeighbourTSPsolutionTable(j, :),O2OshopVec,O2OspotVec,ecDemandVec , O2OdemandVec , volume))   %不合法返回1
                    [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = Perform2Opt(CurrentDistrTSPsolution);
                end
                NeighbourVRPsolutionTable(:,:,j) = ConvertToMultiVRPsolution(NeighbourTSPsolutionTable(j, :),DemandVec,volume, ...
                                                                                         VehicleNum,O2OshopVec,O2OspotVec,O2OdemandVec);
                NeighbourVRPsolutionCostTable(j) =  CalculateMutiVRPtotalCost(NeighbourVRPsolutionTable(:,:,j),DistanceMatrix,...
                                                                 VehicleNum , PackageTimeVec , speed , StartTimeVec , EndTimeVec);
            
            case 4% O2O insert
                [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformO2OInsert(CurrentDistrTSPsolution , VehicleNum , O2OshopVec , O2OspotVec);
                while(CheckDitrTSPsolution(NeighbourTSPsolutionTable(j, :),O2OshopVec,O2OspotVec,ecDemandVec , O2OdemandVec , volume))   %不合法返回1
                    [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = Perform2Opt(CurrentDistrTSPsolution);
                end
                NeighbourVRPsolutionTable(:,:,j) = ConvertToMultiVRPsolution(NeighbourTSPsolutionTable(j, :),DemandVec,volume, ...
                                                                                         VehicleNum,O2OshopVec,O2OspotVec,O2OdemandVec);
                NeighbourVRPsolutionCostTable(j) =  CalculateMutiVRPtotalCost(NeighbourVRPsolutionTable(:,:,j),DistanceMatrix,...
                                                                 VehicleNum , PackageTimeVec , speed , StartTimeVec , EndTimeVec); 
            case 5% O2O swap
                [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformO2OSwap(CurrentDistrTSPsolution , O2OshopVec , O2OspotVec);
                while(CheckDitrTSPsolution(NeighbourTSPsolutionTable(j, :),O2OshopVec,O2OspotVec,ecDemandVec , O2OdemandVec , volume))   %不合法返回1
                    [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = Perform2Opt(CurrentDistrTSPsolution);
                end
                NeighbourVRPsolutionTable(:,:,j) = ConvertToMultiVRPsolution(NeighbourTSPsolutionTable(j, :),DemandVec,volume, ...
                                                                                         VehicleNum,O2OshopVec,O2OspotVec,O2OdemandVec);
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
                    ones(1,ecOrderNum)  O2OshopVec;
                    ecOrder_id'  (o2oOrder_id+9214)' ...
                    ];

[~ , ArriveTimeMatrix , DepartTimeMatrix , totalPunish , totalWait] = CalculateMutiVRPtotalCost(BestVRPsolution,DistanceMatrix,...
                                                                 VehicleNum , PackageTimeVec , speed , StartTimeVec , EndTimeVec); 
for i =1:VehicleNum
    CourierID=CourierID+1;
    DispatchMatrix=ExpressDispatch( BestVRPsolution(i,:) , OrderInfo , ArriveTimeMatrix(i,:) , DepartTimeMatrix(i,:) , DemandVec , CourierID);
     TotalDispatch=[TotalDispatch;DispatchMatrix];

end

% disp ('BestTSPsolution');
% disp(BestTSPsolution);
%disp (BestVRPsolution);
% disp ('Least Cost');
% disp (LeastCost);
toc
% for i=1:VehicleNum
%     plot(Lng_coordinate(BestVRPsolution(i,:)),Lat_coordinate(BestVRPsolution(i,:)),'ro-');hold on;
% end
recordNum=recordNum+1;
Site_id_record{recordNum}=[Target_ecSite_id part];
TSP_record{recordNum}=BestTSPsolution;          %save TSP_record
FinalCost=FinalCost+LeastCost;              %该节点的该部分总代价
FinalPunishTime=FinalPunishTime+totalPunish;
FinalWaitTime=FinalWaitTime+totalWait;

end
FinalCostTotal=FinalCostTotal + FinalCost;
if FinalCost>10000
    largeSiteRecord=[largeSiteRecord,Target_ecSite_id];
end
% filename_i=['F:\T\km\record\Site' int2str(Target_ecSite_id) '.csv'];
% csvwrite(filename_i,TotalDispatch)
end
disp ('Least Cost');
disp (FinalCostTotal);
% save  'Site_id_record.mat' 'Site_id_record'
% save  'TSP_record.mat' 'TSP_record'