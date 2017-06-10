% ���ÿ��Ա�ĳ�������λ�� ֮ ����ÿ���������������������
% ʹ��Huntington����
% ��֪��ÿ�������task��T�����Ա����N_courier, ��������N_site
function Num=Distribute(N_courier, N_site, T)
% ����ÿ�������һ����
Num=ones(N_site,1);

% Huntington method
for i=1:N_courier-N_site
    Judge=(T.*T)./(Num.*(Num+1));
    j=find(Judge==max(Judge));
    j=j(1);
    Num(j)=Num(j)+1;
end

end
