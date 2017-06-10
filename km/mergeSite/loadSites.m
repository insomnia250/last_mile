
Site1 = Site_id_record{recordNum1}(1);  part1 = Site_id_record{recordNum1}(3);
Site2 = Site_id_record{recordNum2}(1);  part2 = Site_id_record{recordNum2}(3);
% Site1 = 104 ; part1 = 1;
% Site2 = 6; part2 = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[ecOrder_id_total1 , ~,site_Lng1 , site_Lat1 , ~ , ~ , ~]=Read_ecOrderData(filename1,Site1);
[o2oOrder_id_total1 , ~ , ~ , ~ , ~ , ~ , ~ , ~ , ~]=Read_o2oOrderData(filename2 , Site1);
ecOrderNum1 = length(ecOrder_id_total1);    %电商订单个数
o2oOrderNum1=length(o2oOrder_id_total1);    %O2O订单个数
site_Lng1=site_Lng1(1,1);
site_Lat1=site_Lat1(1,1);
if o2oOrderNum1 > 150
    partNum1=round(o2oOrderNum1/100);
else
    partNum1=1;
end


ecPartLength1=round(length(ecOrder_id_total1)/partNum1);
o2oPartLength1=round(length(o2oOrder_id_total1)/partNum1);
    
    ecStartLine1 = (part1-1) * ecPartLength1 + 1;  
    ecEndLine1=min(part1 * ecPartLength1 , length(ecOrder_id_total1));
    o2oStartLine1 = (part1-1) * o2oPartLength1 + 1;  
    o2oEndLine1=min(part1 * o2oPartLength1 , length(o2oOrder_id_total1));
    if part1 == partNum1
        ecEndLine1 = length(ecOrder_id_total1);
        o2oEndLine1 = length(o2oOrder_id_total1);
    end

[ecOrder_id1 , ~ , ~ , ~ , ecLng_spot1 , ecLat_spot1 , ecNum1]=Read_ecOrderData(filename1,Site1 , ecStartLine1 , ecEndLine1);
[o2oOrder_id1 , ~ , o2oLng_shop1 , o2oLat_shop1 , o2oLng_spot1 , o2oLat_spot1 , o2oNum1 , ...
    o2oStartTime1 , o2oEndTime1]=Read_o2oOrderData(filename2 , Site1  ,o2oStartLine1 , o2oEndLine1);
% 
% scatter(site_Lng1,site_Lat1,'r');hold on;
% scatter(ecLng_spot1,ecLat_spot1,'b');hold on;
% scatter(o2oLng_shop1,o2oLat_shop1,'g');hold on;
% scatter(o2oLng_spot1,o2oLat_spot1,'c');hold on;

ecOrderNum1 = length(ecOrder_id1);    %电商订单个数
o2oOrderNum1=length(o2oOrder_id1);    %O2O订单个数
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[ecOrder_id_total2 , ~,site_Lng2 , site_Lat2 , ~ , ~ , ~]=Read_ecOrderData(filename1,Site2);
[o2oOrder_id_total2 , ~ , ~ , ~ , ~ , ~ , ~ , ~ , ~]=Read_o2oOrderData(filename2 , Site2);
ecOrderNum2 = length(ecOrder_id_total2);    %电商订单个数
o2oOrderNum2=length(o2oOrder_id_total2);    %O2O订单个数
site_Lng2=site_Lng2(1,1);
site_Lat2=site_Lat2(1,1);
if o2oOrderNum2 > 150
    partNum2=round(o2oOrderNum2/100);
else
    partNum2=1;
end


ecPartLength2=round(length(ecOrder_id_total2)/partNum2);
o2oPartLength2=round(length(o2oOrder_id_total2)/partNum2);
    
    ecStartLine2 = (part2-1) * ecPartLength2 + 1;  
    ecEndLine2=min(part2 * ecPartLength2 , length(ecOrder_id_total2));
    o2oStartLine2 = (part2-1) * o2oPartLength2 + 1;  
    o2oEndLine2=min(part2 * o2oPartLength2 , length(o2oOrder_id_total2));
