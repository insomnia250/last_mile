
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
volume = 140;  %����
speed=15000/60;       %15km/h������m/min

CourierID=0;        %��ʹ���
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
TotalecOrderNum = length(ecOrder_id_total);    %���̶�������
Totalo2oOrderNum=length(o2oOrder_id_total);    %O2O��������
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

ecOrderNum = length(ecOrder_id);    %���̶�������
o2oOrderNum=length(o2oOrder_id);    %O2O��������

totalOrderNum = ecOrderNum+o2oOrderNum;

VehicleNum=1;

% VehicleNum = round((sum(ecNum)+sum(o2oNum))/140);
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

    MaxIterateTime =400 ;
%     MaxIterateTime=100;
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

[initialCost , ~,~ , totalPunish ,~]=CalculateMutiVRPtotalCost(InitialMutiVRPsolutionMaxtrix,DistanceMatrix,...
                                                                  VehicleNum , PackageTimeVec , speed , StartTimeVec , EndTimeVec);
%��¼��ʼ����

 Cost = Cost+initialCost;
if totalPunish>0
    initialCost
   Pcost = Pcost + initialCost;
   pp = pp + totalPunish;
end
end

end
end
