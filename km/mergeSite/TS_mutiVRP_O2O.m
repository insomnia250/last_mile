%Ini adalah implementasi Tabu Search untuk Traveling Salesman
%Problem

%untuk merekam waktu komputasi yang dibutuhkan
tic;

% %input data
% JumlahKota = 10;
% X_coordinate = [ 10 3 5 40 34 98 21 90 106 183 102];
% Y_coordinate = [10 120 45 71 91 23 38 98 110 140 105];
% Demand = [ 0 8 7 3 4 9 3 5 3 4 6];
%input data
ecSpotNum = 150; %城市数
O2OspotNum=50;  %电商数
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
SiteVec=[1];

%以下随机生成1~140的横纵坐标，一行20个,总共50
O2OshopX_coordinate = [... 
    49    59    43   129   133   123    45   133    70    45   109   105     3   116   106    42     7   101   112   135 ...
    110    15    70    99   109    50   105   124    70    20   4    59    73    52   101    10    94    75    62    71 ...
    25     4    64    26    83   109    40   119    82    41   ...
    ]; 
O2OshopY_coordinate = [... 
    31   126    25   115    37   102    19    60    72    25   19    69    69    97   130    48    68   119    44   129 ...
    109     4    28   114    20    11    16   140   105    78   39    15   109    91    71   122    91    62    88    45 ...
    4    53    85    55    23    12     2    98   109    54   ...
    ];
O2OspotX_coordinate = [... 
    121   102   132   112    96     4    68    97   111    17   30    87     8    60    49     5    64   107    77    48 ...
    122    13    61    91    12    69    56   137    75    23   136    68    81   117    71   113    28   136   101   128 ...
    10    56   125   115   102   125    72    30    36    70 ...
    ]; 
O2OspotY_coordinate = [...
    121    10    48   103    15   131     7    48    29    73   102    40    21   123    82    74    59    54   134   134 ...
    51    98    65    76    68   120   139    95    35    93   75    67    27   103    29    90    74   125   122     1 ...
    119   121    47    78    39    41   135    21    96    69 ...
    ];

O2OdemandVec=[...
    2     9    10     6     6     3     4     8     9     5   7    10     9    11     4     4     4     2     3     2 ...
    10     8     8     1     7    11     5     2     3     3   3     7    11    11     1     2     5     1     1     8 ...
    8     1    11     9     8     3    10     7     1     7 ...
    ];
O2OorderStartTime=[...
    455   530   500   579   478   542   476   453   394   335   369   316   501   462   321   357   424   508   357   533 ...
    377   409   560   585   372   547   454   439   416   514   546   237   460   275   499   402   210   240   520   337 ...
    358   531   396   472   391   486   568   317   264   231 ...
    ];
O2OorderEndTime=O2OorderStartTime+150 ;

X_coordinate = [ecX_coordinate,O2OshopX_coordinate,O2OspotX_coordinate];
Y_coordinate = [ecY_coordinate,O2OshopY_coordinate,O2OspotY_coordinate];
DemandVec=[ecDemandVec zeros(1,length(O2OshopX_coordinate)) O2OdemandVec];

O2OshopVec=length(ecX_coordinate)+(1:length(O2OshopX_coordinate));  %编号，也是距离矩阵索引
O2OspotVec=length(O2OshopX_coordinate)+length(ecX_coordinate)+(1:length(O2OshopX_coordinate));

ecStartTimeVec=zeros(1,length(ecX_coordinate)) ;    %电商无需等待
ecEndTimeVec=999999+zeros(1,length(ecX_coordinate)) ;       %电商无晚到惩罚
O2OStartTimeVec=[O2OorderStartTime, zeros(1,O2OspotNum)] ;    % spot 的StartTime为0；
O2OEndTimeVec=[999999+zeros(1,O2OspotNum),O2OorderEndTime] ;      %shop 的EndTime为无穷 ； 
StartTimeVec=[ecStartTimeVec , O2OStartTimeVec];
EndTimeVec=[ecEndTimeVec , O2OEndTimeVec];

%%

VehicleNum=20;   %信使数量
volume = 15;  %容量
speed=1;

% tabu list
TabuLength = 10;
TabuList = ones(TabuLength, 3);

% Parameter TS
MaxIterateTime = 400;
NeighbourSolutionNum = 50;

%生成距离表
DistanceMatrix = GenerateDistanceMatrix(X_coordinate, Y_coordinate);  %距离矩阵


