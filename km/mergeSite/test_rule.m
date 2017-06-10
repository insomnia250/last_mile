
 clear all;
tic;Cost = 0; pp=0;Pcost = 0
% filename1 = '..\data\ecOrderData_format.csv';
% filename2 = '..\data\o2oOrderData_format.csv';
load TSP_record.mat;
load Site_id_record.mat;
load 'cost_record.mat';
filename1 = '..\data\s2\ecOrderData_format_kcenter.csv';
filename2 = '..\data\s2\o2oOrderData_format_kcenter.csv';
largeSiteRecord=[];CostSave = 0;fault=zeros(1,12);
recordNum=121;
volume = 140;  %容量
speed=15000/60;       %15km/h，化成m/min

CourierID=0;        %信使编号
FinalCostTotal=0;
FinalPunishTime=0;
FinalWaitTime=0;

for Target_ecSite_id=99:99
    
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
TotalecOrderNum = length(ecOrder_id_total);    %电商订单个数
Totalo2oOrderNum=length(o2oOrder_id_total);    %O2O订单个数
site_Lng=site_Lng_total(1,1);
site_Lat=site_Lat_total(1,1);
if Totalo2oOrderNum > 150
    partNum=round(Totalo2oOrderNum/100);
else
 
    partNum=1;
end
partNum = Totalo2oOrderNum
for part=1:partNum

    
    ecPartLength=round(TotalecOrderNum/partNum);
    ecPartLength=0;
    o2oPartLength=round(Totalo2oOrderNum/partNum);
    o2oPartLength = 1;
%     o2oPartLength=0;
    
    ecStartLine = (part-1) * ecPartLength + 1;  
    ecEndLine=min(part * ecPartLength , TotalecOrderNum);
    o2oStartLine = (part-1) * o2oPartLength + 1;  
    o2oEndLine=min(part * o2oPartLength , Totalo2oOrderNum);

[ecOrder_id , ecSite_id , ecLng_site , ecLat_site , ecLng_spot , ecLat_spot , ecNum]=Read_ecOrderData(filename1,Target_ecSite_id ,kthcenter, ecStartLine , ecEndLine);
[o2oOrder_id , o2oShop_class , o2oLng_shop , o2oLat_shop , o2oLng_spot , o2oLat_spot , o2oNum , ...
    o2oStartTime , o2oEndTime]=Read_o2oOrderData(filename2 , Target_ecSite_id ,kthcenter ,o2oStartLine , o2oEndLine);
% 
% scatter(ecLng_site(1),ecLat_site(1),'r');hold on;
% scatter(ecLng_spot,ecLat_spot,'b');hold on;
% scatter(o2oLng_shop,o2oLat_shop,'g');hold on;
% scatter(o2oLng_spot,o2oLat_spot,'c');hold on;

ecOrderNum = length(ecOrder_id);    %电商订单个数
o2oOrderNum=length(o2oOrder_id);    %O2O订单个数

totalOrderNum = ecOrderNum+o2oOrderNum;

VehicleNum=1;

% VehicleNum = round((sum(ecNum)+sum(o2oNum))/140);
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
TabuLength = 18;
TabuList = ones(TabuLength, 3);

% Parameter TS

    MaxIterateTime =400 ;
%     MaxIterateTime=100;
    NeighbourSolutionNum = 100;


%生成距离表
DistanceMatrix = GenerateEarthDistanceMatrix(Lng_coordinate, Lat_coordinate);  %距离矩阵,单位为米
PackageTimeVec=round(3*DemandVec.^0.5+5);      %根据demand得每个地点的包裹处理时间
PackageTimeVec(ismember(1:length(DemandVec),[SiteVec,O2OshopVec]))=0;       %修正，取货时（Site,Shop）无处理时间


allVehicleTSPsolution = GenerateSolusiRandom(ecOrderNum);
if ecOrderNum==0
    allVehicleTSPsolution=[];
end
%Distribute task for vehicles

InitialDistrTSPsolution=TaskDistribute(allVehicleTSPsolution,VehicleNum);
%随机插入O2O任务,同一个订单的shop和spot位于同一个vehicle中
InitialDistrTSPsolutionWithO2O=RandomInsertO2OTask(InitialDistrTSPsolution,O2OshopVec,O2OspotVec);
% InitialDistrTSPsolutionWithO2O=BestRecordTSP;
while(CheckDitrTSPsolution(InitialDistrTSPsolutionWithO2O,O2OshopVec,O2OspotVec,ecDemandVec , O2OdemandVec , volume))   %不合法返回1
    InitialDistrTSPsolutionWithO2O=RandomInsertO2OTask(InitialDistrTSPsolution,O2OshopVec,O2OspotVec);
end
%生成初始mutiVRP解
InitialMutiVRPsolutionMaxtrix=ConvertToMultiVRPsolution(InitialDistrTSPsolutionWithO2O, ...
                                                        DemandVec,volume,VehicleNum,O2OshopVec,O2OspotVec,O2OdemandVec);

[initialCost , ~,~ , totalPunish ,~]=CalculateMutiVRPtotalCost(InitialMutiVRPsolutionMaxtrix,DistanceMatrix,...
                                                                  VehicleNum , PackageTimeVec , speed , StartTimeVec , EndTimeVec);
%记录初始条件

 Cost = Cost+initialCost;
if totalPunish>0
    initialCost
   Pcost = Pcost + initialCost;
   pp = pp + totalPunish;
end
end

end
end
