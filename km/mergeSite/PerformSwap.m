function [SolusiSwap , Kota_1 , Kota_2] = PerformSwap(TSPsolution , ecOrderNum , seperator)
SpotId = randi(ecOrderNum)+2;     %���ѡ��һ�����̶���SpotId

if SpotId<=seperator    %�����Site1��
    Index_1 = find(TSPsolution==SpotId,1); 
    temp_TSPsolution = [TSPsolution , 0];
    zeroSpot = find(temp_TSPsolution==0);
    Index_2 = Index_1;                  
    while Index_2 == Index_1
        Index_2 = randi(length(TSPsolution)-1) + 1;
        zeroIndex1 = zeroSpot(find(zeroSpot < Index_2,1,'last'));   %�ҵ�С��Index_2�����һ��0
        zeroIndex2 = zeroSpot(find(zeroSpot > Index_2,1,'first'));   %�ҵ�С��Index_2�����һ��0
        if any(temp_TSPsolution(zeroIndex1 : zeroIndex2) > seperator & temp_TSPsolution(zeroIndex1 : zeroIndex2) <= ecOrderNum+2)  %����м���Site2��
            Index_2 = Index_1;
        end
    end
else    %�����Site2
    Index_1 = find(TSPsolution==SpotId,1); 
    temp_TSPsolution = [TSPsolution , 0];
    zeroSpot = find(temp_TSPsolution==0);
    Index_2 = Index_1;                  
    while Index_2 == Index_1
        Index_2 = randi(length(TSPsolution)-1) + 1;
        zeroIndex1 = zeroSpot(find(zeroSpot < Index_2,1,'last'));   %�ҵ�С��Index_2�����һ��0
        zeroIndex2 = zeroSpot(find(zeroSpot > Index_2,1,'first'));   %�ҵ�С��Index_2�����һ��0
        if any(temp_TSPsolution(zeroIndex1 : zeroIndex2) > 2 & temp_TSPsolution(zeroIndex1 : zeroIndex2) <= seperator)  %�����Site1��
            Index_2 = Index_1;
        end
    end
end
 
 
Kota_1 = TSPsolution(Index_1); 
Kota_2 = TSPsolution(Index_2);
SolusiSwap = TSPsolution;
SolusiSwap(Index_1) = TSPsolution(Index_2);
SolusiSwap(Index_2) = TSPsolution(Index_1);
end