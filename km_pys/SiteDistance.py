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
from numpy import sqrt,sin,cos,arcsin

# def CalculateDistance(Lng1 , Lat1 , Lng2 , Lat2):
# 	dlat=(Lat1-Lat2)/2.0
# 	dlng=(Lng1-Lng2)/2.0
# 	temp1 = sqrt(\
# 				( sin (np.pi/180*dlat))**2\
# 				+ cos(np.pi/180*Lat1)*cos(np.pi/180*Lat2)\
# 				*(sin(np.pi/180*dlng))**2)
# 	distance = 2*6378137*arcsin(temp1)
# 	return distance
# SiteData = pd.read_csv('./data/s2/siteData.csv')

# Lng1 = SiteData[SiteData['Site_id'] == 'A001']['Lng'].values[0]
# Lat1 = SiteData[SiteData['Site_id'] == 'A001']['Lat'].values[0]

# distance =  CalculateDistance(SiteData.Lng, SiteData.Lat,Lng1, Lat1)
# SiteData['distance'] = distance
# print SiteData.sort_values(by = 'distance')
siteData = pd.read_csv('./data/s2/siteData.csv')
siteData.sort_values(by = 'Site_id' , inplace=True)
siteData['Site_id'] = siteData['Site_id'].str[-3:].astype(int)
siteData.to_csv('../km/data/s2/SiteData.csv' , index = False)