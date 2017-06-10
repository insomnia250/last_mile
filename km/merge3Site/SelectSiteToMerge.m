
 clear all;
tic;
load TSP_record.mat;
load Site_id_record.mat;
load 'cost_record.mat';

load 'merged_TSP_record.mat';
load 'merged_cost_record.mat';
load 'merged_Site_id_record.mat';

load 'merged_decrease_record.mat';

filename1 = '..\data\s2\ecOrderData_format_kcenter.csv';
filename2 = '..\data\s2\o2oOrderData_format_kcenter.csv';
saveCost = 0;
% merged_TSP_record = {};
% merged_cost_record = {};
% merged_Site_id_record = {};
% merged_decrease_record = {};
% merged_increase_record = {};

largeSiteRecord=[];CostSave = 0;fault=zeros(1,12);

volume = 140;  %容量
speed=15000/60;       %15km/h，化成m/min

CourierID=0;        %信使编号
FinalCostSite = 0;
FinalCostTotal=0;
FinalPunishTime=0;
FinalWaitTime=0;



SiteData =  csvread('F:\T\km\data\s2\SiteData.csv',1,0);
partRecord = [65 , 72 , 93 , 94 , 99 , 116; 2 2 2 2 3 6];
mergedSites = [];
temp = 0;
for i = 1:length(partRecord)
    site = partRecord(1,i);
    for j = 2: partRecord(2,i)
        line = site + temp;
        SiteData = [SiteData(1:line , :) ; SiteData(line , :) ; SiteData(line+1:end , :)];
        temp = temp+1;
    end
end


 SiteDistanceMatrix = GenerateEarthDistanceMatrix2(SiteData(:,2),SiteData(:,3));  %距离矩阵,单位为米
SiteDistanceMatrix(SiteDistanceMatrix==0) = 10e10;
% tempk = 1;
%     while(tempk<=67)
%         
%         minDistance = min(min(SiteDistanceMatrix));
%         [recordNum1 , recordNum2] = find(SiteDistanceMatrix ==minDistance , 1);
%         if recordNum1 == 127 && recordNum2 ==30
%             break
%         end
%         SiteDistanceMatrix([recordNum1 , recordNum2] , :)=10e10;
%         SiteDistanceMatrix(:,[recordNum1 , recordNum2])=10e10;
%         tempk = tempk+1;
%     end


% tt = []
for MergedPair  =1:67
    
        
%         minDistance = min(min(SiteDistanceMatrix));
%         [recordNum1 , recordNum2] = find(SiteDistanceMatrix ==minDistance , 1);
%         SiteDistanceMatrix([recordNum1 , recordNum2] , :)=10e10;
%         SiteDistanceMatrix(:,[recordNum1 , recordNum2])=10e10;
        
        recordNum1 = merged_Site_id_record{MergedPair}(1);
        recordNum2 = merged_Site_id_record{MergedPair}(3);
    loadSites
    if o2oOrderNum ==0;
        tempSitesVec = [recordNum1 , recordNum2];
        merged_TSP_record{MergedPair} = {};
        merged_cost_record{MergedPair} = [];
        merged_Site_id_record{MergedPair} = [];
        for tempi = 1:2
            FinalCostTotal = FinalCostTotal + cost_record{tempSitesVec(tempi)};
            merged_TSP_record{MergedPair}{tempi} = TSP_record{tempSitesVec(tempi)};
            merged_cost_record{MergedPair}(tempi) = cost_record{tempSitesVec(tempi)};
        end
        merged_decrease_record{MergedPair} = 0;
        merged_Site_id_record{MergedPair}=[recordNum1 , part1 , recordNum2 , part2];
        continue
    end
    VehicleNum = numel(merged_TSP_record{MergedPair} , merged_TSP_record{MergedPair}==0 );
%     if VehicleNum<=1
%         VehicleNum=2;
%     end
% if recordNum1==89 && recordNum2 == 18
    TS_solve
% end
    




end

%     save 'merged_TSP_record.mat'  merged_TSP_record
%     save 'merged_cost_record.mat' merged_cost_record
%     save 'merged_Site_id_record.mat' merged_Site_id_record
%     save 'merged_increase_record.mat' merged_increase_record
