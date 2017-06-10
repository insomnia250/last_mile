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

o2oData = pd.read_csv('data_format/s2/o2oOrderData_format_kcenter_part.csv')

partData3 = o2oData[(o2oData['shop_class']==116) & (o2oData['Parts']==3)]

a= (o2oData[(o2oData['shop_class']==116)]['start_time']/60).astype(int).value_counts()

(partData3['start_time']/60).astype(int).value_counts()


time_index = range(3,11)
# 
a= a.reindex(time_index)
a.plot(kind = 'bar')
plt.show()