%Generate initial solution
%SolusiAwal = GenerateSolusiNearestNeighbour(MatriksJarak);
allVehicleTSPsolution = GenerateSolusiRandom(ecSpotNum);
%Distribute task for vehicles
randNum=GenerateInsertNum(ecSpotNum,VehicleNum);
InitialDistrTSPsolution=TaskDistribute(allVehicleTSPsolution,randNum);
%随机插入O2O任务,同一个订单的shop和spot位于同一个vehicle中
InitialDistrTSPsolutionWithO2O=RandomInsertO2OTask(InitialDistrTSPsolution,O2OshopVec,O2OspotVec);
%生成初始mutiVRP解
InitialMutiVRPsolutionMaxtrix=ConvertToMultiVRPsolution(InitialDistrTSPsolutionWithO2O, ...
                                                        DemandVec,volume,O2OshopVec,O2OspotVec,O2OdemandVec);

initialCost=CalculateMutiVRPtotalCost(InitialMutiVRPsolutionMaxtrix,DistanceMatrix,DemandVec, ...
                                                                  speed , StartTimeVec , EndTimeVec , SiteVec , O2OshopVec);
%记录初始条件
%Tsekarang = Tawal;
BestTSPsolution = InitialDistrTSPsolutionWithO2O; %最优多车分配TSP解
BestVRPsolution = InitialMutiVRPsolutionMaxtrix; %最优VRP解
LeastCost = initialCost;  % 最小代价
CurrentDistrTSPsolution = InitialDistrTSPsolutionWithO2O; %当前TSP解，用于迭代，修改
CurrentVRPsolution = InitialMutiVRPsolutionMaxtrix; %当前多车VRP解
CurrentCost = initialCost; %当前代价

NeighbourTSPsolutionTable = zeros(NeighbourSolutionNum, ecSpotNum+2*O2OspotNum+VehicleNum);
NeighbourVRPsolutionTable = zeros(VehicleNum, (ecSpotNum+2*O2OspotNum) * 2 + 1,NeighbourSolutionNum);
NeighbourVRPsolutionCostTable = zeros(1, NeighbourSolutionNum);
OperateLocalSearchTable = zeros(NeighbourSolutionNum, 3);

BestNeighbourTSPsolution = zeros(1, ecSpotNum+2*O2OspotNum+VehicleNum);
BestNeighbourVRPsolution = zeros(VehicleNum, (ecSpotNum+2*O2OspotNum) * 2 + 1);
BestNeighbourVRPcost = 0;

BestNeighbourTSPsolutionTabu = zeros(1, ecSpotNum+2*O2OspotNum+VehicleNum);
BestNeighbourVRPsolutionTabu = zeros(VehicleNum, (ecSpotNum+2*O2OspotNum) * 2 + 1);
BestNeighbourVRPcostTabu = 0;


