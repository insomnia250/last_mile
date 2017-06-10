function VRPsolution = ConvertToVRPSolution (solution, demandVec, volume)
jumlahkota = numel(solution) - 2;  %������
VRPsolution = ones (1, jumlahkota * 2 + 1);
demandsekarang = 0; % ��������
indexvrpsekarang = 1;

for i =2 : jumlahkota + 1
    if demandsekarang + demandVec(solution(i)) <= volume  % tidak perlu buat rute baru���贴��һ����·��
        demandsekarang = demandsekarang + demandVec(solution(i));   %���µ�ǰ�ػ���
        indexvrpsekarang = indexvrpsekarang + 1;        %��ǰ·�ߵ���
        VRPsolution (indexvrpsekarang) = solution (i);
    else % perlu buat rute baru  ��Ҫ������·��
        % sisipkan depot kota 1     �����вֿ�1����������
        %demandsekarang = 0; 
        indexvrpsekarang = indexvrpsekarang + 1;
        VRPsolution (indexvrpsekarang) = 1;   %���η���
        % sisipkan kota berikutnya di rutebaru
        demandsekarang = demandVec(solution(i));
        indexvrpsekarang = indexvrpsekarang + 1;
        VRPsolution (indexvrpsekarang) = solution (i);
    end 
end