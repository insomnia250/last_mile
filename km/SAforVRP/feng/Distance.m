% 计算电商问题中的目标函数值
% 已知s, c, D(n+1*n+1)
function d=Distance(s,c,D)
d=0;
n=length(s);
for j=1:n
    cj=find(c==j);
    if numel(cj)==0
        continue
    end
    kj=length(cj);
    for l=1:kj-1
        d=d+D(s(cj(l))+1,s(cj(l+1))+1);
    end
    d=d+D(1,s(cj(1))+1)+D(1,s(cj(kj))+1);
end

end