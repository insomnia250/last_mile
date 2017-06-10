%�Ŵ��㷨 VRP ���� Matlabʵ��

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
% load matlab.mat
tic;
spotNum = 150;
Sup_Parent=[1 randperm(spotNum) + 1 1];
G=200;%��Ⱥ��С
Parent = zeros(G,spotNum+2);
for i=1:G
    Parent(i,:)=[1 randperm(spotNum) + 1 1];
end

volume = 15;
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
demandVec = [ 0 8 7 3 4 9 3 5 3 4 6 ...
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
distanceMatrix =  GenerateDistanceMatrix(X_coordinate, Y_coordinate);

Pc=0.2;%�������
% Pm=0.33;%�������
species=[Sup_Parent;Parent];%��Ⱥ
children=[];%�Ӵ�

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

g=input('����ʱ������');
for Generation=1:g 
    Generation
%%%%%%%%%%%%1%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Parent=species;%�Ӵ���ɸ���
children=[];%�Ӵ�
%ѡ�񽻲游��
[ParentNum , ~]=size(Parent);
                                                                                                         %����
% for i=1:ParentNum
%     for j=i:ParentNum
%         if i~=j && rand<Pc    %������������ͬparent�����ʽ��н���
%             children = jiaocha(children , Parent(i,:) , Parent(j,:) , spotNum);
%         end
%     end
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:ParentNum
    Pilihan = randi(3);
    switch (Pilihan)
        case 1
            solution=Parent(i,:);%�������
            solution = PerformInsert(solution);
            children=[children;solution];
         case 2
            solution=Parent(i,:);%�������
            solution = PerformSwap(solution);
            children=[children;solution];
         case 3
            solution=Parent(i,:);%�������
            solution = Perform2Opt(solution);
            children=[children;solution];
    end
%     if rand<Pm    %��ÿһ���������и��ʽ��б���
%         parent=Parent(i,:);%�������
%         X=randi(spotNum);     %[1, 30] randi(max)ȡֵ��Χ[1 , max]
%         Y=randi(spotNum);
%         Z=parent(X);
%         parent(X)=parent(Y);
%         parent(Y)=Z;                           %swap                                                                      %����
%         children=[children;parent];         %ͨ����������Ӵ�
%     end
end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% �����Ӵ���Ӧֵ
[childrenNum , ~]=size(children);
fitness_value_c=zeros(childrenNum,1);%�Ӵ���Ӧֵ
for i=1:childrenNum
    solution = children( i , :);
    VRPsolution = ConvertToVRPSolution (solution, demandVec, volume);
    totaldistance = CalculateTotalDistance (VRPsolution , distanceMatrix);
    fitness_value_c(i) = totaldistance;
end
%���㸸����Ӧֵ
[parentNum , ~]=size(Parent);
fitness_value_P=zeros(parentNum,1);%������Ӧֵ��������
for i=1:parentNum
    solution = Parent( i , :);
    VRPsolution = ConvertToVRPSolution (solution, demandVec, volume);
    totaldistance = CalculateTotalDistance (VRPsolution , distanceMatrix);
    fitness_value_P(i) = totaldistance;
end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%��̭�Ӵ�
[~ , sortedIndex_c]=sort(fitness_value_c);        %��С����
children=children(sortedIndex_c(1:G),:);   %ȡǰG���Ӵ�����
fitness_value_c=fitness_value_c(sortedIndex_c(1:G));
%��̭����
[~ , sortedIndex_p]=sort(fitness_value_P);
Parent=Parent(sortedIndex_p(1:G),:);
fitness_value_P=fitness_value_P(sortedIndex_p(1:G));
% %��̭��Ⱥ
species=[children;Parent];
fitness_value=[fitness_value_c;fitness_value_P];
[~ ,  sortedIndex]=sort(fitness_value);
species=species(sortedIndex(1:G),:);
fitness_value=fitness_value(sortedIndex(1:G));                                                                             %��������
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
toc
% species(1,:);%������·
fitness_value(1)%���ŷ���