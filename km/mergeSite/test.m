% clear all;
% tic;
% % filename1 = '..\data\ecOrderData_format.csv';
% % filename2 = '..\data\o2oOrderData_format.csv';
% load TSP_record.mat;
% load Site_id_record.mat;
% load 'cost_record.mat';
% filename1 = '..\data\s2\ecOrderData_format_kcenter.csv';
% filename2 = '..\data\s2\o2oOrderData_format_kcenter.csv';
% largeSiteRecord=[];CostSave = 0;fault=zeros(1,12);T = zeros(2,10);tt=0
% recordNum=0;
% volume = 140;  %容量
% speed=15000/60;       %15km/h，化成m/min
% 
% CourierID=0;        %信使编号
% FinalCostTotal=0;
% FinalPunishTime=0;
% FinalWaitTime=0;
% 
% for Target_ecSite_id=1:124
%     
% TotalDispatch=zeros(1,6);
% FinalCost=0;
% % if Target_ecSite_id==99
% %     kcenter=2;
% % else 
%     kcenter=1;
% % end
% for kthcenter=1:kcenter
% [ecOrder_id_total , ~,site_Lng_total , site_Lat_total , ~ , ~ , ~]=Read_ecOrderData(filename1,Target_ecSite_id,kthcenter);
% [o2oOrder_id_total , ~ , ~ , ~ , ~ , ~ , ~ , ~ , ~]=Read_o2oOrderData(filename2 , Target_ecSite_id,kthcenter);
% TotalecOrderNum = length(ecOrder_id_total);    %电商订单个数
% Totalo2oOrderNum=length(o2oOrder_id_total);    %O2O订单个数
% site_Lng=site_Lng_total(1,1);
% site_Lat=site_Lat_total(1,1);
% if Totalo2oOrderNum > 150
%     partNum=round(Totalo2oOrderNum/100);
% else
%  
%     partNum=1;
% end
% if partNum>1
%     T(1,tt) = Target_ecSite_id;
%     T(2,tt) = partNum;
%     tt=tt+1;
% end
% 
% 
% for part=1:partNum
%     recordNum=recordNum+1;
% 
% [ecOrder_id , ecSite_id , ecLng_site , ecLat_site , ecLng_spot , ecLat_spot , ecNum]=Read_ecOrderData(filename1,Target_ecSite_id ,1 , part);
% [o2oOrder_id , o2oShop_class , o2oLng_shop , o2oLat_shop , o2oLng_spot , o2oLat_spot , o2oNum , ...
%     o2oStartTime , o2oEndTime]=Read_o2oOrderData(filename2 , Target_ecSite_id ,1 , part);
% % scatter(ecLng_site(1),ecLat_site(1),'r');hold on;
% % scatter(ecLng_spot,ecLat_spot,'b');hold on;
% % scatter(o2oLng_shop,o2oLat_shop,'g');hold on;
% % scatter(o2oLng_spot,o2oLat_spot,'c');hold on;
% 
% ecOrderNum = length(ecOrder_id);    %电商订单个数
% o2oOrderNum=length(o2oOrder_id);    %O2O订单个数
% totalOrderNum = ecOrderNum+o2oOrderNum;
% 
% VehicleNum=round((ecOrderNum+0.4*o2oOrderNum)/10.58);
% 
% if VehicleNum==0
%     VehicleNum=1;
% end
% 
% 
% 
% end
% 
% end
% end

% load Site_id_record.mat;
% Site_id_recordMatrix = zeros(135 , 3);
% for i = 1:length(Site_id_record)
%     Site_id_recordMatrix(i , :) = Site_id_record{i};
% end
% filename='F:\T\km\mergeSite\Site_id_record.csv';
% csvwrite(filename,Site_id_recordMatrix)
clear all
load 'merged_TSP_record.mat';
load 'merged_cost_record.mat';
load 'merged_Site_id_record.mat';


merged_TSP_record_pre = merged_TSP_record;
merged_cost_record_pre = merged_cost_record;

load 'J:\T\newMerge\decrease_record\merged_decrease_record.mat';

load 'J:\T\newMerge\decrease_record\merged_TSP_record.mat';
load 'J:\T\newMerge\decrease_record\merged_cost_record.mat';
for MergedPair  =1:67
    if length(merged_cost_record{MergedPair})== 1
        if merged_cost_record_pre{MergedPair} < merged_cost_record{MergedPair}
            MergedPair
             merged_TSP_record{MergedPair} = merged_TSP_record_pre{MergedPair};
             merged_cost_record{MergedPair} = merged_cost_record_pre{MergedPair};
        end
    end
end
%     save 'merged_TSP_record.mat'  merged_TSP_record
%     save 'merged_cost_record.mat' merged_cost_record
%     save 'merged_decrease_record.mat' merged_decrease_record
%     save 'merged_Site_id_record.mat' merged_Site_id_record
