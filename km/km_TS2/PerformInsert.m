%���ѡ��һ��ecSpot��0�嵽����ط�
function [SolusiInsert , Spot_1 , Spot_2] = PerformInsert(TSPsolution ,ecOrderNum )

SpotId = randi(ecOrderNum)+1;     %���ѡ��һ�����̶���e
Index_1 = find(TSPsolution==SpotId,1); 

      
Index_2 = Index_1;                  

while Index_2 == Index_1
    Index_2 = randi(length(TSPsolution)-1) + 1;
end
Spot_1 = TSPsolution(Index_1); 
Spot_2 = TSPsolution(Index_2);
SolusiInsert = TSPsolution;
if Index_1 > Index_2 %Jika yg dipindahkan ada di sebelah kanan
    SolusiInsert(Index_2) = TSPsolution(Index_1);
    SolusiInsert(Index_2 + 1 : Index_1) = TSPsolution(Index_2 : Index_1 - 1);
else %Jika yg dipindahkan ada di sebelah kiri
    SolusiInsert(Index_2) = TSPsolution(Index_1);
    SolusiInsert(Index_1 : Index_2 - 1) = TSPsolution(Index_1+ 1 : Index_2);
end


% JumlahKota = numel(TSPsolution) - 1;    %��һ���ص�Ϊ0����������λ�þ��ɵ���
% Index_1 = randi(JumlahKota) + 1;        %��Index1λ�õ�ֵ�嵽Index2����ԭֵ˳��
% Index_2 = Index_1;
% while Index_2 == Index_1
%     Index_2 = randi(JumlahKota) + 1;
% end
% Spot_1 = TSPsolution(Index_1); 
% Spot_2 = TSPsolution(Index_2);
% SolusiInsert = TSPsolution;
% if Index_1 > Index_2 %Jika yg dipindahkan ada di sebelah kanan
%     SolusiInsert(Index_2) = TSPsolution(Index_1);
%     SolusiInsert(Index_2 + 1 : Index_1) = TSPsolution(Index_2 : Index_1 - 1);
% else %Jika yg dipindahkan ada di sebelah kiri
%     SolusiInsert(Index_2) = TSPsolution(Index_1);
%     SolusiInsert(Index_1 : Index_2 - 1) = TSPsolution(Index_1+ 1 : Index_2);
% end