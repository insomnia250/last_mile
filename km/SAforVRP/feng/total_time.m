% ���ÿ��Ա�ĳ�������λ�� ֮ ����ÿ�������������(Ԥ����ʱ��)
% ��֪��ÿ����������͵����N��������X(N*1)�;���D(N*1)
function y=total_time(n,X,D);
%     n=5;
%     X=[20,500,130,150,240]';
%     D=[2,3,1,4,3]';
max_capacity=140;
v=1.5;
T=zeros(n,1);
for i=1:n
    c=ceil(X(i)/max_capacity);
    T(i)=2*D(i)*c/v+(c-1)*(3*sqrt(max_capacity)+5)...
        +sqrt(c*140)*3+5;
end
y=sum(T);
end
