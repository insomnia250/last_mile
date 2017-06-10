%OX顺序交叉策略
function children = jiaocha(children , P1 , P2 , spotNum)
% P1=Parent(i,:);
% P2=Parent(j,:);
P1 = P1(2:end-1);
P2 = P2(2:end-1);
%选择切点,交换中间部分 并且 修复基因
X=randi(spotNum-2)+1;         %randi(28)+1   [2,29]
Y=randi(spotNum-2)+1;
if X<Y
    change1=P1(X:Y);
    change2=P2(X:Y);
    %开始修复 Order Crossover
    %1.列出基因 
    p1=[P1(Y+1:end),P1(1:X-1),change1];
    p2=[P2(Y+1:end),P2(1:X-1),change2];
    %2.1删除已由基因 P1
    for i=1:length(change2)
        p1(p1==change2(i))=[];
    end
    %2.2删除已由基因 P2
    for i=1:length(change1)
        p2(p2==change1(i))=[];
    end
    %3.1修复 P1
    P1=[p1(spotNum-Y+1:end),change2,p1(1:spotNum-Y)];
    %3.1修复 P2
    P2=[p2(spotNum-Y+1:end),change1,p2(1:spotNum-Y)];
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
else
    change1=P1(Y:X);
    change2=P2(Y:X);
    %P1(Y:X)=change2;
    %P2(Y:X)=change1;
    %开始修复 Order Crossover
    %1.列出基因 
    p1=[P1(X+1:end),P1(1:Y-1),change1];
    p2=[P2(X+1:end),P2(1:Y-1),change2];
    %2.1删除已由基因 P1
    for i=1:length(change2)
        p1(p1==change2(i))=[];
    end
    %2.2删除已由基因 P2
    for i=1:length(change1)
        p2(p2==change1(i))=[];
    end
    %3.1修复 P1
    P1=[p1(spotNum-X+1:end),change2,p1(1:spotNum-X)];
    %3.1修复 P2
    P2=[p2(spotNum-X+1:end),change1,p2(1:spotNum-X)];
end
%加入子代
P1 = [1 P1 1];
P2 = [1 P2 1];
children=[children;P1;P2];
    