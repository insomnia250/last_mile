function [ecOrder_id , ecLng_site , ecLat_site , ecLng_spot , ecLat_spot , ecNum]=Read_ecOrderData(filename , Target_ecSite_id ,k )
% filename='F:\T\km\data\test99_ecOrderData_format.csv';
ecOrderData = csvread(filename,1,0);        %������ͷ

part_ecOrderData=ecOrderData(ismember(ecOrderData(:,2),Target_ecSite_id),:);        %���մ��Ż���������ѡ����Ƭ
part_ecOrderData=part_ecOrderData(ismember(part_ecOrderData(:,8),k),:); 

ecOrder_id=part_ecOrderData( : ,1);          %���ж�����ţ�Ψһֵ
ecLng_site=part_ecOrderData( : ,3);          %���㾭��
ecLat_site=part_ecOrderData(: , 4);          %����γ��
ecLng_spot=part_ecOrderData( : ,5);          %���͵㾭��
ecLat_spot=part_ecOrderData(: ,6);          %���͵�γ��
ecNum=part_ecOrderData(: ,7);               %������


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
