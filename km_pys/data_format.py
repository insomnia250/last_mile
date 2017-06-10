#coding=utf-8
import numpy as np
import pandas as pd
from pandas import Series
from pandas import DataFrame
import csv
import os
from datetime import datetime

ecOrderData=pd.read_csv('./data_merged/s2/ecOrderMerged.csv')
o2oOrderData=pd.read_csv('./data_merged/s2/o2oOrderMerged2.csv')

spotData=pd.read_csv('./data/s2/spotData.csv')
siteData=pd.read_csv('./data/s2/siteData.csv')
shopData=pd.read_csv('./data_merged/s2/shop_classified.csv')

'''---------------------ec----------------------'''
# ecOrderData_format=ecOrderData.ix[:,['Site_id','Lng_site','Lat_site','Lng_spot','Lat_spot','Num']]
# for i in ecOrderData_format.index:
#     ecOrderData_format['Site_id'].ix[i]=int(ecOrderData_format['Site_id'].ix[i][-3:])
# ecOrderData_format.index=ecOrderData_format.index+1
''' -------------------O2O---------'''

o2oOrderData_format=o2oOrderData.ix[:,['Shop_id','shop_class','Lng_shop','Lat_shop','Lng_spot','Lat_spot','Num','start_time','end_time','spot_class']]
for i in o2oOrderData_format.index:
    o2oOrderData_format['Shop_id'].ix[i]=int(o2oOrderData_format['Shop_id'].ix[i][-3:])

o2oOrderData_format.index = o2oOrderData_format.index + 1

# ecOrderData_format.to_csv('./data_format/s2/ecOrderData_format.csv')
o2oOrderData_format.to_csv('./data_format/s2/o2oOrderData_format2.csv')

