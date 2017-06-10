%Ini adalah implementasi Simulated Annealing untuk Traveling Salesman
%Problem

%untuk merekam waktu komputasi yang dibutuhkan
tic;

%input data
% CityNum = 14;
% ecX_coordinate = [ 10 3 5 40 34 98 21 90 106 183 102];
% ecY_coordinate = [10 120 45 71 91 23 38 98 110 140 105];
% ecDemandVec = [ 0 8 7 3 4 9 3 5 3 4 6];

%input data
ecSpotNum=150;
AllSpotNum = 154; %城市数
ecX_coordinate = [ 50 3 5 40 34 98 21 90 106 183 102 ...
                            10 20 30 40 80 90 100 110 77 130 ...
                            22 22 32 42 82 92 132 25 122 95 ...
                            14 24 35 44 84 14 124 114 124 134 ...
                            16 88 36 46 26 12 116 116 54 136 ...
                            120 45 71 91 23 38 98 110 140 105 ...
                            10 50 20 40 90 80 130 120 23 44 ...
                            12 38 32 56 82 92 102 12 87 132 ...
                            14 15 34 25 84 94 34 114 124 33 ...
                            16 80 36 46 86 96 15 116 126 22 ...
                             14 15 34 25 84 94 34 114 124 33 ...
                            16 80 36 46 86 96 15 116 126 22 ...
                            3 5 40 34 98 21 90 106 183 102 ...
                            10 20 30 40 80 90 100 110 77 130 ...
                            22 22 32 42 82 92 132 25 122 95 ...
                            ];
ecY_coordinate = [50 120 45 71 91 23 38 98 110 140 105 ...
                            10 50 20 40 90 80 130 120 23 44 ...
                            12 38 32 56 82 92 102 12 87 132 ...
                            14 15 34 25 84 94 34 114 124 33 ...
                            16 80 36 46 86 96 15 116 126 22 ...
                            3 5 40 34 98 21 90 106 183 102 ...
                            10 20 30 40 80 90 100 110 77 130 ...
                            22 22 32 42 82 92 132 25 122 95 ...
                            14 24 35 44 84 14 124 114 124 134 ...
                            16 88 36 46 26 12 116 116 54 136 ...
                            14 24 35 44 84 14 124 114 124 134 ...
                            16 88 36 46 26 12 116 116 54 136 ...
                            120 45 71 91 23 38 98 110 140 105 ...
                            10 50 20 40 90 80 130 120 23 44 ...
                            12 38 32 56 82 92 102 12 87 132 ...
                            ];
ecDemandVec = [ 0 8 7 3 4 9 3 5 3 4 6 ...
                            10 9 8 7 6 5 4 3 2 1 ...
                            1 2 3 4 5 6 7 8 9 10 ...
                            10 9 8 7 6 5 4 3 2 1 ...
                            1 2 3 4 5 6 7 8 9 10 ...
                            8 7 3 4 9 3 5 3 4 6 ...
                            10 9 8 7 6 5 4 3 2 1 ...
                            1 2 3 4 5 6 7 8 9 10 ...
                            10 9 8 7 6 5 4 3 2 1 ...
                            1 2 3 4 5 6 7 8 9 10 ...
                            10 9 8 7 6 5 4 3 2 1 ...
                            1 2 3 4 5 6 7 8 9 10 ...
                            8 7 3 4 9 3 5 3 4 6 ...
                            10 9 8 7 6 5 4 3 2 1 ...
                            1 2 3 4 5 6 7 8 9 10 ...
                            ];
O2OshopX_coordinate = [160 85]; O2OshopY_coordinate = [140 95];
O2OspotX_coordinate = [170 65]; O2OspotY_coordinate = [120 105];
O2OdemandVec=[2,3];
X_coordinate = [ecX_coordinate,O2OshopX_coordinate,O2OspotX_coordinate];
Y_coordinate = [ecY_coordinate,O2OshopY_coordinate,O2OspotY_coordinate];
DemandVec=[ecDemandVec zeros(1,length(O2OshopX_coordinate)) O2OdemandVec];

O2OshopVec=length(ecX_coordinate)+(1:length(O2OshopX_coordinate));  %编号，也是距离矩阵索引
O2OspotVec=length(O2OshopX_coordinate)+length(ecX_coordinate)+(1:length(O2OshopX_coordinate));

VehicleNum=20;   %信使数量
volume = 15;  %容量
Tinitial = 8000;  %初始温度
Tend = 10;        %结束温度
CoolRate = 0.9999;

%generate tabel jarak
DistanceMatrix = GenerateDistanceMatrix(X_coordinate, Y_coordinate);

