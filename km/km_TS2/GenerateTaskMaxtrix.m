% 生成任务 矩阵
function TaskMatrix = GenerateTaskMaxtrix(VehicleNum ,  o2oOrderNum , ecOrderNum)

TaskMatrix = zeros(VehicleNum , (o2oOrderNum + ecOrderNum) );
TaskMatrix(1,1) =1;

for i = 2: (o2oOrderNum + ecOrderNum)
    v = randi(VehicleNum);
    TaskMatrix(v , i) = 1;
end