if part2 == partNum2
    ecEndLine2 = length(ecOrder_id_total2);
    o2oEndLine2 = length(o2oOrder_id_total2);
end

[ecOrder_id2 , ~ , ~ , ~ , ecLng_spot2 , ecLat_spot2 , ecNum2]=Read_ecOrderData(filename1,Site2 , ecStartLine2 , ecEndLine2);
[o2oOrder_id2 , ~ , o2oLng_shop2 , o2oLat_shop2 , o2oLng_spot2 , o2oLat_spot2 , o2oNum2 , ...
    o2oStartTime2 , o2oEndTime2]=Read_o2oOrderData(filename2 , Site2 ,o2oStartLine2 , o2oEndLine2);

% 
% scatter(site_Lng2,site_Lat2,'r');hold on;
% scatter(ecLng_spot2,ecLat_spot2,'b');hold on;
% scatter(o2oLng_shop2,o2oLat_shop2,'g');hold on;
% scatter(o2oLng_spot2,o2oLat_spot2,'c');hold on;

ecOrderNum2 = length(ecOrder_id2);    %电商订单个数
o2oOrderNum2=length(o2oOrder_id2);    %O2O订单个数

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

SiteVec=[1 2];            %用1表示Site节点，2到ecOrderNum+1表示各订单spot节点
ecOrderNum = ecOrderNum1 + ecOrderNum2;
o2oOrderNum = o2oOrderNum1 + o2oOrderNum2;

Lng_coordinate = [site_Lng1 , site_Lng2  , ecLng_spot1' , ecLng_spot2' , o2oLng_shop1' , o2oLng_shop2' , o2oLng_spot1' , o2oLng_spot2'];     %长度为1+ec订单数+2*o2o订单数
Lat_coordinate =[site_Lat1 , site_Lat2  , ecLat_spot1' , ecLat_spot2' , o2oLat_shop1' , o2oLat_shop2' , o2oLat_spot1' , o2oLat_spot2'];

ecDemandVec = [0 0 ecNum1'  ecNum2'];
O2OdemandVec = [o2oNum1' , o2oNum2'];
DemandVec=[ecDemandVec zeros(1,o2oOrderNum) O2OdemandVec];

StartTimeVec=[zeros(1,2+ecOrderNum) , o2oStartTime1' , o2oStartTime2' , zeros(1,o2oOrderNum)];
EndTimeVec=[999999 999999 720+zeros(1,ecOrderNum) , o2oStartTime1' , o2oStartTime2' ,o2oEndTime1' , o2oEndTime2'];




ECspotVec= (1 : ecOrderNum) + 2;
O2OshopVec=2+ ecOrderNum +(1:o2oOrderNum);  
O2OspotVec=2+ ecOrderNum + o2oOrderNum + (1:o2oOrderNum);

CityNum = [ecOrderNum1 , ecOrderNum2];
seperator = ecOrderNum1 + 2;

ecOrder_id = [ecOrder_id1 ; ecOrder_id2];
o2oOrder_id = [o2oOrder_id1 ; o2oOrder_id2];

%生成距离表
DistanceMatrix = GenerateEarthDistanceMatrix(Lng_coordinate, Lat_coordinate);  %距离矩阵,单位为米
PackageTimeVec=round(3*DemandVec.^0.5+5);      %根据demand得每个地点的包裹处理时间
PackageTimeVec(ismember(1:length(DemandVec),[SiteVec,O2OshopVec]))=0;       %修正，取货时（Site,Shop）无处理时间


% VehicleNum = numel(TSP_record{recordNum1} , TSP_record{recordNum1}==0 ) + numel(TSP_record{recordNum2} , TSP_record{recordNum2}==0 );
% 
% 
% TS_solve



