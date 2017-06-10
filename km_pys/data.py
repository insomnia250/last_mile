#coding=utf-8
import numpy as np
import pandas as pd
from pandas import Series
from pandas import DataFrame
import csv
import os


#网点数据
siteFile=open('./data/s2/siteData.csv','ab')
writer=csv.writer(siteFile)
for line in open('./rawData/s2/siteData.csv','rU'):
    linedata=line.strip().strip('\"').split(',')
    writer.writerow(linedata)
siteFile.close()
#配送点
spotFile=open('./data/s2/spotData.csv','ab')
writer=csv.writer(spotFile)
for line in open('./rawData/s2/spotData.csv','rU'):
    linedata=line.strip().strip('\"').split(',')
    writer.writerow(linedata)
spotFile.close()
#商店
shopFile=open('./data/s2/shopData.csv','ab')
writer=csv.writer(shopFile)
for line in open('./rawData/s2/shopData.csv','rU'):
    linedata=line.strip().strip('\"').split(',')
    writer.writerow(linedata)
shopFile.close()
#电商订单
ecOrderFile=open('./data/s2/ecOrderData.csv','ab')
writer=csv.writer(ecOrderFile)
for line in open('./rawData/s2/ecOrderData.csv','rU'):
    linedata=line.strip().strip('\"').split(',')
    writer.writerow(linedata)
ecOrderFile.close()
#o2o订单
o2oOrderFile=open('./data/s2/o2oOrderData.csv','ab')
writer=csv.writer(o2oOrderFile)
for line in open('./rawData/s2/o2oOrderData.csv','rU'):
    linedata=line.strip().strip('\"').split(',')
    writer.writerow(linedata)
o2oOrderFile.close()
#快递
courierFile=open('./data/s2/courierData.csv','ab')
writer=csv.writer(courierFile)
for line in open('./rawData/s2/courierData.csv','rU'):
    linedata=line.strip().strip('\"').split(',')
    writer.writerow(linedata)
courierFile.close()
