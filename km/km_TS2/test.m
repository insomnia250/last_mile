% load TSP_record.mat;
load Site_id_record.mat;
 load 'cost_record.mat';
load TSP_record.mat;
% recordNum=123;
hardSite = [];V=0; ecO=0; o2oO = 0;aa=0
t=0

filename1 = '..\data\s2\ecOrderData_format_kcenter_part.csv';
filename2 = '..\data\s2\o2oOrderData_format_kcenter_part.csv';

volume = 140;  %容量
speed=15000/60;       %15km/h，化成m/min

CourierID=0;        %信使编号
FinalCostTotal=0;
FinalPunishTime=0;
FinalWaitTime=0;

for Target_ecSite_id=1:124
TotalDispatch=zeros(1,6);
siteFinalCost=0;
% if Target_ecSite_id==99
%     kcenter=2;
% else 
%     kcenter=2;
% end
kcenter=1;

[ecOrder_id_total , ~,site_Lng_total , site_Lat_total , ~ , ~ , ~,partNum]=PreRead_ecOrderData(filename1,Target_ecSite_id,1);
site_Lng=site_Lng_total(1,1);
site_Lat=site_Lat_total(1,1);

[o2oOrder_id_total , ~ , ~ , ~ , ~ , ~ , ~ , ~ , ~]=PreRead_o2oOrderData(filename2 , Target_ecSite_id,1);


for part=1:partNum
    recordNum=recordNum+1;

[ecOrder_id , ecSite_id , ecLng_site , ecLat_site , ecLng_spot , ecLat_spot , ecNum]=Read_ecOrderData(filename1,Target_ecSite_id ,1 , part);
[o2oOrder_id , o2oShop_class , o2oLng_shop , o2oLat_shop , o2oLng_spot , o2oLat_spot , o2oNum , ...
    o2oStartTime , o2oEndTime]=Read_o2oOrderData(filename2 , Target_ecSite_id ,1 , part);
% scatter(ecLng_site(1),ecLat_site(1),'r');hold on;
% scatter(ecLng_spot,ecLat_spot,'b');hold on;
% scatter(o2oLng_shop,o2oLat_shop,'g');hold on;
% scatter(o2oLng_spot,o2oLat_spot,'c');hold on;

ecOrderNum = length(ecOrder_id);    %电商订单个数
o2oOrderNum=length(o2oOrder_id);    %O2O订单个数
totalOrderNum = ecOrderNum+o2oOrderNum;

VehicleNum=round((ecOrderNum+0.4*o2oOrderNum)/10.58);

if VehicleNum==0
    VehicleNum=1;
end

V = V+VehicleNum;
ecO=ecO + ecOrderNum;
o2oO = o2oO +o2oOrderNum;
end
aa = aa+ length(ecOrder_id_total);
if ecO~=aa
    Target_ecSite_id
end
end
