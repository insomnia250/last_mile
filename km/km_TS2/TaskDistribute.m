%用0间隔表示多车任务
function DistrTSPsolution=TaskDistribute(TSPsolution,VehicleNum)
DistrTSPsolution= [0 TSPsolution];
if VehicleNum==1
    return
end
for i= 2:VehicleNum
    insertIndex=randi(length(DistrTSPsolution)+1);
    DistrTSPsolution = [ DistrTSPsolution(1:insertIndex-1) 0 DistrTSPsolution(insertIndex:end) ];
end