#coding=utf-8
import numpy as np
import pandas as pd
from pandas import Series
from pandas import DataFrame
from pandas import merge
import csv
import os
from datetime import datetime
import pylab
import matplotlib.pyplot as plt

ecOrderData=pd.read_csv('./data/ecOrderData.csv')
o2oOrderData=pd.read_csv('./data/o2oOrderData.csv')

spotData=pd.read_csv('./data/spotData.csv')
siteData=pd.read_csv('./data/siteData.csv')
shopData=pd.read_csv('./data/shopData.csv')
##pd.to_datetime(o2oOrderData.Delivery_time)
maxNumSpot=merge(ecOrderData[ecOrderData.Site_id=='A099'], spotData, how='left',on='Spot_id')    #278个配送点
maxNumSite=siteData[siteData.Site_id=='A099']
maxNumSpot2=merge(ecOrderData[ecOrderData.Site_id=='A001'], spotData, how='left',on='Spot_id')    #278个配送点
maxNumSite2=siteData[siteData.Site_id=='A001']
maxNumSpot3=merge(ecOrderData[ecOrderData.Site_id=='A064'], spotData, how='left',on='Spot_id')    #278个配送点
maxNumSite3=siteData[siteData.Site_id=='A064']

plt.scatter(spotData.Lng,spotData.Lat,s=15)
plt.scatter(siteData.Lng,siteData.Lat,marker = u'o', color = 'r',s=15)

##for site in ecOrderData.Site_id.value_counts()[-55:].index:
##    print site
##    minNumSpot=merge(ecOrderData[ecOrderData.Site_id==site], spotData, how='left',on='Spot_id')
##    plt.scatter(minNumSpot.Lng,minNumSpot.Lat,color='c',s=15)

plt.scatter(shopData.Lng,shopData.Lat,color='c',s=15)


##targetShop=shopData[shopData.Shop_id=='S002']
##plt.scatter(targetShop.Lng,targetShop.Lat,color='g',s=50)

plt.scatter(maxNumSpot.Lng,maxNumSpot.Lat,color='y',s=15)
plt.scatter(maxNumSite.Lng,maxNumSite.Lat,marker = u'o', color = 'k',s=15)
##
##plt.scatter(maxNumSpot2.Lng,maxNumSpot2.Lat,color='c',s=15)
##plt.scatter(maxNumSite2.Lng,maxNumSite2.Lat,marker = u'o', color = 'k',s=15)
##
##plt.scatter(maxNumSpot3.Lng,maxNumSpot3.Lat,color='m',s=15)
##plt.scatter(maxNumSite3.Lng,maxNumSite3.Lat,marker = u'o', color = 'k',s=15)




plt.show()
