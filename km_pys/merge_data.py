#coding=utf-8
'''---------订单数据中 商店和配送点的位置添加--------'''
import numpy as np
import pandas as pd
from pandas import Series
from pandas import DataFrame

import csv
import os
from datetime import datetime
import pylab
import matplotlib.pyplot as plt

ecOrderData=pd.read_csv('./data/s2/ecOrderData.csv')
o2oOrderData=pd.read_csv('./data/s2/o2oOrderData.csv')

spotData=pd.read_csv('./data/s2/spotData.csv')
siteData=pd.read_csv('./data/s2/siteData.csv')
shopData=pd.read_csv('./data/s2/shopData.csv')

ecOrderMerged1=pd.merge(ecOrderData, siteData, how='left',on='Site_id')    
ecOrderMerged=pd.merge(ecOrderMerged1,spotData,how='left',on='Spot_id',suffixes=('_site','_spot'))

o2oOrderMerged1=pd.merge(o2oOrderData, shopData, how='left',on='Shop_id')    
o2oOrderMerged=pd.merge(o2oOrderMerged1,spotData,how='left',on='Spot_id',suffixes=('_shop','_spot'))



o2oOrderMerged.Pickup_time=pd.to_datetime(o2oOrderMerged.Pickup_time)-datetime(2016,8,11,8)
o2oOrderMerged.Delivery_time=pd.to_datetime(o2oOrderMerged.Delivery_time)-datetime(2016,8,11,8)
o2oOrderMerged['start_time']=0
o2oOrderMerged['end_time']=0

for i in o2oOrderMerged.index:
    print i
    o2oOrderMerged.start_time.ix[i]=o2oOrderMerged.ix[i].Pickup_time.total_seconds()/60
    o2oOrderMerged.end_time.ix[i]=o2oOrderMerged.ix[i].Delivery_time.total_seconds()/60

ecOrderMerged.to_csv('./data_merged/s2/ecOrderMerged.csv',index=False)
o2oOrderMerged.to_csv('./data_merged/s2/o2oOrderMerged.csv',index=False)

