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

siteData=pd.read_csv('./data/s2/siteData.csv')



X = siteData.loc[:,['Lng','Lat']].as_matrix()

from sklearn.cluster import KMeans
clf = KMeans(n_clusters=62)
clf.fit(X)

ecOrderData.loc[ecOrderData.Site_id==99,'kcenter']=clf.labels_[0:len(X1)]+1
o2oOrderData.loc[o2oOrderData.shop_class==99,'kcenter']=clf.labels_[len(X1):]+1





