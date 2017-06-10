#coding=utf-8
import numpy as np
import pandas as pd
from pandas import Series
from pandas import DataFrame
import csv
import os
from datetime import datetime

ecOrderData=pd.read_csv('./data_merged/s2/ecOrderMerged.csv')
o2oOrderData=pd.read_csv('./data_merged/s2/o2oOrderMerged.csv')

spotData=pd.read_csv('./data/s2/spotData.csv')
siteData=pd.read_csv('./data/s2/siteData.csv')

AddrData1=ecOrderData.ix[:,['Order_id', 'Spot_id' , 'Site_id']]
AddrData2=o2oOrderData.ix[:,['Order_id', 'Spot_id' , 'Shop_id']]
AddrData1.columns=['Order_id', 'Target_spot' , 'Start_spot']
AddrData2.columns=['Order_id', 'Target_spot' , 'Start_spot']

AddrData2.index = AddrData2.index + 9214

AddrData=pd.concat([AddrData1,AddrData2])
AddrData.index = AddrData.index+1
AddrData['Order_id_num'] = AddrData.index

ToatalSubmitData=DataFrame()



for i in range(1,125):
    FileName = '../km/record_test/Site'+str(i)+'.csv'
    ColumnNames=['CourierNum' , 'Addr' , 'Arrival_time' , 'Departure' , 'Amount' , 'Order_id_num'] 
    SubmitData=pd.read_csv(FileName , header=0,names=ColumnNames)
    ToatalSubmitData=pd.concat([ToatalSubmitData,SubmitData])

FinalSubmissionData=pd.merge(ToatalSubmitData , AddrData , how='left',on='Order_id_num') 

FinalSubmissionData.Addr[FinalSubmissionData.Amount>0]=FinalSubmissionData.Start_spot[FinalSubmissionData.Amount>0]
FinalSubmissionData.Addr[FinalSubmissionData.Amount<0]=FinalSubmissionData.Target_spot[FinalSubmissionData.Amount<0]

CouriersUnique = DataFrame({'CourierNum':FinalSubmissionData.CourierNum.unique()})
CouriersUnique['Courier_id'] = CouriersUnique.index + 1
CouriersUnique['Courier_id'] = 'D' + CouriersUnique['Courier_id'].astype(str).str.zfill(4)


FinalSubmissionData = pd.merge(FinalSubmissionData , CouriersUnique, on = 'CourierNum' , how = 'left')
  
FinalSubmission=FinalSubmissionData.ix[:,['Courier_id' , 'Addr' , 'Arrival_time' , 'Departure' , 'Amount' , 'Order_id'] ]

print len(FinalSubmission['Order_id'].unique())
# print FinalSubmission
FinalSubmission.to_csv('Submission_test.csv' , index=False , header=False)
