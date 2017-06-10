function [Order_id , Site_id , Lng_site , Lat_site , Lng_spot , Lat_spot , Num , partNum]=PreRead_ecOrderData(filename , Target_ecSite_id ,k, StartLine , EndLine)
% filename='F:\T\km\data\test99_ecOrderData_format.csv';
ecOrderData = csvread(filename,1,0);        %跳过表头
part_ecOrderData=ecOrderData(ismember(ecOrderData(:,2),Target_ecSite_id),:);        %按照待优化的网点编号选择切片
part_ecOrderData=part_ecOrderData(ismember(part_ecOrderData(:,8),k),:); 
partNum = max(part_ecOrderData(: , 9));           %读取 划分部分数

if nargin<=3
   StartLine=1;
   [EndLine,~]=size(part_ecOrderData);
end
Order_id=part_ecOrderData(StartLine : EndLine,1);          %所有订单编号，唯一值
Site_id=part_ecOrderData(StartLine : EndLine,2);           %电商网点，范围[1,124]
Lng_site=part_ecOrderData(StartLine : EndLine,3);          %网点经度
Lat_site=part_ecOrderData(StartLine : EndLine,4);          %网点纬度
Lng_spot=part_ecOrderData(StartLine : EndLine,5);          %配送点经度
Lat_spot=part_ecOrderData(StartLine : EndLine,6);          %配送点纬度
Num=part_ecOrderData(StartLine : EndLine,7);               %包裹量
