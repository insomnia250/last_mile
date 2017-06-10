#coding=utf-8
import numpy as np
import pandas as pd
from pandas import Series
from pandas import DataFrame
import csv
import os
from datetime import datetime

ecOrderData=pd.read_csv('./ecOrderMerged.csv')
o2oOrderData=pd.read_csv('./o2oOrderMerged.csv')

spotData=pd.read_csv('./data/spotData.csv')
siteData=pd.read_csv('./data/siteData.csv')
shopData=pd.read_csv('./shop_classified.csv')

AddrData1=ecOrderData.ix[:,['Order_id', 'Spot_id' , 'Site_id']]
AddrData2=o2oOrderData.ix[:,['Order_id', 'Spot_id' , 'Shop_id']]
AddrData1.columns=['Order_id', 'Target_spot' , 'Start_spot']
AddrData2.columns=['Order_id', 'Target_spot' , 'Start_spot']

AddrData=pd.concat([AddrData1,AddrData2])

ToatalSubmitData=DataFrame()

for i in range(1,125):
    FileName = '../km/record/Site'+str(i)+'.csv'
    ColumnNames=['Courier_id' , 'Addr' , 'Arrival_time' , 'Departure' , 'Amount' , 'Order_id'] 
    SubmitData=pd.read_csv(FileName , header=0,names=ColumnNames)
##    SubmitData=SubmitData.sort_values(by = ['Courier_id','Arrival_time','Departure'])


    '''规范格式----快递员编号D0001'''
    d1=(SubmitData.Courier_id/1000).astype(int)
    d2=((SubmitData.Courier_id-d1*1000)/100).astype(int)
    d3=((SubmitData.Courier_id-d1*1000-d2*100)/10).astype(int)
    d4=(SubmitData.Courier_id%10).astype(int)
    SubmitData.Courier_id='D' + d1.astype(str) + d2 .astype(str) + d3.astype(str) + d4.astype(str)

    '''规范格式----订单编号O2O E0001'''
    d1=((SubmitData.Order_id[SubmitData.Order_id > 9214]-9214)/1000).astype(int)
    d2=((SubmitData.Order_id[SubmitData.Order_id > 9214]-9214-d1*1000)/100).astype(int)
    d3=((SubmitData.Order_id[SubmitData.Order_id > 9214]-9214 - d1*1000-d2*100)/10).astype(int)
    d4=((SubmitData.Order_id[SubmitData.Order_id > 9214]-9214)%10).astype(int)
    SubmitData.Order_id[SubmitData.Order_id > 9214]='E' + d1.astype(str) + d2 .astype(str) + d3.astype(str) + d4.astype(str)

    '''规范格式----订单编号O2O F0001'''
    d1=(SubmitData.Order_id[SubmitData.Order_id <= 9214]/1000).astype(int)
    d2=((SubmitData.Order_id[SubmitData.Order_id <= 9214]-d1*1000)/100).astype(int)
    d3=((SubmitData.Order_id[SubmitData.Order_id <= 9214]-d1*1000-d2*100)/10).astype(int)
    d4=(SubmitData.Order_id[SubmitData.Order_id <= 9214]%10).astype(int)
    SubmitData.Order_id[SubmitData.Order_id <= 9214]='F' + d1.astype(str) + d2 .astype(str) + d3.astype(str) + d4.astype(str)

    ToatalSubmitData=pd.concat([ToatalSubmitData,SubmitData])

FinalSubmissionData=pd.merge(ToatalSubmitData , AddrData , how='left',on='Order_id') 
FinalSubmissionData.Addr[FinalSubmissionData.Amount>0]=FinalSubmissionData.Start_spot[FinalSubmissionData.Amount>0]
FinalSubmissionData.Addr[FinalSubmissionData.Amount<0]=FinalSubmissionData.Target_spot[FinalSubmissionData.Amount<0]



##    
FinalSubmission=FinalSubmissionData.ix[:,['Courier_id' , 'Addr' , 'Arrival_time' , 'Departure' , 'Amount' , 'Order_id'] ]
# FinalSubmission.to_csv('Submission.csv' , index=False , header=False)
