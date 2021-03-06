function [Order_id , Shop_class , Lng_shop , Lat_shop , Lng_spot , Lat_spot , Num , start_time , end_time]= ...
                                                                                    Read_o2oOrderData(filename , Target_ecSite_id, k , StartLine , EndLine)
%filename='F:\T\km\data\o2oOrderData_format.csv';
o2oOrderData = csvread(filename,1,0);        %跳过表头
part_o2oOrderData=o2oOrderData(ismember(o2oOrderData(:,2),Target_ecSite_id),:);     %按照待优化的网点编号选择切片
part_o2oOrderData=part_o2oOrderData(ismember(part_o2oOrderData(:,10),k),:); 

if nargin<=3
   StartLine=1;
   [EndLine,~]=size(part_o2oOrderData);
end

Order_id=part_o2oOrderData(StartLine : EndLine,1);           %订单编号，唯一
Shop_class=part_o2oOrderData(StartLine : EndLine,2);         %该订单shop划分给网点的编号[1,124]
Lng_shop=part_o2oOrderData(StartLine : EndLine,3);                     %商店经度
Lat_shop=part_o2oOrderData(StartLine : EndLine,4);                  %商店纬度
Lng_spot=part_o2oOrderData(StartLine : EndLine,5);               %配送点经度
Lat_spot=part_o2oOrderData(StartLine : EndLine,6);               %配送点纬度
Num=part_o2oOrderData(StartLine : EndLine,7);                %包裹数量
start_time=part_o2oOrderData(StartLine : EndLine,8);          %开始时间
end_time=part_o2oOrderData(StartLine : EndLine,9);                 %结束时间 
end
% 
%  function [Order_id , Shop_class , Lng_shop , Lat_shop , Lng_spot , Lat_spot , Num , start_time , end_time]= ...
%                                                                                     Read_o2oOrderData(filename , Target_ecSite_id, k ,part)
% o2oOrderData = csvread(filename,1,0);        %跳过表头
% part_o2oOrderData=o2oOrderData(ismember(o2oOrderData(:,2),Target_ecSite_id),:);     %按照待优化的网点编号选择切片
% part_o2oOrderData=part_o2oOrderData(ismember(part_o2oOrderData(:,10),k),:); 
% part_o2oOrderData = part_o2oOrderData( ismember(part_o2oOrderData(:,11) ,  part),:); 
% 
% 
% Order_id=part_o2oOrderData(:,1);             %订单编号，唯一
% Shop_class=part_o2oOrderData(:,2);           %该订单shop划分给网点的编号[1,124]
% Lng_shop=part_o2oOrderData(:,3);                        %商店经度
% Lat_shop=part_o2oOrderData(:,4);                       %商店纬度
% Lng_spot=part_o2oOrderData(:,5);                  %配送点经度
% Lat_spot=part_o2oOrderData(:,6);                    %配送点纬度
% Num=part_o2oOrderData(:,7);                     %包裹数量
% start_time=part_o2oOrderData(:,8);                  %开始时间
% end_time=part_o2oOrderData(:,9);                    %结束时间 
% end