#coding=utf-8
'''-----------按照电商spot位置作为训练集采用KNN把O2O划分到电商起点，以shop位置为特征------------'''
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


ecOrderData=pd.read_csv('./data_merged/s2/ecOrderMerged.csv')
o2oOrderData=pd.read_csv('./data_merged/s2/o2oOrderMerged.csv')

spotData=pd.read_csv('./data/s2/spotData.csv')
siteData=pd.read_csv('./data/s2/siteData.csv')
shopData=pd.read_csv('./data/s2/shopData.csv')

ecOrderData['spot_class']=0
for i in ecOrderData.index:
    ecOrderData['spot_class'].ix[i]=int(ecOrderData['Site_id'].ix[i][-3:])

X_spot=DataFrame([ecOrderData.Lng_spot,ecOrderData.Lat_spot]).T
Y_spot=ecOrderData.spot_class
X_shop=DataFrame([shopData.Lng,shopData.Lat]).T



clf = neighbors.KNeighborsClassifier(algorithm='kd_tree')  
clf.fit(X_spot, Y_spot)
shop_class=Series(clf.predict(X_shop))

shopData['shop_class']=shop_class
shopData.to_csv('./data_merged/s2/shop_classified.csv',index=False)
