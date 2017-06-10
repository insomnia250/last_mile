#coding=utf-8
import numpy as np
import pandas as pd
from pandas import Series
from pandas import DataFrame
import csv
import os


#网点数据
siteFile=open('./data/siteData.csv','ab')
writer=csv.writer(siteFile)
for line in open('./rawData/siteData.csv','rU'):
    linedata=line.strip().strip('\"').split(',')
    writer.writerow(linedata)
siteFile.close()
#配送点
spotFile=open('./data/spotData.csv','ab')
writer=csv.writer(spotFile)
for line in open('./rawData/spotData.csv','rU'):
    linedata=line.strip().strip('\"').split(',')
    writer.writerow(linedata)
spotFile.close()
#商店
shopFile=open('./data/shopData.csv','ab')
writer=csv.writer(shopFile)
for line in open('./rawData/shopData.csv','rU'):
    linedata=line.strip().strip('\"').split(',')
    writer.writerow(linedata)
shopFile.close()
#电商订单
ecOrderFile=open('./data/ecOrderData.csv','ab')
writer=csv.writer(ecOrderFile)
for line in open('./rawData/ecOrderData.csv','rU'):
    linedata=line.strip().strip('\"').split(',')
    writer.writerow(linedata)
ecOrderFile.close()
#o2o订单
o2oOrderFile=open('./data/o2oOrderData.csv','ab')
writer=csv.writer(o2oOrderFile)
for line in open('./rawData/o2oOrderData.csv','rU'):
    linedata=line.strip().strip('\"').split(',')
    writer.writerow(linedata)
o2oOrderFile.close()
#快递
courierFile=open('./data/courierData.csv','ab')
writer=csv.writer(courierFile)
for line in open('./rawData/courierData.csv','rU'):
    linedata=line.strip().strip('\"').split(',')
    writer.writerow(linedata)
courierFile.close()
