# -- coding: utf-8 --
"""
Created on Tue May 14 10:40:10 2024

@author: moham
"""



from scipy.fftpack import fft

import numpy as np
import matplotlib.pyplot as plt
import sounddevice as sd


𝑡 = np.linspace(0,3,12*1024)
x1=(np.sin(2*np.pi*130.81*t)+np.sin(2*np.pi*261.63*t))*np.where((np.logical_and(((t-0-0.3)<=0),(t-0>=0))),1,0)
x2=(np.sin(2*np.pi*146.83*t)+np.sin(2*np.pi*293.66*t))*np.where((np.logical_and(((t-0.5-0.3)<=0),(t-0.5>=0))),1,0)
x3=(np.sin(2*np.pi*164.81*t)+np.sin(2*np.pi*329.63))*np.where((np.logical_and(((t-1.0-0.3)<=0),(t-1.0>=0))),1,0)
x4= (np.sin(2*np.pi*174.61*t)+np.sin(2*np.pi*349.23*t))*np.where((np.logical_and(((t-1.5-0.3)<=0),(t-1.5>=0))),1,0)
x5= (np.sin(2*np.pi*196*t)+np.sin(2*np.pi*392*t))*np.where((np.logical_and(((t-2.0-0.3)<=0),(t-2.0>=0))),1,0)
x6= (np.sin(2*np.pi*220*t)+np.sin(2*np.pi*440*t))*np.where((np.logical_and(((t-2.4-0.3)<=0),(t-2.4>=0))),1,0)
x7= (np.sin(2*np.pi*246.93*t)+np.sin(2*np.pi*493.88*t))*np.where((np.logical_and(((t-2.8-0.3)<=0),(t-2.8>=0))),1,0)
x8= (np.sin(2*np.pi*174.61*t)+np.sin(2*np.pi*261.63*t))*np.where((np.logical_and(((t-3.2-0.3)<=0),(t-3.2>=0))),1,0)
x= x1+x2+x3+x4+x5+x6+x7+x8

plt.plot(t,x)
sd.play(x,3*1024)



𝑁 = 3*1024    #number of samples
𝑓 = np. linspace(0 , 512 , int(𝑁/2))  #axis range

xf = fft(x)   #freq domain
xf = 2/N * np.abs(xf [0:int(N/2)]) 
fn1=np.random.randint(0,512) #noise1
fn2 =np.random.randint(0,512) #noise2
n = np.sin(2*fn1*np.pi*t)+np.sin(2*fn2*np.pi*t) #adding two noises
xn =x+n 
xnf= fft(xn)
xnf = 2/N*np.abs(xnf [0:int(N/2)])

f=np.linspace(0,512,int(N/2))
maxx= np.max(xf)
j= 0
y=[0,0]
i=0
for i in range(0,np.size(f)):
    if(xnf[i]>maxx+1):
       if(j<len(y)):
           y[j]=i
           j+=1
    i+=1       
xfil = xn -(np.sin(2*np.round(f[y[0]])*np.pi*t)+np.sin(2*np.round(f[y[1]])*np.pi*t))
xfilf = fft(xfil)
xfilf = 2/N*np.abs(xfilf[0: int(N/2)])

plt.subplot(6,2,1)  #time
plt.title('Time Domain Signal')
plt.plot(t,x)    

plt.subplot(6,2,3) #time+noise
plt.plot(t,xn)

plt.subplot(6,2,5) #filtered
plt.plot(t,xfil)


plt.subplot(6,2,2) #freq
plt.title('Frequency Domain Signal')
plt.plot(f,xf)


plt.subplot(6,2,4) #freq+noise
plt.plot(f,xnf)

plt.subplot(6,2,6) #filtered
plt.plot(f,xfilf)

sd.play(xfil,4*1024)