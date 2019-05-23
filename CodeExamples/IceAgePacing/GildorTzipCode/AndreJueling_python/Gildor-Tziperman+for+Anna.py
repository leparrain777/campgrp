
# coding: utf-8

# In[1]:

import numpy as np
import scipy as sp
import scipy.integrate as integrate
#from scipy.integrate import odeint
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
get_ipython().magic(u'matplotlib inline')
get_ipython().magic(u'load_ext autoreload')
get_ipython().magic(u'autoreload 2')
get_ipython().magic(u'aimport -numpy')
get_ipython().magic(u'aimport -scipy')
get_ipython().magic(u'aimport -matplotlib')


# In[2]:

from solvers import ForwardEuler, RungeKutta4, EulerMaruyama


# I wrote my own solvers, but I since came to realize that it is probably smarter to use scipy's own solvers. I leave it like this for now, because it works, but it is not too much effort to use scipy.

# ## Gildor-Tzipermann ice age model

# In[3]:

from GT import GT_iceage


# In[4]:

spky = 3600*24*365*1000 # seconds per kiloyear
T    = 2000*spky
dt   = .01*spky
N    = int(T/dt+1)

#x0 = [1.67e17,270.]
x0 = [1e17,273.]  # initial conditions (V_0 and T_0)
gt = GT_iceage()  # gt is an object of the class
method = RungeKutta4(gt, dt)  # I use the RungeKutta4 solver
method.set_initial_condition(x0)  # setting the initial conditions
x, ts = method.solve(T)  # integration from 0 to T = 2 Ma with dt = 100 yr being the time step size
t = ts/spky-2000 # rescaling

f,ax = plt.subplots(3,1,figsize=(12,8),sharex=True)

ax[0].plot(t,x[:,1]-273, label='temperature', lw=2, c='r')
ax[0].plot(t,[gt.Tf(ts[i])-273 for i in range(N)],label='Tf', c='g')
ax[0].legend(ncol=2, loc=2,fontsize=16)
ax[0].set_ylabel('temp. [degC]',fontsize=16)

ax[1].plot(t,x[:,0]/1e9, label='land ice volume', lw=2)
ax[1].legend(loc=3,fontsize=16)
ax[1].set_ylabel('volume [km^3]',fontsize=16)

ax[2].plot(t,gt.ali(x[:,0])/gt.al, label='land ice area', lw=2)
ax[2].plot(t,[gt.asi(x[i,1],ts[i])/gt.ao for i in range(N)],            label='sea ice area', lw=2, c='c')
ax[2].legend(loc=3,ncol=2,fontsize=16)
ax[2].set_ylabel('fraction [1]',fontsize=16)

ax[2].set_xlabel('time [ky]',fontsize=16)
plt.tight_layout()
# plt.savefig('Figures/GT_iceage')


# In[5]:

Trange = np.arange(257,280,.2)
plt.plot(Trange-273,[gt.S(T,0)         for T in Trange],ls='-.',lw=2,label='S')
plt.plot(Trange-273,[gt.P(T,0)         for T in Trange],ls='-' ,lw=2,label='P init')
plt.plot(Trange-273,[gt.P(T,2000*spky) for T in Trange],ls='--',lw=2,label='P final')
plt.xlim((-16,5))
plt.xlabel('temperature [degC]')
plt.ylabel('acc./abl. [Sv]')
plt.legend(ncol=3,loc=2)
plt.tight_layout()
# plt.savefig('Figures/GT_acc_abl')


# In[6]:

plt.plot(x[:,0],x[:,1]-273,lw=2)  # all data
plt.plot(x[20000:50000,0],x[20000:50000,1]+1-273,c='g',ls=':',lw=2)  # initial
plt.plot(x[-20000:,0],x[-20000:,1]-1-273,c='r',ls='--',lw=2)  # last 20000 data points
plt.ylabel('temp. [degC]')
plt.xlabel('ice volume [km^3]')
plt.ylim((-15,7))
plt.xlim((.7e17,1.8e17))
plt.tight_layout()
# plt.savefig('Figures/GT_phase')

# The accumulation/abaltion rates are exactly twice as much as in the paper!
# The fraction of land ice is also too high.
# Also, the MPT happens too late!


# In[ ]:




# In[ ]:



