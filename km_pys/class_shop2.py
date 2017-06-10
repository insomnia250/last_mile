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

o2o_shop_loc = DataFrame([o2oOrderData.Lng_shop ,o2oOrderData.Lat_shop]).T
o2o_spot_loc = DataFrame([o2oOrderData.Lng_spot ,o2oOrderData.Lat_spot]).T


clf = neighbors.KNeighborsClassifier(algorithm='kd_tree')  
clf.fit(X_spot, Y_spot)
o2o_shop_class=Series(clf.predict(o2o_shop_loc))
o2o_spot_class=Series(clf.predict(o2o_spot_loc))

o2oOrderData['shop_class']=o2o_shop_class##
o2oOrderData['spot_class']=o2o_spot_class##
o2oOrderData.to_csv('./data_format/s2/o2oOrderMerged2.csv',index=False)
