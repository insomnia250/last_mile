%随机选择一个ecSpot插到任意地方
function [SolusiInsert , Spot_1 , Spot_2] = PerformInsert(TSPsolution ,ecOrderNum,seperator )

    SpotId = randi(ecOrderNum)+2;     %随机选择一个电商订单SpotId
    if SpotId<=seperator    %如果是Site1的
        Index_1 = find(TSPsolution==SpotId,1); 
        temp_TSPsolution = [TSPsolution , 0];
        zeroSpot = find(temp_TSPsolution==0);
        Index_2 = Index_1;                  
        while Index_2 == Index_1
            Index_2 = randi(length(TSPsolution)-1) + 1;
            if Index_2 < Index_1
                zeroIndex1 = zeroSpot(find(zeroSpot < Index_2,1,'last'));   %找到小于Index_2的最后一个0
                zeroIndex2 = zeroSpot(find(zeroSpot >= Index_2,1,'first'));   %找到小于Index_2的最后一个0
            else
                zeroIndex1 = zeroSpot(find(zeroSpot <= Index_2,1,'last'));   %找到小于Index_2的最后一个0
                zeroIndex2 = zeroSpot(find(zeroSpot > Index_2,1,'first'));   %找到小于Index_2的最后一个0
            end
            if any(temp_TSPsolution(zeroIndex1 : zeroIndex2) > seperator & temp_TSPsolution(zeroIndex1 : zeroIndex2) <= ecOrderNum+2)  %如果有Site2的
                Index_2 = Index_1;
            end
        end
    else    %如果是Site2
        Index_1 = find(TSPsolution==SpotId,1); 
        temp_TSPsolution = [TSPsolution , 0];
        zeroSpot = find(temp_TSPsolution==0);
        Index_2 = Index_1;                  
        while Index_2 == Index_1
            Index_2 = randi(length(TSPsolution)-1) + 1;
            if Index_2 < Index_1
                zeroIndex1 = zeroSpot(find(zeroSpot < Index_2,1,'last'));   %找到小于Index_2的最后一个0
                zeroIndex2 = zeroSpot(find(zeroSpot >= Index_2,1,'first'));   %找到小于Index_2的最后一个0
            else
                zeroIndex1 = zeroSpot(find(zeroSpot <= Index_2,1,'last'));   %找到小于Index_2的最后一个0
                zeroIndex2 = zeroSpot(find(zeroSpot > Index_2,1,'first'));   %找到小于Index_2的最后一个0
            end
            if any(temp_TSPsolution(zeroIndex1 : zeroIndex2) > 2 & temp_TSPsolution(zeroIndex1 : zeroIndex2) <= seperator)  %如果有Site1的
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


% JumlahKota = numel(TSPsolution) - 1;    %第一个地点为0不动，其他位置均可调整
% Index_1 = randi(JumlahKota) + 1;        %将Index1位置的值插到Index2处，原值顺移
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