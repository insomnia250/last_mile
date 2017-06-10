function solusivrp = ConvertToVRPSolution (solusitsp, demandkota, kapasitaskendaraan)
jumlahkota = numel(solusitsp) - 2;  %城市数
solusivrp = ones (1, jumlahkota * 2 + 1);
demandsekarang = 0; % 现在需求
indexvrpsekarang = 1;

for i =2 : jumlahkota + 1
    if demandsekarang + demandkota(solusitsp(i)) <= kapasitaskendaraan  % tidak perlu buat rute baru无需创建一个新路线
        demandsekarang = demandsekarang + demandkota(solusitsp(i));   %更新当前载货量
        indexvrpsekarang = indexvrpsekarang + 1;        %当前路线点编号
        solusivrp (indexvrpsekarang) = solusitsp (i);
    else % perlu buat rute baru  需要创建新路线
        % sisipkan depot kota 1     贴城市仓库1（不懂）？
        %demandsekarang = 0; 
        indexvrpsekarang = indexvrpsekarang + 1;
        solusivrp (indexvrpsekarang) = 1;   %本次返回
        % sisipkan kota berikutnya di rutebaru
        demandsekarang = demandkota(solusitsp(i));
        indexvrpsekarang = indexvrpsekarang + 1;
        solusivrp (indexvrpsekarang) = solusitsp (i);
    end
    
    
end