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
CityNum = 150; %城市数
X_coordinate = [ 50 3 5 40 34 98 21 90 106 183 102 ...
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
Y_coordinate = [50 120 45 71 91 23 38 98 110 140 105 ...
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
Demand = [ 0 8 7 3 4 9 3 5 3 4 6 ...
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

volume = 15;

% tabu list
TabuLength = 10;
TabuList = ones(TabuLength, 3);

% Parameter TS
MaxIterateTime = 1000;
JumlahSolusiTetangga = 100;

%生成距离表
MatriksJarak = GenerateDistanceMatrix(X_coordinate, Y_coordinate);  %距离矩阵
JaarakSolusiMaksimum = sum(sum(MatriksJarak));   %总距离

%Generate initial solution
%SolusiAwal = GenerateSolusiNearestNeighbour(MatriksJarak);
SolusiAwal = GenerateSolusiRandom(CityNum);
SolusiVRPAwal = ConvertToVRPSolution(SolusiAwal, Demand, volume);
JarakSolusiAwal = CalculateTotalDistance(SolusiVRPAwal, MatriksJarak);

%Catat kondisi awal
%Tsekarang = Tawal;
SolusiTerbaik = SolusiAwal; %solusi global
SolusiVRPTerbaik = SolusiVRPAwal; %solusi global
JarakSolusiTerbaik = JarakSolusiAwal; % Jarak solusi global
SolusiSaatIni = SolusiAwal; %solusi iterasi
SolusiVRPSaatIni = SolusiVRPAwal; %solusi iterasi
JarakSolusiSaatIni = JarakSolusiAwal; % Jarak solusi iterasi

TabelSolusiTSPTetangga = zeros(JumlahSolusiTetangga, CityNum + 2);
TabelSolusiVRPTetangga = zeros(JumlahSolusiTetangga, CityNum * 2 + 1);
TabelJarakSolusiVRPTetangga = zeros(1, JumlahSolusiTetangga);
TabelOperasiLocalSearch = zeros(JumlahSolusiTetangga, 3);

SolusiTSPTetanggaTerbaik = zeros(1, CityNum + 2);
SolusiVRPTetanggaTerbaik = zeros(1, CityNum * 2 + 1);
JarakSolusiVRPTetanggaTerbaik = 0;

SolusiTSPTetanggaTabuTerbaik = zeros(1, CityNum + 2);
SolusiVRPTetanggaTabuTerbaik = zeros(1, CityNum * 2 + 1);
JarakSolusiVRPTetanggaTabuTerbaik = 0;


% Mulai iterasi TS
for i = 1 : MaxIterateTime
    
    %generate solusi tetangga
    for j = 1 : JumlahSolusiTetangga
        
        Pilihan = randi(3);
        switch (Pilihan)
            case 1 % 1-insert
                [TabelSolusiTSPTetangga(j, :) Kota_1 Kota_2 ] = PerformInsert(SolusiSaatIni);
                TabelSolusiVRPTetangga(j, :) = ConvertToVRPSolution(TabelSolusiTSPTetangga(j, :), Demand, volume);
                TabelJarakSolusiVRPTetangga(j) = CalculateTotalDistance(TabelSolusiVRPTetangga(j, :), MatriksJarak);
                
            case 2 % 1-swap
                [TabelSolusiTSPTetangga(j, :)  Kota_1 Kota_2 ] = PerformSwap(SolusiSaatIni);
                TabelSolusiVRPTetangga(j, :) = ConvertToVRPSolution(TabelSolusiTSPTetangga(j, :), Demand, volume);
                TabelJarakSolusiVRPTetangga(j) = CalculateTotalDistance(TabelSolusiVRPTetangga(j, :), MatriksJarak);
                
            case 3 % 2-opt
                [TabelSolusiTSPTetangga(j, :)  Kota_1 Kota_2 ] = Perform2Opt(SolusiSaatIni);
                TabelSolusiVRPTetangga(j, :) = ConvertToVRPSolution(TabelSolusiTSPTetangga(j, :), Demand, volume);
                TabelJarakSolusiVRPTetangga(j) = CalculateTotalDistance(TabelSolusiVRPTetangga(j, :), MatriksJarak);
        end
        TabelOperasiLocalSearch(j, :) = [Pilihan  Kota_1 Kota_2];
    end
    
    %bedakan antara yg tabu maupun yg tidak tabu
    ApakahTabu = zeros(1, JumlahSolusiTetangga);
    for j = 1 : JumlahSolusiTetangga
        for k = 1 : TabuLength
            if TabelOperasiLocalSearch(j, :) == TabuList(k, :)
                ApakahTabu(j) = 1;
            end
        end
    end
    
    %cari solusi tetangga terbaik yg tabu maupun yg tidak tabu
    IndeksTabuTerbaik = 1;
    IndeksTidakTabuTerbaik = 1;  
    JarakSolusiVRPTetanggaTerbaik = JaarakSolusiMaksimum;
    JarakSolusiVRPTetanggaTabuTerbaik = JaarakSolusiMaksimum;
    for j = 1 : JumlahSolusiTetangga
        if  ApakahTabu(j) == 0 % apabila tidak tabu
            if TabelJarakSolusiVRPTetangga(j) < JarakSolusiVRPTetanggaTerbaik
                SolusiTSPTetanggaTerbaik = TabelSolusiTSPTetangga(j, :);
                SolusiVRPTetanggaTerbaik = TabelSolusiVRPTetangga(j, :);
                JarakSolusiVRPTetanggaTerbaik = TabelJarakSolusiVRPTetangga(j);
                IndeksTidakTabuTerbaik = j;
            end
        else
            if TabelJarakSolusiVRPTetangga(j) < JarakSolusiVRPTetanggaTabuTerbaik
                SolusiTSPTetanggaTabuTerbaik = TabelSolusiTSPTetangga(j, :);
                SolusiVRPTetanggaTabuTerbaik = TabelSolusiVRPTetangga(j, :);
                JarakSolusiVRPTetanggaTabuTerbaik = TabelJarakSolusiVRPTetangga(j);
                IndeksTabuTerbaik = j;
            end
        end
    end
    
    % uji yg tabu dengan global, kalau tidak masukkan yg tidak tabu
    if JarakSolusiVRPTetanggaTabuTerbaik < JarakSolusiTerbaik
        SolusiTerbaik = SolusiTSPTetanggaTabuTerbaik; %solusi global
        SolusiVRPTerbaik = SolusiVRPTetanggaTabuTerbaik; %solusi global
        JarakSolusiTerbaik = JarakSolusiVRPTetanggaTabuTerbaik; % Jarak solusi global
        SolusiSaatIni = SolusiTSPTetanggaTabuTerbaik; %solusi iterasi
        SolusiVRPSaatIni = SolusiVRPTetanggaTabuTerbaik; %solusi iterasi
        JarakSolusiSaatIni = JarakSolusiVRPTetanggaTabuTerbaik; % Jarak solusi iterasi
        %update tabu list
        IndeksTabuList = mod(i, TabuLength) + 1;
        TabuList(IndeksTabuList, :) = TabelOperasiLocalSearch(IndeksTabuTerbaik, :);
    else %update solusi saat ini dari solusi tidak tabu
        SolusiSaatIni = SolusiTSPTetanggaTerbaik; %solusi iterasi
        SolusiVRPSaatIni = SolusiVRPTetanggaTerbaik; %solusi iterasi
        JarakSolusiSaatIni = JarakSolusiVRPTetanggaTerbaik; % Jarak solusi iterasi
        if JarakSolusiVRPTetanggaTerbaik < JarakSolusiTerbaik
            SolusiTerbaik = SolusiTSPTetanggaTerbaik; %solusi global
            SolusiVRPTerbaik = SolusiVRPTetanggaTerbaik; %solusi global
            JarakSolusiTerbaik = JarakSolusiVRPTetanggaTerbaik; % Jarak solusi global
        end
        %update tabu list
        IndeksTabuList = mod(i, TabuLength) + 1;
        TabuList(IndeksTabuList, :) = TabelOperasiLocalSearch(IndeksTidakTabuTerbaik, :);
    end
end
%disp('berapa kali PP');
%berapakalipp = hitungberapakalipp (sol2);
%disp(berapakalipp);


disp (SolusiVRPTerbaik);
disp ('Jarak Terbaik');
disp (JarakSolusiTerbaik);
toc
plot(X_coordinate(SolusiVRPTerbaik),Y_coordinate(SolusiVRPTerbaik),'ro-')