% Mulai iterasi TS
iterateNum=MaxIterateTime*NeighbourSolutionNum;
for i = 1 : MaxIterateTime
    
    %生成邻域解
    for j = 1 : NeighbourSolutionNum
        iterateNum=iterateNum-1;
        [iterateNum , LeastCost]
        Pilihan = randi(3);
        switch (Pilihan)
            case 1 % 1-insert
                [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformInsert(CurrentDistrTSPsolution);
                while(CheckDitrTSPsolution(NeighbourTSPsolutionTable(j, :),O2OshopVec,O2OspotVec))   %不合法返回1
                    [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformInsert(CurrentDistrTSPsolution);
                end
                NeighbourVRPsolutionTable(:,:,j) = ConvertToMultiVRPsolution(NeighbourTSPsolutionTable(j, :),DemandVec,volume, ...
                                                                                                O2OshopVec,O2OspotVec,O2OdemandVec);
                NeighbourVRPsolutionCostTable(j) =  CalculateMutiVRPtotalCost(NeighbourVRPsolutionTable(:,:,j),DistanceMatrix,...
                                                                          DemandVec, speed , StartTimeVec , EndTimeVec , SiteVec , O2OshopVec);
                
            case 2 % 1-swap
                [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformSwap(CurrentDistrTSPsolution);
                while(CheckDitrTSPsolution(NeighbourTSPsolutionTable(j, :),O2OshopVec,O2OspotVec))   %不合法返回1
                    [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = PerformSwap(CurrentDistrTSPsolution);
                end
                NeighbourVRPsolutionTable(:,:,j) = ConvertToMultiVRPsolution(NeighbourTSPsolutionTable(j, :),DemandVec,volume, ...
                                                                                                O2OshopVec,O2OspotVec,O2OdemandVec);
                NeighbourVRPsolutionCostTable(j) =  CalculateMutiVRPtotalCost(NeighbourVRPsolutionTable(:,:,j),DistanceMatrix,...
                                                                          DemandVec, speed , StartTimeVec , EndTimeVec , SiteVec , O2OshopVec);
                
            case 3 % 2-opt
                [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = Perform2Opt(CurrentDistrTSPsolution);
                while(CheckDitrTSPsolution(NeighbourTSPsolutionTable(j, :),O2OshopVec,O2OspotVec))   %不合法返回1
                    [NeighbourTSPsolutionTable(j, :), Kota_1, Kota_2 ] = Perform2Opt(CurrentDistrTSPsolution);
                end
                NeighbourVRPsolutionTable(:,:,j) = ConvertToMultiVRPsolution(NeighbourTSPsolutionTable(j, :),DemandVec,volume, ...
                                                                                                O2OshopVec,O2OspotVec,O2OdemandVec);
                NeighbourVRPsolutionCostTable(j) =  CalculateMutiVRPtotalCost(NeighbourVRPsolutionTable(:,:,j),DistanceMatrix,...
                                                                          DemandVec, speed , StartTimeVec , EndTimeVec , SiteVec , O2OshopVec);
        end
        OperateLocalSearchTable(j, :) = [Pilihan  Kota_1 Kota_2];
    end
    
    %判断这些邻域解是否是禁忌表中的解
    isTabu = zeros(1, NeighbourSolutionNum);
    for j = 1 : NeighbourSolutionNum
        for k = 1 : TabuLength
            if OperateLocalSearchTable(j, :) == TabuList(k, :)
                isTabu(j) = 1;
            end
        end
    end
    MaxCost=999999999;
    %找最优解或不是禁忌的解
    BestTabuIndex = 1;
    BestNotTabuIndex = 1;  
    BestNeighbourVRPcost = MaxCost;
    BestNeighbourVRPcostTabu = MaxCost;
    for j = 1 : NeighbourSolutionNum
        if  isTabu(j) == 0 % 如果不是禁忌解
            if NeighbourVRPsolutionCostTable(j) < BestNeighbourVRPcost
                BestNeighbourTSPsolution = NeighbourTSPsolutionTable(j, :);
                BestNeighbourVRPsolution = NeighbourVRPsolutionTable(:,:,j);
                BestNeighbourVRPcost = NeighbourVRPsolutionCostTable(j);
                BestNotTabuIndex = j;
            end
        else   %如果是禁忌解
            if NeighbourVRPsolutionCostTable(j) < BestNeighbourVRPcostTabu
                BestNeighbourTSPsolutionTabu = NeighbourTSPsolutionTable(j, :);
                BestNeighbourVRPsolutionTabu = NeighbourVRPsolutionTable(:,:,j);
                BestNeighbourVRPcostTabu = NeighbourVRPsolutionCostTable(j);
                BestTabuIndex = j;
            end
        end
    end
    
    % 检测是否是全局禁忌, 
    if BestNeighbourVRPcostTabu < LeastCost  %如果最优禁忌解优于最优解
        BestTSPsolution = BestNeighbourTSPsolutionTabu; %solusi global
        BestVRPsolution = BestNeighbourVRPsolutionTabu; %solusi global
        LeastCost = BestNeighbourVRPcostTabu; % Jarak solusi global
        CurrentDistrTSPsolution = BestNeighbourTSPsolutionTabu; %solusi iterasi
        CurrentVRPsolution = BestNeighbourVRPsolutionTabu; %solusi iterasi
        CurrentCost = BestNeighbourVRPcostTabu; % Jarak solusi iterasi
        %更新禁忌表
        IndeksTabuList = mod(i, TabuLength) + 1;   % i 是当前迭代次数，要更新的禁忌表索引
        TabuList(IndeksTabuList, :) = OperateLocalSearchTable(BestTabuIndex, :);
    else %如果最优禁忌邻域解不优于最优解
        CurrentDistrTSPsolution = BestNeighbourTSPsolution; %solusi iterasi
        CurrentVRPsolution = BestNeighbourVRPsolution; %solusi iterasi
        CurrentCost = BestNeighbourVRPcost; % Jarak solusi iterasi
        if BestNeighbourVRPcost < LeastCost
            BestTSPsolution = BestNeighbourTSPsolution; %solusi global
            BestVRPsolution = BestNeighbourVRPsolution; %solusi global
            LeastCost = BestNeighbourVRPcost; % Jarak solusi global
        end
        %update tabu list
        IndeksTabuList = mod(i, TabuLength) + 1;
        TabuList(IndeksTabuList, :) = OperateLocalSearchTable(BestNotTabuIndex, :);
    end

end
%disp('berapa kali PP');
%berapakalipp = hitungberapakalipp (sol2);
%disp(berapakalipp);
disp ('BestTSPsolution');
disp(BestTSPsolution);
%disp (BestVRPsolution);
disp ('Least Cost');
disp (LeastCost);
toc
for i=1:VehicleNum
    plot(X_coordinate(BestVRPsolution(i,:)),Y_coordinate(BestVRPsolution(i,:)),'ro-');hold on;
end