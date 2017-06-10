#coding=utf-8
import numpy as np
import pandas as pd
from pandas import Series
from pandas import DataFrame
import csv
import os
from datetime import datetime
import re

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

'''-------------------读取matlab 2点融合解决方案------------------------------------'''
FilePath = '../km/mergeSite/record/'
FileList = os.listdir(FilePath)
MergedRecord = set()

ColumnNames = ['CourierNum' , 'Addr' , 'Arrival_time' , 'Departure' , 'Amount' , 'Order_id_num'] 
for file in FileList:
	recordNum1 = re.findall(r'[0-9]+', file)[0]
	recordNum2 = re.findall(r'[0-9]+', file)[1]
	SubmitData = pd.read_csv(FilePath+file , header = 0 , names = ColumnNames)
	# if SubmitData['CourierNum'].min() == 1:
	# 	print file
	SubmitData['CourierNum'] = SubmitData['CourierNum'] + int(recordNum1)*10000
	
	ToatalSubmitData=pd.concat([ToatalSubmitData,SubmitData])
	MergedRecord.add(recordNum1)
	MergedRecord.add(recordNum2)

print len(ToatalSubmitData['CourierNum'].unique())
print ToatalSubmitData['CourierNum'].max()

for i in range(1,136):
	if not str(i) in MergedRecord:
		FileName='../km/record_recordNum/recordNum'+str(i)+'.csv'
		SubmitData=pd.read_csv(FileName , header=0,names=ColumnNames)
		SubmitData['CourierNum'] = SubmitData['CourierNum'] + i*10000
		ToatalSubmitData=pd.concat([ToatalSubmitData,SubmitData])

# print ToatalSubmitData
print len(ToatalSubmitData['CourierNum'].unique())
print len(ToatalSubmitData['Order_id_num'].unique())



FinalSubmissionData=pd.merge(ToatalSubmitData , AddrData , how='left',on='Order_id_num') 

FinalSubmissionData.Addr[FinalSubmissionData.Amount>0]=FinalSubmissionData.Start_spot[FinalSubmissionData.Amount>0]
FinalSubmissionData.Addr[FinalSubmissionData.Amount<0]=FinalSubmissionData.Target_spot[FinalSubmissionData.Amount<0]

CouriersUnique = DataFrame({'CourierNum':FinalSubmissionData.CourierNum.unique()})
CouriersUnique['Courier_id'] = CouriersUnique.index + 1
CouriersUnique['Courier_id'] = 'D' + CouriersUnique['Courier_id'].astype(str).str.zfill(4)


FinalSubmissionData = pd.merge(FinalSubmissionData , CouriersUnique, on = 'CourierNum' , how = 'left')
  
FinalSubmission=FinalSubmissionData.ix[:,['Courier_id' , 'Addr' , 'Arrival_time' , 'Departure' , 'Amount' , 'Order_id'] ]
# print FinalSubmission
FinalSubmission.to_csv('Submission_s2_9.csv' , index=False , header=False)
print len(FinalSubmission['Order_id'].unique())
print FinalSubmission[FinalSubmission['Order_id'] == 'E4821']
