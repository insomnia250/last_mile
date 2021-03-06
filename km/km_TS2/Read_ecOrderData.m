function [ecOrder_id , ecLng_site , ecLat_site , ecLng_spot , ecLat_spot , ecNum]=Read_ecOrderData(filename , Target_ecSite_id ,k )
% filename='F:\T\km\data\test99_ecOrderData_format.csv';
ecOrderData = csvread(filename,1,0);        %跳过表头

part_ecOrderData=ecOrderData(ismember(ecOrderData(:,2),Target_ecSite_id),:);        %按照待优化的网点编号选择切片
part_ecOrderData=part_ecOrderData(ismember(part_ecOrderData(:,8),k),:); 

ecOrder_id=part_ecOrderData( : ,1);          %所有订单编号，唯一值
ecLng_site=part_ecOrderData( : ,3);          %网点经度
ecLat_site=part_ecOrderData(: , 4);          %网点纬度
ecLng_spot=part_ecOrderData( : ,5);          %配送点经度
ecLat_spot=part_ecOrderData(: ,6);          %配送点纬度
ecNum=part_ecOrderData(: ,7);               %包裹量


% function [Order_id , Site_id , Lng_site , Lat_site , Lng_spot , Lat_spot , Num]=Read_ecOrderData(filename , Target_ecSite_id ,k, part)
% % filename='F:\T\km\data\test99_ecOrderData_format.csv';
% ecOrderData = csvread(filename,1,0);        %跳过表头
% part_ecOrderData=ecOrderData(ismember(ecOrderData(:,2),Target_ecSite_id),:);        %按照待优化的网点编号选择切片
% part_ecOrderData=part_ecOrderData(ismember(part_ecOrderData(:,8) , k),:);                 %k
% part_ecOrderData = part_ecOrderData( ismember(part_ecOrderData(:,9) ,  part),:); 
% 
% Order_id=part_ecOrderData(: , 1);          %所有订单编号，唯一值
% Site_id=part_ecOrderData(: , 2);         %电商网点，范围[1,124]
% Lng_site=part_ecOrderData(: , 3);         %网点经度
% Lat_site=part_ecOrderData(: , 4);          %网点纬度
% Lng_spot=part_ecOrderData(: , 5);        %配送点经度
% Lat_spot=part_ecOrderData(: , 6);         %配送点纬度
% Num=part_ecOrderData(: , 7);           %包裹量
