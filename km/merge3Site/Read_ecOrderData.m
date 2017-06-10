function [Order_id , Site_id , Lng_site , Lat_site , Lng_spot , Lat_spot , Num]=Read_ecOrderData(filename , Target_ecSite_id , StartLine , EndLine)
% filename='F:\T\km\data\test99_ecOrderData_format.csv';
ecOrderData = csvread(filename,1,0);        %������ͷ
part_ecOrderData=ecOrderData(ismember(ecOrderData(:,2),Target_ecSite_id),:);        %���մ��Ż���������ѡ����Ƭ

if nargin<=3
   StartLine=1;
   [EndLine,~]=size(part_ecOrderData);
end
Order_id=part_ecOrderData(StartLine : EndLine,1);          %���ж�����ţ�Ψһֵ
Site_id=part_ecOrderData(StartLine : EndLine,2);           %�������㣬��Χ[1,124]
Lng_site=part_ecOrderData(StartLine : EndLine,3);          %���㾭��
Lat_site=part_ecOrderData(StartLine : EndLine,4);          %����γ��
Lng_spot=part_ecOrderData(StartLine : EndLine,5);          %���͵㾭��
Lat_spot=part_ecOrderData(StartLine : EndLine,6);          %���͵�γ��
Num=part_ecOrderData(StartLine : EndLine,7);               %������


% function [Order_id , Site_id , Lng_site , Lat_site , Lng_spot , Lat_spot , Num]=Read_ecOrderData(filename , Target_ecSite_id ,k, part)
% % filename='F:\T\km\data\test99_ecOrderData_format.csv';
% ecOrderData = csvread(filename,1,0);        %������ͷ
% part_ecOrderData=ecOrderData(ismember(ecOrderData(:,2),Target_ecSite_id),:);        %���մ��Ż���������ѡ����Ƭ
% part_ecOrderData=part_ecOrderData(ismember(part_ecOrderData(:,8) , k),:);                 %k
% part_ecOrderData = part_ecOrderData( ismember(part_ecOrderData(:,9) ,  part),:); 
% 
% Order_id=part_ecOrderData(: , 1);          %���ж�����ţ�Ψһֵ
% Site_id=part_ecOrderData(: , 2);         %�������㣬��Χ[1,124]
% Lng_site=part_ecOrderData(: , 3);         %���㾭��
% Lat_site=part_ecOrderData(: , 4);          %����γ��
% Lng_spot=part_ecOrderData(: , 5);        %���͵㾭��
% Lat_spot=part_ecOrderData(: , 6);         %���͵�γ��
% Num=part_ecOrderData(: , 7);           %������
