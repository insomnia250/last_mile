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


'''---------------------计算 ecOrder 的夹角-----------------------------'''

ecOrderData = pd.read_csv('./data_format/s2/ecOrderData_format_kcenter.csv')
names1 = ecOrderData.columns.tolist()
names1[0]='Order_id'
ecOrderData.columns=names1

df1 = ecOrderData

SiteLoc = df1.filter(['Lng_site','Lat_site'])
SpotLoc = df1.filter(['Lng_spot','Lat_spot'])

relative_Loc1 = DataFrame(SpotLoc.as_matrix()-SiteLoc.as_matrix() , columns = ['Lng', 'Lat'])
relative_Loc1['Angle'] = np.arctan(relative_Loc1.Lat/relative_Loc1.Lng)
relative_Loc1['Degree'] = 0
#化成角度，取值范围[0 , 360]
relative_Loc1.loc[(relative_Loc1['Lng']>=0) & (relative_Loc1['Lat']>=0) , 'Degree'] = relative_Loc1['Angle']*180/np.pi
relative_Loc1.loc[(relative_Loc1['Lng']<0) & (relative_Loc1['Lat']>=0) , 'Degree'] = 180 + relative_Loc1['Angle']*180/np.pi
relative_Loc1.loc[(relative_Loc1['Lng']<0) & (relative_Loc1['Lat']<0) , 'Degree'] = 180 + relative_Loc1['Angle']*180/np.pi
relative_Loc1.loc[(relative_Loc1['Lng']>=0) & (relative_Loc1['Lat']<0) , 'Degree'] = 360 + relative_Loc1['Angle']*180/np.pi

df_ecOrder = pd.concat([df1 , relative_Loc1.Degree],axis=1)

#计算每单EC spot到网点的距离
site_ecspot_distance = np.sqrt((df_ecOrder['Lng_site'] - df_ecOrder['Lng_spot'])**2 + (df_ecOrder['Lat_site'] - df_ecOrder['Lat_spot'])**2)
site_ecspot_distance = pd.concat([df_ecOrder[['Order_id','Site_id']], site_ecspot_distance] ,axis=1)
site_ecspot_distance.columns = ['Order_id','Site_id' , 'distance']

#对每个网点 以spot到网点的最大距离作为 边界距离 ，以判断相应O2O是否超过边界
border_distance = site_ecspot_distance[['Site_id' , 'distance']].groupby('Site_id').max()



'''--------------------计算 o2oOrder 的夹角-------------------------------'''

o2oOrderData = pd.read_csv('./data_format/s2/o2oOrderData_format_kcenter.csv')
names2 = o2oOrderData.columns.tolist()
names2[0]='Order_id'
o2oOrderData.columns=names2

df2 = pd.merge(o2oOrderData, df1.loc[:,['Site_id','Lng_site','Lat_site']].drop_duplicates(), how='left' ,left_on='shop_class', right_on='Site_id')


SiteLoc = df2.filter(['Lng_site','Lat_site'])
SpotLoc = df2.filter(['Lng_spot','Lat_spot'])

relative_Loc2 = DataFrame(SpotLoc.as_matrix()-SiteLoc.as_matrix() , columns = ['Lng', 'Lat'])
relative_Loc2['Angle'] = np.arctan(relative_Loc2.Lat/relative_Loc2.Lng)
relative_Loc2['Degree'] = 0
#化成角度，取值范围[0 , 360]
relative_Loc2.loc[(relative_Loc2['Lng']>=0) & (relative_Loc2['Lat']>=0) , 'Degree'] = relative_Loc2['Angle']*180/np.pi
relative_Loc2.loc[(relative_Loc2['Lng']<0) & (relative_Loc2['Lat']>=0) , 'Degree'] = 180 + relative_Loc2['Angle']*180/np.pi
relative_Loc2.loc[(relative_Loc2['Lng']<0) & (relative_Loc2['Lat']<0) , 'Degree'] = 180 + relative_Loc2['Angle']*180/np.pi
relative_Loc2.loc[(relative_Loc2['Lng']>=0) & (relative_Loc2['Lat']<0) , 'Degree'] = 360 + relative_Loc2['Angle']*180/np.pi

df_o2oOrder = pd.concat([df2 , relative_Loc2.Degree],axis=1)

#计算每单O2O spot到网点的距离
site_o2ospot_distance = np.sqrt((df_o2oOrder['Lng_site'] - df_o2oOrder['Lng_spot'])**2 + (df_o2oOrder['Lat_site'] - df_o2oOrder['Lat_spot'])**2)
site_o2ospot_distance = pd.concat([df_o2oOrder[['Order_id','Site_id','Degree']], site_o2ospot_distance] ,axis=1)
site_o2ospot_distance.columns = ['Order_id','Site_id','Degree','distance']

site_o2ospot_distance = pd.merge(site_o2ospot_distance, border_distance ,left_on='Site_id', right_index=True, how='left')
site_o2ospot_distance.columns= ['Order_id','Site_id','Degree','distance','border_distance']

'''-----------------------------以 30° 角划分部分--------------------------------------'''
from sklearn.utils import shuffle
from sklearn.cross_validation import KFold


