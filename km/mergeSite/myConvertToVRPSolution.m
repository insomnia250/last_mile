function solusivrp = myConvertToVRPSolution (solusitsp, demandkota, kapasitaskendaraan)
jumlahkota = numel(solusitsp) - 2;  %������
solusivrp = ones (1, jumlahkota * 2 + 1);
demandsekarang = 0; % ��������
indexvrpsekarang = 1;

for i =2 : jumlahkota + 1
    if demandsekarang + demandkota(solusitsp(i)) <= kapasitaskendaraan ...
            && OTOnum + numAfterLastOTO+demandkota(solusitsp(i))<=kapasitaskendaraan % ���贴��һ����·��
        demandsekarang = demandsekarang + demandkota(solusitsp(i));   %���µ�ǰ�ػ���
        indexvrpsekarang = indexvrpsekarang + 1;        %��ǰ·�ߵ���
        solusivrp (indexvrpsekarang) = solusitsp (i);
    else % perlu buat rute baru  ��Ҫ������·��
        % sisipkan depot kota 1     �����вֿ�1����������
        %demandsekarang = 0; 
        indexvrpsekarang = indexvrpsekarang + 1;
        solusivrp (indexvrpsekarang) = 1;   %���η���
        % sisipkan kota berikutnya di rutebaru
        demandsekarang = demandkota(solusitsp(i));
        indexvrpsekarang = indexvrpsekarang + 1;
        solusivrp (indexvrpsekarang) = solusitsp (i);
    end
    if solusitsp(i)<0 && solusitsp(i)>-5000  %�����O2O��������O2O�̵���ȡ-5000��0��
        OTOnum+=
    end
    
    
end