TotalDispatch=zeros(1,6);

InitialDistrTSPsolutionWithO2O = merged_TSP_record{MergedPair};

% while(CheckDitrTSPsolution(InitialDistrTSPsolutionWithO2O,O2OshopVec,O2OspotVec,ecDemandVec , O2OdemandVec , volume))   %不合法返回1
%     InitialDistrTSPsolutionWithO2O=RandomInsertO2OTask(InitialDistrTSPsolution,O2OshopVec,O2OspotVec);
% end
% %生成初始mutiVRP解
InitialMutiVRPsolutionMaxtrix=ConvertToMultiVRPsolution(InitialDistrTSPsolutionWithO2O, ...
                                                        DemandVec,volume,VehicleNum,O2OshopVec,O2OspotVec,O2OdemandVec , DistanceMatrix , ecOrderNum , seperator);


[splitedTSPSolution , newVehicleNum] = VRP_Split_Route(InitialMutiVRPsolutionMaxtrix , O2OshopVec , ecOrderNum);

OrderInfo=[ ECspotVec  O2OspotVec ;...
                    ones(1,ecOrderNum1)  ones(1,ecOrderNum2)+1  O2OshopVec;
                    ecOrder_id'  (o2oOrder_id+9214)' ...
                    ];

BestVRPsolution = ConvertToMultiVRPsolution(splitedTSPSolution,DemandVec,volume, ...
                                                                                         newVehicleNum,O2OshopVec,O2OspotVec,O2OdemandVec , DistanceMatrix , ecOrderNum , seperator);
                
[LeastCost , ArriveTimeMatrix , DepartTimeMatrix , totalPunish , totalWait] = CalculateMutiVRPtotalCost(BestVRPsolution,DistanceMatrix,...
                                                                 newVehicleNum , PackageTimeVec , speed , StartTimeVec , EndTimeVec); 
for i =1:newVehicleNum
    CourierID=CourierID+1;
    DispatchMatrix=ExpressDispatch( BestVRPsolution(i,:) , OrderInfo , ArriveTimeMatrix(i,:) , DepartTimeMatrix(i,:) , DemandVec , ...
                                                                                                                                                            CourierID , ECspotVec , O2OshopVec) ;
     TotalDispatch=[TotalDispatch;DispatchMatrix];

end

toc

% merged_decrease_record{MergedPair} = 0;
if LeastCost < merged_cost_record{MergedPair}
    merged_decrease_record{MergedPair} = 1;
%     saveCost = saveCost + merged_cost_record{MergedPair} - LeastCost;
    
    merged_TSP_record{MergedPair}=splitedTSPSolution;
    merged_cost_record{MergedPair}=LeastCost;
    merged_Site_id_record{MergedPair}=[recordNum1 , part1 , recordNum2 , part2];
end


FinalPunishTime=FinalPunishTime+totalPunish;
FinalWaitTime=FinalWaitTime+totalWait;

FinalCostTotal=FinalCostTotal + LeastCost;

% if LeastCost<(cost_record{recordNum1} + cost_record{recordNum2})
%     filename_i=['F:\T\km\mergeSite\record\Site' ['recordnum' , int2str(recordNum1),'_',int2str(recordNum2)] '.csv'];
%     csvwrite(filename_i,TotalDispatch)
% end
 

 
%  save  'Site_id_record.mat' 'Site_id_record'
%  save  'TSP_record.mat' 'TSP_record'
%  save 'cost_record.mat' 'cost_record'