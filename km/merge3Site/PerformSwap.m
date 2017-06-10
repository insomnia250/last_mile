function [SolusiSwap , Kota_1 , Kota_2] = PerformSwap(TSPsolution , ecOrderNum , seperator1 ,seperator2 )
SpotId = randi(ecOrderNum)+3;     %随机选择一个电商订单SpotId

if SpotId<=seperator1    %如果是Site1的
    Index_1 = find(TSPsolution==SpotId,1); 
    temp_TSPsolution = [TSPsolution , 0];
    zeroSpot = find(temp_TSPsolution==0);
    Index_2 = Index_1;                  
    while Index_2 == Index_1
        Index_2 = randi(length(TSPsolution)-1) + 1;
        zeroIndex1 = zeroSpot(find(zeroSpot < Index_2,1,'last'));   %找到小于Index_2的最后一个0
        zeroIndex2 = zeroSpot(find(zeroSpot > Index_2,1,'first'));   %找到小于Index_2的最后一个0
        if any(temp_TSPsolution(zeroIndex1 : zeroIndex2) > seperator1 & temp_TSPsolution(zeroIndex1 : zeroIndex2) < ecOrderNum+3)  %如果中间有Site2 或者Site3的
            Index_2 = Index_1;
        end
    end
elseif  SpotId > seperator1 &&  SpotId <= seperator2 %如果是Site2
    Index_1 = find(TSPsolution==SpotId,1); 
    temp_TSPsolution = [TSPsolution , 0];
    zeroSpot = find(temp_TSPsolution==0);
    Index_2 = Index_1;                  
    while Index_2 == Index_1
        Index_2 = randi(length(TSPsolution)-1) + 1;
        zeroIndex1 = zeroSpot(find(zeroSpot < Index_2,1,'last'));   %找到小于Index_2的最后一个0
        zeroIndex2 = zeroSpot(find(zeroSpot > Index_2,1,'first'));   %找到小于Index_2的最后一个0
        if any(temp_TSPsolution(zeroIndex1 : zeroIndex2) > 3 & temp_TSPsolution(zeroIndex1 : zeroIndex2) <= seperator1)  || any(temp_TSPsolution(zeroIndex1 : zeroIndex2) > seperator2 & temp_TSPsolution(zeroIndex1 : zeroIndex2) < ecOrderNum+3)%如果有Site1 或者 Site3的
            Index_2 = Index_1;
        end
    end
else %如果是Site3
    Index_1 = find(TSPsolution==SpotId,1); 
    temp_TSPsolution = [TSPsolution , 0];
    zeroSpot = find(temp_TSPsolution==0);
    Index_2 = Index_1;                  
    while Index_2 == Index_1
        Index_2 = randi(length(TSPsolution)-1) + 1;
        zeroIndex1 = zeroSpot(find(zeroSpot < Index_2,1,'last'));   %找到小于Index_2的最后一个0
        zeroIndex2 = zeroSpot(find(zeroSpot > Index_2,1,'first'));   %找到小于Index_2的最后一个0
        if any(temp_TSPsolution(zeroIndex1 : zeroIndex2) > 3 & temp_TSPsolution(zeroIndex1 : zeroIndex2) <= seperator2) %如果有Site1 或者 Site2的
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