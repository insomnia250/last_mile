#coding=utf-8
import numpy as np
import pandas as pd
from pandas import Series
from pandas import DataFrame
import csv
import os
from datetime import datetime
import pylab
import matplotlib.pyplot as plt
from sklearn import neighbors

##  


ecOrderData=pd.read_csv('./data_format/s2/ecOrderData_format.csv')
o2oOrderData=pd.read_csv('./data_format/s2/o2oOrderData_format2.csv')

spotData=pd.read_csv('./data/s2/spotData.csv')
siteData=pd.read_csv('./data/s2/siteData.csv')
shopData=pd.read_csv('./data/s2/shopData.csv')

ecOrderData.loc[:,'kcenter']=1
o2oOrderData.loc[:,'kcenter']=1

'''-----99号网点的ECspot和O2Oshop聚类为两部分------'''
##ecData_Site_99=ecOrderData[ecOrderData.Site_id==99]
##o2oData_Site_99=o2oOrderData[o2oOrderData.shop_class==99]
##
##X1=ecData_Site_99.ix[:,['Lng_spot' , 'Lat_spot']]
##X2=o2oData_Site_99.ix[:,['Lng_shop' , 'Lat_shop']]
##X1.columns=['Lng' , 'Lat']
##X2.columns=['Lng' , 'Lat']
##X=pd.concat([X1,X2],ignore_index=True)
##from sklearn.cluster import KMeans
##clf = KMeans(n_clusters=2)
##clf.fit(X)
##
##ecOrderData.loc[ecOrderData.Site_id==99,'kcenter']=clf.labels_[0:len(X1)]+1
##o2oOrderData.loc[o2oOrderData.shop_class==99,'kcenter']=clf.labels_[len(X1):]+1


# ecOrderData.to_csv('./data_format/s2/ecOrderData_format_kcenter.csv',index=False)

o2oOrderData.drop(['spot_class'],axis = 1 , inplace = True)
o2oOrderData.to_csv('./data_format/s2/o2oOrderData_format_kcenter2.csv'  ,index=False)
