function VRPsolution = ConvertToVRPSolution (TSPsolution, DemandVec, volume,O2OshopVec,O2OspotVec,O2OdemandVec)
SpotNum = numel(TSPsolution) - 2;  %节点数，包括电商spot，O2Oshop，O2Ospot
Site = TSPsolution(1);
VRPsolution = zeros (1, SpotNum * 2 + 1) + Site;

CurrentLoad = 0; % 现在已经过路线需求的负载
routeIndex = 1;  %路经节点编号
CurrentO2OLoad=0;  %携带积存的O2O包裹数量
LoadAfterLastO2O=0; %最近O2Oshop之后的电商包裹负载
FirstO2OshopFlag=0;
maxBefore=0;
if isempty(O2OshopVec)
    maxO2OShop_id=-2;
    minO2OShop_id=-1;
    maxO2OSpot_id=-2;
    minO2OSpot_id=-2;
else
    maxO2OShop_id=O2OshopVec(end);
    minO2OShop_id=O2OshopVec(1);
    maxO2OSpot_id=O2OspotVec(end);
    minO2OSpot_id=O2OspotVec(1);
end

for i =2 : SpotNum + 1
    TSPsolution_i=TSPsolution(i);
    %----如果是O2Oshop
%     if ismember(TSPsolution(i),O2OshopVec)
    if TSPsolution_i>=minO2OShop_id && TSPsolution_i<=maxO2OShop_id
%         O2Oindex=find(O2OshopVec==TSPsolution(i));   %O2O订单（商店）索引，第几个订单
        O2Oindex=TSPsolution_i-minO2OShop_id+1;
        
        %不需要创建新路线
        if CurrentO2OLoad+O2OdemandVec(O2Oindex) <= volume
            %O2Oshop的ecDemand为0，所以可不更新当前载货量
            routeIndex = routeIndex + 1;        %当前路线点编号
            VRPsolution (routeIndex) = TSPsolution_i;
        else
            maxBefore=0;
            routeIndex = routeIndex + 1;
            VRPsolution (routeIndex) = Site;   %返回原点
            CurrentLoad = 0;
            routeIndex = routeIndex + 1;
            VRPsolution (routeIndex) = TSPsolution_i;
        end
        CurrentO2OLoad=CurrentO2OLoad+O2OdemandVec(O2Oindex);  %更新O2O积存负载
        LoadAfterLastO2O=0;
        FirstO2OshopFlag=1;
        maxBefore=max(maxBefore,CurrentO2OLoad);
    %---如果是O2Ospot，则无ecDemand，可直接添加
    elseif  TSPsolution_i>=minO2OSpot_id && TSPsolution_i<=maxO2OSpot_id     %别用ismember()
        routeIndex = routeIndex + 1;        %当前路线点编号
        VRPsolution (routeIndex) = TSPsolution_i;
        O2Oindex= TSPsolution_i-minO2OSpot_id+1;
        CurrentO2OLoad=CurrentO2OLoad-O2OdemandVec(O2Oindex);  %更新O2O积存负载
    %----如果是普通电商spot
    else               
        %无需创建一个新路线的情况
        if CurrentLoad + DemandVec(TSPsolution_i) <= volume  && ...
                CurrentO2OLoad+LoadAfterLastO2O+DemandVec(TSPsolution_i)<=volume && ...
                maxBefore + DemandVec(TSPsolution_i)<=volume
            CurrentLoad = CurrentLoad + DemandVec(TSPsolution_i);   %更新当前载货量
            LoadAfterLastO2O=LoadAfterLastO2O+DemandVec(TSPsolution_i);   %更新最近一个O2O之后电商包裹负载
            routeIndex = routeIndex + 1;        %当前路线点编号
            VRPsolution (routeIndex) = TSPsolution_i;
        else % perlu buat rute baru  需要创建新路线
            maxBefore=CurrentO2OLoad;
            routeIndex = routeIndex + 1;
            VRPsolution (routeIndex) = Site;   %本次返回
            % sisipkan kota berikutnya di rutebaru
            CurrentLoad = DemandVec(TSPsolution_i);  %更新电商包裹负载
            LoadAfterLastO2O=DemandVec(TSPsolution_i);  %更新最近一个O2O之后电商包裹负载
            routeIndex = routeIndex + 1;
            VRPsolution (routeIndex) = TSPsolution_i;
        end
        maxBefore= FirstO2OshopFlag * (maxBefore + DemandVec(TSPsolution_i));
    end   
end
