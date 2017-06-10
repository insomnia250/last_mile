recordNum1 = 50;
recordNum2 = 14;
recordNum3 = 24;

Site1 = Site_id_record{recordNum1}(1);  part1 = Site_id_record{recordNum1}(3);
Site2 = Site_id_record{recordNum2}(1);  part2 = Site_id_record{recordNum2}(3);
Site3 = Site_id_record{recordNum3}(1);  part3 = Site_id_record{recordNum3}(3);

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
scatter(site_Lng1,site_Lat1,'r');hold on;
scatter(ecLng_spot1,ecLat_spot1,'b');hold on;
scatter(o2oLng_shop1,o2oLat_shop1,'g');hold on;
scatter(o2oLng_spot1,o2oLat_spot1,'c');hold on;

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
scatter(site_Lng2,site_Lat2,'r');hold on;
scatter(ecLng_spot2,ecLat_spot2,'b');hold on;
scatter(o2oLng_shop2,o2oLat_shop2,'g');hold on;
scatter(o2oLng_spot2,o2oLat_spot2,'c');hold on;

ecOrderNum2 = length(ecOrder_id2);    %电商订单个数
o2oOrderNum2=length(o2oOrder_id2);    %O2O订单个数
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      Site3
[ecOrder_id_total3 , ~,site_Lng3 , site_Lat3 , ~ , ~ , ~]=Read_ecOrderData(filename1,Site3);
[o2oOrder_id_total3 , ~ , ~ , ~ , ~ , ~ , ~ , ~ , ~]=Read_o2oOrderData(filename2 , Site3);
ecOrderNum3 = length(ecOrder_id_total3);    %电商订单个数
o2oOrderNum3=length(o2oOrder_id_total3);    %O2O订单个数
site_Lng3=site_Lng3(1,1);
site_Lat3=site_Lat3(1,1);
if o2oOrderNum3 > 150
    partNum3=round(o2oOrderNum3/100);
else
    partNum3=1;
end


ecPartLength3=round(length(ecOrder_id_total3)/partNum3);
o2oPartLength3=round(length(o2oOrder_id_total3)/partNum3);
    
    ecStartLine3 = (part3-1) * ecPartLength3 + 1;  
    ecEndLine3=min(part3 * ecPartLength3 , length(ecOrder_id_total3));
    o2oStartLine3 = (part3-1) * o2oPartLength3 + 1;  
    o2oEndLine3=min(part3 * o2oPartLength3 , length(o2oOrder_id_total3));
    if part3 == partNum3
        ecEndLine3 = length(ecOrder_id_total3);
        o2oEndLine3 = length(o2oOrder_id_total3);
    end

[ecOrder_id3 , ~ , ~ , ~ , ecLng_spot3 , ecLat_spot3 , ecNum3]=Read_ecOrderData(filename1,Site3 , ecStartLine3 , ecEndLine3);
[o2oOrder_id3 , ~ , o2oLng_shop3 , o2oLat_shop3 , o2oLng_spot3 , o2oLat_spot3 , o2oNum3 , ...
    o2oStartTime3 , o2oEndTime3]=Read_o2oOrderData(filename2 , Site3  ,o2oStartLine3 , o2oEndLine3);
% 
scatter(site_Lng3,site_Lat3,'r');hold on;
scatter(ecLng_spot3,ecLat_spot3,'b');hold on;
scatter(o2oLng_shop3,o2oLat_shop3,'g');hold on;
scatter(o2oLng_spot3,o2oLat_spot3,'c');hold on;

ecOrderNum3 = length(ecOrder_id3);    %电商订单个数
o2oOrderNum3=length(o2oOrder_id3);    %O2O订单个数
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

SiteVec=[1 2 3];            %用1表示Site节点，2到ecOrderNum+1表示各订单spot节点
ecOrderNum = ecOrderNum1 + ecOrderNum2 + ecOrderNum3;
o2oOrderNum = o2oOrderNum1 + o2oOrderNum2 + o2oOrderNum3;

Lng_coordinate = [site_Lng1 , site_Lng2  , site_Lng3 , ecLng_spot1' , ecLng_spot2' , ecLng_spot3' , o2oLng_shop1' , o2oLng_shop2' , o2oLng_shop3' , o2oLng_spot1' , o2oLng_spot2' , o2oLng_spot3'];     %长度为1+ec订单数+2*o2o订单数
Lat_coordinate =[site_Lat1 , site_Lat2  , site_Lat3 , ecLat_spot1' , ecLat_spot2' , ecLat_spot3' , o2oLat_shop1' , o2oLat_shop2'  , o2oLat_shop3', o2oLat_spot1' , o2oLat_spot2' , o2oLat_spot3'];

ecDemandVec = [0 0 0 ecNum1'  ecNum2' ecNum3'];
O2OdemandVec = [o2oNum1' , o2oNum2' , o2oNum3'];
DemandVec=[ecDemandVec zeros(1,o2oOrderNum) O2OdemandVec];

StartTimeVec=[zeros(1,3+ecOrderNum) , o2oStartTime1' , o2oStartTime2' , o2oStartTime3' , zeros(1,o2oOrderNum)];
EndTimeVec=[999999 999999 999999 720+zeros(1,ecOrderNum) , o2oStartTime1' , o2oStartTime2'  , o2oStartTime3' ,o2oEndTime1' , o2oEndTime2' , o2oEndTime3'];




ECspotVec= (1 : ecOrderNum) + 3;
O2OshopVec=3+ ecOrderNum +(1:o2oOrderNum);  
O2OspotVec=3+ ecOrderNum + o2oOrderNum + (1:o2oOrderNum);

CityNum = [ecOrderNum1 , ecOrderNum2 , ecOrderNum3];
seperator1 = ecOrderNum1 + 3;
seperator2 = ecOrderNum1  + ecOrderNum2+ 3;

ecOrder_id = [ecOrder_id1 ; ecOrder_id2 ; ecOrder_id3];
o2oOrder_id = [o2oOrder_id1 ; o2oOrder_id2 ; o2oOrder_id3];


VehicleNum = numel(TSP_record{recordNum1} , TSP_record{recordNum1}==0 ) + numel(TSP_record{recordNum2} , TSP_record{recordNum2}==0 ) ...
    + numel(TSP_record{recordNum3} , TSP_record{recordNum3}==0 );
% 
% 
TS_solve



