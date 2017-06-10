function [Order_id , Shop_class , Lng_shop , Lat_shop , Lng_spot , Lat_spot , Num , start_time , end_time]= ...
                                                                                    Read_o2oOrderData(filename , Target_ecSite_id,  StartLine , EndLine)
%filename='F:\T\km\data\o2oOrderData_format.csv';
o2oOrderData = csvread(filename,1,0);        %������ͷ
part_o2oOrderData=o2oOrderData(ismember(o2oOrderData(:,2),Target_ecSite_id),:);     %���մ��Ż���������ѡ����Ƭ


if nargin<=3
   StartLine=1;
   [EndLine,~]=size(part_o2oOrderData);
end

Order_id=part_o2oOrderData(StartLine : EndLine,1);           %������ţ�Ψһ
Shop_class=part_o2oOrderData(StartLine : EndLine,2);         %�ö���shop���ָ�����ı��[1,124]
Lng_shop=part_o2oOrderData(StartLine : EndLine,3);                     %�̵꾭��
Lat_shop=part_o2oOrderData(StartLine : EndLine,4);                  %�̵�γ��
Lng_spot=part_o2oOrderData(StartLine : EndLine,5);               %���͵㾭��
Lat_spot=part_o2oOrderData(StartLine : EndLine,6);               %���͵�γ��
Num=part_o2oOrderData(StartLine : EndLine,7);                %��������
start_time=part_o2oOrderData(StartLine : EndLine,8);          %��ʼʱ��
end_time=part_o2oOrderData(StartLine : EndLine,9);                 %����ʱ�� 
end
% 
%  function [Order_id , Shop_class , Lng_shop , Lat_shop , Lng_spot , Lat_spot , Num , start_time , end_time]= ...
%                                                                                     Read_o2oOrderData(filename , Target_ecSite_id, k ,part)
% o2oOrderData = csvread(filename,1,0);        %������ͷ
% part_o2oOrderData=o2oOrderData(ismember(o2oOrderData(:,2),Target_ecSite_id),:);     %���մ��Ż���������ѡ����Ƭ
% part_o2oOrderData=part_o2oOrderData(ismember(part_o2oOrderData(:,10),k),:); 
% part_o2oOrderData = part_o2oOrderData( ismember(part_o2oOrderData(:,11) ,  part),:); 
% 
% 
% Order_id=part_o2oOrderData(:,1);             %������ţ�Ψһ
% Shop_class=part_o2oOrderData(:,2);           %�ö���shop���ָ�����ı��[1,124]
% Lng_shop=part_o2oOrderData(:,3);                        %�̵꾭��
% Lat_shop=part_o2oOrderData(:,4);                       %�̵�γ��
% Lng_spot=part_o2oOrderData(:,5);                  %���͵㾭��
% Lat_spot=part_o2oOrderData(:,6);                    %���͵�γ��
% Num=part_o2oOrderData(:,7);                     %��������
% start_time=part_o2oOrderData(:,8);                  %��ʼʱ��
% end_time=part_o2oOrderData(:,9);                    %����ʱ�� 
% end