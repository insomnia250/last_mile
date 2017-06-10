clear all;
tic;

filename1 = '..\data\s2\ecOrderData_format_kcenter.csv';
filename2 = '..\data\s2\o2oOrderData_format_kcenter.csv';

volume = 140;  %容量
speed=15000/60;       %15km/h，化成m/min

CourierID=0;        %信使编号
FinalCostTotal=0;
FinalPunishTime=0;
FinalWaitTime=0;

for Target_ecSite_id=99:99
    
    TotalDispatch=zeros(1,6);
    SiteCost=0;
    
    kcenter=1;
    for kthcenter=1:kcenter
       [ecOrder_id , ecLng_site , ecLat_site , ecLng_spot , ecLat_spot , ecPackageNum]=Read_ecOrderData(filename1 , Target_ecSite_id ,kthcenter );
       
       [o2oOrder_id  , o2oLng_shop , o2oLat_shop , o2oLng_spot , o2oLat_spot , o2oPackageNum , o2oStartTime , o2oEndTime]=Read_o2oOrderData(filename2 , Target_ecSite_id ,kthcenter);
        
        ecOrderNum = length(ecOrder_id);    %电商订单个数
        o2oOrderNum=length(o2oOrder_id);    %O2O订单个数

        site_Lng=ecLng_site(1,1);       %作为中心的 网点 坐标
        site_Lat=ecLat_site(1,1);

        % scatter(ecLng_site(1),ecLat_site(1),'r');hold on;
        % scatter(ecLng_spot,ecLat_spot,'b');hold on;
        % scatter(o2oLng_shop,o2oLat_shop,'g');hold on;
        % scatter(o2oLng_spot,o2oLat_spot,'c');hold on；

        VehicleNum=80;
        % VehicleNum = round((sum(ecNum)+sum(o2oNum))/140);
      
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %      电商 向量 初始化
        EC_SpotVec= 2 : (ecOrderNum+1);
        
        EC_Lng_coordinate = [site_Lng   ecLng_spot'];          %电商（网点、配送点）经度向量
        EC_Lat_coordinate = [site_Lat   ecLat_spot'];        %电商（网点、配送点）纬度 向量
        EC_DemandVec = [0 ecPackageNum'];            %电商（网点、配送点）包裹量 向量 
        
        EC_StartTimeVec=zeros(1 , 1+ecOrderNum) ;    %电商无需等待
        EC_EndTimeVec=[999999 720+zeros(1,ecOrderNum)] ;       %电商到达时间限制为晚8点


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %      O2O 向量 初始化
        
        O2O_ShopVec=1+ ecOrderNum +(1:o2oOrderNum);  %代表O2Oshop的节点编号，也是距离矩阵索引
        O2O_SpotVec=1+ ecOrderNum + o2oOrderNum + (1:o2oOrderNum);
        
        O2O_ShopLng_coordinate = o2oLng_shop';
        O2O_ShopLat_coordinate = o2oLat_shop';
        O2O_SpotLng_coordinate = o2oLng_spot';
        O2O_SpotLat_coordinate = o2oLat_spot';
        
        O2O_DemandVec = o2oPackageNum';
        
        O2O_StartTimeVec=[o2oStartTime' , zeros(1,o2oOrderNum)] ;    % spot 的StartTime为0；
        O2O_EndTimeVec=[o2oStartTime' ,  o2oEndTime'] ;  

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %       统一 向量
        AllTaskSpotVec = 1 : (ecOrderNum + 2*o2oOrderNum);      %不包括起始点
        
        Lng_coordinate = [EC_Lng_coordinate , O2O_ShopLng_coordinate , O2O_SpotLng_coordinate];     %长度为1+ec订单数+2*o2o订单数
        Lat_coordinate = [EC_Lat_coordinate , O2O_ShopLat_coordinate , O2O_SpotLat_coordinate];
        DemandVec=[EC_DemandVec ,  zeros(1,o2oOrderNum) , O2O_DemandVec];

        StartTimeVec=[EC_StartTimeVec , O2O_StartTimeVec];
        EndTimeVec=[EC_EndTimeVec , O2O_EndTimeVec];
        
        PackageTimeVec=round(3*DemandVec.^0.5+5); 
        PackageTimeVec(ismember(1:length(DemandVec),[ 1 ,O2O_ShopVec]))=0;       %修正，取货时（Site,Shop）无处理时间
        %生成距离矩阵
         DistanceMatrix = GenerateEarthDistanceMatrix(Lng_coordinate, Lat_coordinate);  %距离矩阵,单位为米
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % 构造 任务 矩阵
        for j =1: 10000
            j
        TaskVec = zeros(1 , (ecOrderNum + o2oOrderNum));
        for i = 1:(ecOrderNum + o2oOrderNum)
            TaskVec(i) = randi(VehicleNum);
        end
        TaskVec(1) = 1;
        TaskVec;
        tic
        CostTotal = 0;
        for i = 1 : 3
            
%             i=1;
            PartTaskIndex = TaskVec==i;
            PartECTaskIndex = PartTaskIndex( 1 : ecOrderNum);
            PartO2OTaskIndex = PartTaskIndex( ecOrderNum+1 : ecOrderNum + o2oOrderNum);
            
            PartECOrderNum = sum(PartECTaskIndex);
            PartO2OOrderNum = sum(PartO2OTaskIndex);
            
            PartEC_SpotVec = EC_SpotVec(PartECTaskIndex);
            PartO2O_ShopVec = O2O_ShopVec(PartO2OTaskIndex);
            PartO2O_SpotVec = O2O_SpotVec(PartO2OTaskIndex);
            
            PartAllSpotVec = [PartEC_SpotVec , PartO2O_ShopVec , PartO2O_SpotVec];
            
            %局部 统一化           
            PartDistanceMatrix = DistanceMatrix([1 , PartEC_SpotVec , PartO2O_ShopVec , PartO2O_SpotVec] , [1 , PartEC_SpotVec , PartO2O_ShopVec , PartO2O_SpotVec]); 
            
            PartECDemandVec = DemandVec([1 , PartEC_SpotVec]);
            PartO2ODemandVec = DemandVec( PartO2O_SpotVec);
            PartDemandVec = DemandVec([1 , PartEC_SpotVec , PartO2O_ShopVec , PartO2O_SpotVec]);
            
            PartPackageTimeVec=PackageTimeVec([1 , PartEC_SpotVec , PartO2O_ShopVec , PartO2O_SpotVec]);
            
            
            PartStartTimeVec = StartTimeVec([1 , PartEC_SpotVec , PartO2O_ShopVec , PartO2O_SpotVec]);
            PartEndTimeVec = EndTimeVec([1 , PartEC_SpotVec , PartO2O_ShopVec , PartO2O_SpotVec]);
            
%             优化该任务
            fault = zeros(1,10);
            TabuSearch
            CostTotal = CostTotal+LeastCost;
        end
        end
        toc
    end
end

% filename_i=['F:\T\km\record\Site' int2str(Target_ecSite_id) '.csv'];
% csvwrite(filename_i,TotalDispatch)
% 
% disp ('Least Cost');
% disp (FinalCostTotal);
%  save  'Site_id_record.mat' 'Site_id_record'
%  save  'TSP_record.mat' 'TSP_record'
%  save 'cost_record.mat' 'cost_record'