function [SolusiSwap , Kota_1 , Kota_2] = PerformO2OSwap(TSPsolution , O2OshopVec , O2OspotVec)
O2ONum = numel(O2OshopVec);
Index_1 = randi(O2ONum);        %交换两O2O的值
Index_2 = Index_1;
while Index_2 == Index_1
    Index_2 = randi(O2ONum);
end
Kota_1 = Index_1; 
Kota_2 = Index_2;
shop1=O2OshopVec(Index_1);  spot1=O2OspotVec(Index_1); 
shop2=O2OshopVec(Index_2);  spot2=O2OspotVec(Index_2); 
SolusiSwap = TSPsolution;
shop1Index=find(TSPsolution==shop1,1);
spot1Index=find(TSPsolution==spot1,1);
shop2Index=find(TSPsolution==shop2,1);
spot2Index=find(TSPsolution==spot2,1);
%交换两个O2O
SolusiSwap(shop1Index) = TSPsolution(shop2Index);
SolusiSwap(spot1Index) = TSPsolution(spot2Index);
SolusiSwap(shop2Index) = TSPsolution(shop1Index);
SolusiSwap(spot2Index) = TSPsolution(spot1Index);

end