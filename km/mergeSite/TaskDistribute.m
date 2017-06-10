%用0间隔表示多车任务
function DistrTSPsolution=TaskDistribute(TSPsolution,VehicleNum , CityNum)

temp = 0;
for i = 1: length(CityNum)
    TSPsolution = [TSPsolution(1: temp) 0 , TSPsolution(temp+1: end)];
    temp =1+ temp+ CityNum(i);
end
DistrTSPsolution= [TSPsolution];
if VehicleNum==2
    return
end
for i= length(CityNum) + 1:VehicleNum
    insertIndex=randi(length(DistrTSPsolution)+1);
    DistrTSPsolution = [ DistrTSPsolution(1:insertIndex-1) 0 DistrTSPsolution(insertIndex:end) ];
end