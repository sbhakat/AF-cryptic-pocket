import pandas as pd
import numpy as np

#reading file in array
cvfile=pd.read_csv("edt_COLVAR", sep=" ",skipinitialspace=True)
numrow=cvfile.shape[0]
n=0
for i in range(0,numrow):
         #if (cvfile['c2_35'][i]< -0.09 and cvfile['c2_35'][i] > -1.90 and cvfile['c1_35'][i] > 0) or (cvfile['c2_35'][i]< 2.30 and cvfile['c2_35'][i] > 0.7 and cvfile['c1_35'][i] > -1.70  and cvfile['c1_35'][i] < -0.33) or (cvfile['c2_35'][i]< -0.85 and cvfile['c2_35'][i] > -2.77 and cvfile['c1_35'][i] < 0):
         if (cvfile['t4'][i] < -1.1 and cvfile['t3'][i] > 0.5 and cvfile['t3'][i] < 1.8):
                  n=n+1
                  if n == 2:
                      break
                  print('{0:0f} {1:3f} {2:4f} {3:4f} {4:4f}'.format(cvfile['time'][i],cvfile['t3'][i],cvfile['t4'][i],cvfile['metad.bias'][i],cvfile['metad.acc'][i]))
                  trans_time=np.prod(cvfile['time'][i]*cvfile['metad.acc'][i]*10**-12) #converting ps to sec
                  rate=1/trans_time
                     #print('transition time (ns):{0:0f}'.format(trans_time) , 'rate (ns-1):{0:0f}'.format(rate))
                 
                  print('{0:0E}'.format(trans_time))
                 
                  print('{0:0f} sec-1'.format(rate))
#print('transition time (ns):{0:0e}'.format(trans_time) , 'rate (ns-1):{0:0e}'.format(rate))

#print("trans_time")
