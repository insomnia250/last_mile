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

ColumnNames=['Courier_id' , 'Addr' , 'Arrival_time' , 'Departure' , 'Amount' , 'Order_id']
submission=pd.read_csv('./Submission.csv',header=None,names=ColumnNames)

bug1=0
CourierList=submission.Courier_id.unique()
for Courier in CourierList:
##    print Courier
    CourierData=submission[submission.Courier_id==Courier]
    if CourierData.Amount.cumsum().max()>140:
        bug1+=1
        print Courier
    a1=np.array(CourierData.Arrival_time[1 : ])
    b1=np.array(CourierData.Departure[0 : -1])
    p=min(a1-b1)
    if p<0:
        print p,Courier

##OrderList=submission.Order_id.unique()
##for Order in OrderList:
##    OrderData=submission[submission.Order_id==Order]
##    aa=OrderData[OrderData.Amount>0].Departure.values[-1]
##    bb=OrderData[OrderData.Amount<0].Arrival_time.values[-1]
##    if aa-bb>0:
##        print Order
