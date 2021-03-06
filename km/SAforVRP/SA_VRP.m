%Ini adalah implementasi Simulated Annealing untuk Traveling Salesman
%Problem 印尼语啊！

%untuk merekam waktu komputasi yang dibutuhkan
tic;

%input data
JumlahKota = 150; %城市数
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
KapasitasKendaraan = 15;  %车辆容量
Tawal = 10000;  %初始温度  awal：初始，
Takhir = 10;        %结束温度  akhir：结束
TingkatPenurunanSuhu = 0.9999;  %温度冷却水平

%generate tabel jarak
%生成距离矩阵
MatriksJarak = GenerateDistanceMatrix(X_coordinate, Y_coordinate);

%Generate initial solution
%SolusiAwal = GenerateSolusiNearestNeighbour(MatriksJarak);
SolusiAwal = GenerateSolusiRandom(JumlahKota);
SolusiVRPAwal = ConvertToVRPSolution(SolusiAwal, Demand, KapasitasKendaraan);
JarakSolusiAwal = CalculateTotalDistance(SolusiVRPAwal, MatriksJarak);

%Catat kondisi awal
Tsekarang = Tawal;
SolusiTerbaik = SolusiAwal; %solusi global
SolusiVRPTerbaik = SolusiVRPAwal; %solusi global
jarakSolusiTerbaik = JarakSolusiAwal; % jarak solusi global
SolusiSaatIni = SolusiAwal; %solusi iterasi 迭代  当前解=初始解
SolusiVRPSaatIni = SolusiVRPAwal; %solusi iterasi
jarakSolusiSaatIni = JarakSolusiAwal; % jarak solusi iterasi

% Mulai iterasi SA 启动退火迭代
while Tsekarang > Takhir
    
    % pilih local search secara random
    Pilihan = randi(3);  %产生1-3的伪随机整数
    switch (Pilihan)
        case 1 % 1-insert
            SolusiTetangga = PerformInsert(SolusiSaatIni);   %Tetangga邻居
            SolusiVRPTetangga = ConvertToVRPSolution(SolusiTetangga, Demand, KapasitasKendaraan);
            JarakSolusiTetangga = CalculateTotalDistance(SolusiVRPTetangga, MatriksJarak);
            
        case 2 % 1-swap
            SolusiTetangga = PerformSwap(SolusiSaatIni);
            SolusiVRPTetangga = ConvertToVRPSolution(SolusiTetangga, Demand, KapasitasKendaraan);
            JarakSolusiTetangga = CalculateTotalDistance(SolusiVRPTetangga, MatriksJarak);
            
        case 3 % 2-opt
            SolusiTetangga = Perform2Opt(SolusiSaatIni);
            SolusiVRPTetangga = ConvertToVRPSolution(SolusiTetangga, Demand, KapasitasKendaraan);
            JarakSolusiTetangga = CalculateTotalDistance(SolusiVRPTetangga, MatriksJarak);
    end
    
    % Cek apakah solusi tetangga lebih baik dari solusi saat ini
    if JarakSolusiTetangga < jarakSolusiSaatIni  %如果随机操作的距离小于当前解
        SolusiSaatIni = SolusiTetangga;   %取代当前解
        SolusiVRPSaatIni = SolusiVRPTetangga;
        jarakSolusiSaatIni = JarakSolusiTetangga;
        % cek juga apakah lebih baik dari solusi global
        if JarakSolusiTetangga < jarakSolusiTerbaik  %如果优于最好解
            SolusiTerbaik = SolusiTetangga;         %取代最好解
            SolusiVRPTerbaik = SolusiVRPTetangga;
            jarakSolusiTerbaik = JarakSolusiTetangga;
        end
    else % kalau tidak lebih baik, diterima dengan probabilitas  如果操作后的解不优于当前解，被接受的概率
        if rand < (Tsekarang - Takhir) / (Tawal - Takhir);
            SolusiSaatIni = SolusiTetangga;       %按照温度概率使操作后的解作为当前解
            SolusiVRPSaatIni = SolusiVRPTetangga;
            jarakSolusiSaatIni = JarakSolusiTetangga;
        end
    end
    Tsekarang = Tsekarang * TingkatPenurunanSuhu;   %降温
end

disp('SolusiTerbaik');
disp(SolusiTerbaik);
disp('SolusiVRPTerbaik');
disp(SolusiVRPTerbaik);
disp('jarakSolusiTerbaik');
disp(jarakSolusiTerbaik);

toc
plot(X_coordinate(SolusiVRPTerbaik),Y_coordinate(SolusiVRPTerbaik),'ro-')