site_o2ospot_distance.Degree = site_o2ospot_distance.Degree.astype(int)
site_o2ospot_distance['Parts'] = 0

ecOrderData['Parts'] = 0

for SiteId in range(1,125):
	SiteO2O_OrderLoc =(site_o2ospot_distance['Site_id']==SiteId) & (site_o2ospot_distance['distance'] > 1.5*site_o2ospot_distance['border_distance'])
	degree1 = 0
	degree2 = 4
	part = 0
	while degree2 < 359:
		Part_OrderLoc = (site_o2ospot_distance['Degree'] >= degree1) & (site_o2ospot_distance['Degree']<= degree2) & SiteO2O_OrderLoc
		if len( site_o2ospot_distance[Part_OrderLoc] ) == 0:
			degree1 += 5
			degree2 += 5
		else:
			part += 1
			degree1 = site_o2ospot_distance[Part_OrderLoc]['Degree'].min()
			degree2 = degree1 + 1

			'''----选中30° 范围的订单，划分部分-------'''
			Part_OrderLoc = (site_o2ospot_distance['Degree'] >= degree1) & (site_o2ospot_distance['Degree'] <= degree2) & SiteO2O_OrderLoc
			site_o2ospot_distance.loc[Part_OrderLoc , 'Parts'] = part

			
			degree1 += 5
			degree2 += 5

	if part <= 1:
		ecOrderData.loc[ecOrderData['Site_id'] == SiteId , 'Parts'] = 1

		rest_o2oData_Loc = (site_o2ospot_distance['Site_id'] == SiteId) & (site_o2ospot_distance['Parts']== 0 )
		site_o2ospot_distance.loc[rest_o2oData_Loc, 'Parts'] = 1
	else:
		'''--------------------------随机划分 电商订单部分---------------------------------------'''
		
		ecDataIndex = ecOrderData[ecOrderData['Site_id'] == SiteId].index
		
		shuffled_Index = Series(shuffle(range(0,len(ecDataIndex))))
		
		kf = KFold(len(shuffled_Index), n_folds= part )

		ecPart = 1
		for rest_part, frac_part in kf:
			# if ecPart == 1:
				# print ecDataIndex[shuffled_Index[frac_part]]
			ecOrderData.loc[ecDataIndex[shuffled_Index[frac_part]] , 'Parts'] = ecPart
			ecPart +=1

		'''-------------------------随机划分 限定边界内的O2O订单部分--------------------------'''
		rest_o2oData_Loc = (site_o2ospot_distance['Site_id'] == SiteId) & (site_o2ospot_distance['Parts']== 0 )
		
		if (len(rest_o2oData_Loc) > 0) & (len(site_o2ospot_distance[rest_o2oData_Loc]) > part) :
			o2oDataIndex = site_o2ospot_distance[rest_o2oData_Loc].index
			shuffled_Index = Series(shuffle(range(0,len(o2oDataIndex))))
			
			kf = KFold(len(shuffled_Index), n_folds= part )
			
			o2oPart = 1
			for rest_part, frac_part in kf:
				site_o2ospot_distance.loc[o2oDataIndex[shuffled_Index[frac_part]] , 'Parts'] = o2oPart
				o2oPart +=1
		else:
			site_o2ospot_distance.loc[ rest_o2oData_Loc, 'Parts'] = 1


'''---------------------生成文件-------------------------------'''
new_o2oOrderData = pd.merge(o2oOrderData, site_o2ospot_distance[['Order_id' , 'Parts']], how='left' ,on= 'Order_id')
# print new_o2oOrderData.Parts.max()

# print ecOrderData[ecOrderData['Site_id'] == 116]['Parts'].value_counts()
# print new_o2oOrderData[new_o2oOrderData['shop_class'] == 116]['Parts'].value_counts()

# print ecOrderData[(ecOrderData['Site_id'] == 116) & (ecOrderData['Parts'] == 4)]

# print new_o2oOrderData[new_o2oOrderData['shop_class']==65].Parts.value_counts()
# print new_o2oOrderData[new_o2oOrderData['shop_class']==72].Parts.value_counts()
# print new_o2oOrderData[new_o2oOrderData['shop_class']==93].Parts.value_counts()
# print new_o2oOrderData[new_o2oOrderData['shop_class']==94].Parts.value_counts()
# print new_o2oOrderData[new_o2oOrderData['shop_class']==99].Parts.value_counts()
# print new_o2oOrderData[new_o2oOrderData['shop_class']==116].Parts.value_counts()

# print ecOrderData[(ecOrderData['Site_id']==116) & (ecOrderData['Parts']==4)]
# print site_o2ospot_distance[(site_o2ospot_distance['Site_id']==116) & (site_o2ospot_distance['Parts']==4)]

# print site_o2ospot_distance[(site_o2ospot_distance['Parts']>1)]['Site_id'].unique()
# print site_o2ospot_distance[(site_o2ospot_distance['Parts']>1)]['Site_id'].value_counts()
print ecOrderData['Parts'].value_counts()
print new_o2oOrderData['Parts'].value_counts()

ecOrderData.to_csv('./data_format/s2/ecOrderData_format_kcenter_part.csv',index =False)
new_o2oOrderData.to_csv('./data_format/s2/o2oOrderData_format_kcenter_part.csv',index =False)

