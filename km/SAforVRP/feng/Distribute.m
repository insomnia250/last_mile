% 设置快递员的出生网点位置 之 根据每个网点的任务量分配人数
% 使用Huntington方法
% 已知：每个网点的task量T，快递员数量N_courier, 网点数量N_site
function Num=Distribute(N_courier, N_site, T)
% 首先每个网点分一个人
Num=ones(N_site,1);

% Huntington method
for i=1:N_courier-N_site
    Judge=(T.*T)./(Num.*(Num+1));
    j=find(Judge==max(Judge));
    j=j(1);
    Num(j)=Num(j)+1;
end

end