%Generate initial TSP solution
allVehicleTSPsolution=GenerateSolusiRandom(ecSpotNum);
%Distribute task for vehicles
randNum=GenerateInsertNum(ecSpotNum,VehicleNum);
InitialDistrTSPsolution=TaskDistribute(allVehicleTSPsolution,randNum);
%随机插入O2O任务,同一个订单的shop和spot位于同一个vehicle中
InitialDistrTSPsolutionWithO2O=RandomInsertO2OTask(InitialDistrTSPsolution,O2OshopVec,O2OspotVec);
InitialMutiVRPsolutionMaxtrix=ConvertToMultiVRPsolution(InitialDistrTSPsolutionWithO2O, ...
                                                        DemandVec,volume,O2OshopVec,O2OspotVec,O2OdemandVec);
initialCost=CalculateMutiVRPtotalCost(InitialMutiVRPsolutionMaxtrix,DistanceMatrix,DemandVec,VehicleNum);
%记录初始条件
Tnow = Tinitial;  %当前温度
BestTSPsolution = InitialDistrTSPsolutionWithO2O; %最优多车分配TSP解
BestVRPsolution = InitialMutiVRPsolutionMaxtrix; %最优VRP解
LeastCost = initialCost; % 最小代价
CurrentDistrTSPsolution = InitialDistrTSPsolutionWithO2O; %当前TSP解，用于迭代，修改
CurrentVRPsolution = InitialMutiVRPsolutionMaxtrix; %当前多车VRP解
CurrentCost = initialCost; %当前代价

%模拟退火迭代 SA
while Tnow > Tend
    [Tnow LeastCost]
    % pilih local search secara random
    Pilihan = randi(3);
    switch (Pilihan)
        case 1 % 1-insert
            NeighborSolution = PerformInsert(CurrentDistrTSPsolution);
            while(CheckDitrTSPsolution(NeighborSolution,O2OshopVec,O2OspotVec))   %不合法返回1
                NeighborSolution = PerformInsert(CurrentDistrTSPsolution);
            end
            NeibourVRPsolution = ConvertToMultiVRPsolution(NeighborSolution,DemandVec,volume, ...
                                                                                                O2OshopVec,O2OspotVec,O2OdemandVec);
            NeibourSolutionCost = CalculateMutiVRPtotalCost(NeibourVRPsolution,DistanceMatrix,DemandVec,VehicleNum);
            
        case 2 % 1-swap
            NeighborSolution = PerformSwap(CurrentDistrTSPsolution);
            while(CheckDitrTSPsolution(NeighborSolution,O2OshopVec,O2OspotVec))   %不合法返回1
                NeighborSolution = PerformSwap(CurrentDistrTSPsolution);
            end
            NeibourVRPsolution = ConvertToMultiVRPsolution(NeighborSolution,DemandVec,volume, ...
                                                                                                O2OshopVec,O2OspotVec,O2OdemandVec);
            NeibourSolutionCost = CalculateMutiVRPtotalCost(NeibourVRPsolution,DistanceMatrix,DemandVec,VehicleNum);
            
        case 3 % 2-opt
            NeighborSolution = Perform2Opt(CurrentDistrTSPsolution);
            while(CheckDitrTSPsolution(NeighborSolution,O2OshopVec,O2OspotVec))   %不合法返回1
                NeighborSolution = Perform2Opt(CurrentDistrTSPsolution);
            end
            NeibourVRPsolution = ConvertToMultiVRPsolution(NeighborSolution,DemandVec,volume, ...
                                                                                                O2OshopVec,O2OspotVec,O2OdemandVec);
            NeibourSolutionCost = CalculateMutiVRPtotalCost(NeibourVRPsolution,DistanceMatrix,DemandVec,VehicleNum);
    end
    
    % Cek apakah solusi tetangga lebih baik dari solusi saat ini
    if NeibourSolutionCost < CurrentCost
        CurrentDistrTSPsolution = NeighborSolution;
        CurrentVRPsolution = NeibourVRPsolution;
        CurrentCost = NeibourSolutionCost;
        % 最优情况
        if NeibourSolutionCost < LeastCost
            BestTSPsolution = NeighborSolution;
            BestVRPsolution = NeibourVRPsolution;
            LeastCost = NeibourSolutionCost;
        end
    else % kalau tidak lebih baik, diterima dengan probabilitas
        if rand < (Tnow - Tend) / (Tinitial - Tend);
            CurrentDistrTSPsolution = NeighborSolution;
            CurrentVRPsolution = NeibourVRPsolution;
            CurrentCost = NeibourSolutionCost;
        end
    end
    Tnow = Tnow * CoolRate;
end

disp('BestTSPsolution');
disp(BestTSPsolution);
disp('BestVRPsolution');
disp(BestVRPsolution);
disp('LeastCost');
disp(LeastCost);

toc
for i=1:VehicleNum
    plot(X_coordinate(BestVRPsolution(i,:)),Y_coordinate(BestVRPsolution(i,:)),'ro-');hold on;
end