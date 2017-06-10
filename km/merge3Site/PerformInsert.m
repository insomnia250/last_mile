%���ѡ��һ��ecSpot�嵽����ط�
function [SolusiInsert , Spot_1 , Spot_2] = PerformInsert(TSPsolution ,ecOrderNum,seperator1 , seperator2 )

    SpotId = randi(ecOrderNum)+3;     %���ѡ��һ�����̶���SpotId  3ΪSite����
    if SpotId<=seperator1    %�����Site1��
        Index_1 = find(TSPsolution==SpotId,1); 
        temp_TSPsolution = [TSPsolution , 0];
        zeroSpot = find(temp_TSPsolution==0);
        Index_2 = Index_1;                  
        while Index_2 == Index_1
            Index_2 = randi(length(TSPsolution)-1) + 1;
            if Index_2 < Index_1
                zeroIndex1 = zeroSpot(find(zeroSpot < Index_2,1,'last'));   %�ҵ�С��Index_2�����һ��0
                zeroIndex2 = zeroSpot(find(zeroSpot >= Index_2,1,'first'));   %�ҵ�С��Index_2�����һ��0
            else
                zeroIndex1 = zeroSpot(find(zeroSpot <= Index_2,1,'last'));   %�ҵ�С��Index_2�����һ��0
                zeroIndex2 = zeroSpot(find(zeroSpot > Index_2,1,'first'));   %�ҵ�С��Index_2�����һ��0
            end
            if any(temp_TSPsolution(zeroIndex1 : zeroIndex2) > seperator1 & temp_TSPsolution(zeroIndex1 : zeroIndex2) < ecOrderNum+3)  %�����Site2 ����Site3��
                Index_2 = Index_1;
            end
        end
    elseif SpotId > seperator1 && SpotId <= seperator2     %�����Site2
        Index_1 = find(TSPsolution==SpotId,1); 
        temp_TSPsolution = [TSPsolution , 0];
        zeroSpot = find(temp_TSPsolution==0);
        Index_2 = Index_1;                  
        while Index_2 == Index_1
            Index_2 = randi(length(TSPsolution)-1) + 1;
            if Index_2 < Index_1
                zeroIndex1 = zeroSpot(find(zeroSpot < Index_2,1,'last'));   %�ҵ�С��Index_2�����һ��0
                zeroIndex2 = zeroSpot(find(zeroSpot >= Index_2,1,'first'));   %�ҵ�С��Index_2�����һ��0
            else
                zeroIndex1 = zeroSpot(find(zeroSpot <= Index_2,1,'last'));   %�ҵ�С��Index_2�����һ��0
                zeroIndex2 = zeroSpot(find(zeroSpot > Index_2,1,'first'));   %�ҵ�С��Index_2�����һ��0
            end
            if any(temp_TSPsolution(zeroIndex1 : zeroIndex2) > 3 & temp_TSPsolution(zeroIndex1 : zeroIndex2) <= seperator1)  || any(temp_TSPsolution(zeroIndex1 : zeroIndex2) > seperator2 & temp_TSPsolution(zeroIndex1 : zeroIndex2) < ecOrderNum+3)%�����Site1 ���� Site3��
                Index_2 = Index_1;
            end
        end
    else %SpotId > seperator2    %�����Site3
        Index_1 = find(TSPsolution==SpotId,1); 
        temp_TSPsolution = [TSPsolution , 0];
        zeroSpot = find(temp_TSPsolution==0);
        Index_2 = Index_1;                  
        while Index_2 == Index_1
            Index_2 = randi(length(TSPsolution)-1) + 1;
            if Index_2 < Index_1
                zeroIndex1 = zeroSpot(find(zeroSpot < Index_2,1,'last'));   %�ҵ�С��Index_2�����һ��0
                zeroIndex2 = zeroSpot(find(zeroSpot >= Index_2,1,'first'));   %�ҵ�С��Index_2�����һ��0
            else
                zeroIndex1 = zeroSpot(find(zeroSpot <= Index_2,1,'last'));   %�ҵ�С��Index_2�����һ��0
                zeroIndex2 = zeroSpot(find(zeroSpot > Index_2,1,'first'));   %�ҵ�С��Index_2�����һ��0
            end
            if any(temp_TSPsolution(zeroIndex1 : zeroIndex2) > 3 & temp_TSPsolution(zeroIndex1 : zeroIndex2) <= seperator2) %�����Site1 ���� Site2��
                Index_2 = Index_1;
            end
        end
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