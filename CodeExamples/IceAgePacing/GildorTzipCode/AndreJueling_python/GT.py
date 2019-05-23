import numpy as np

class GT_iceage:
    """
    Gildor-Tziperman (2003) ice age model
    dimensional:
    time   t in [s]
    volume V in [m^3]
    temp   T in [K]
    state vector [V,T]
	\dot{V} & = P(T,a) - S(T,t)\\
    \dot{T} & = \left[ - \varepsilon \sigma T^4 + H_s  \
       \left( 1 - \alpha_s\frac{a_{si}}{a} - \alpha_L\frac{a_{li}}{a} \right) \
       \left(1-\alpha_C\right) \right] \frac{a_o}{C_o}
    where $M(t)$ is the time-dependent forcing (normalized 
    {zero mean and unit variance} July insolation at $\unit[60]{^\circ N}$)
    run time 2Ma to present
    """
    qr  = 0.7       # [1]
    eq  = 0.622     # [1]
    A   = 2.53e11   # [Pa]
    B   = 5.42e3    # [K]
    Ps  = 1.0e5     # [Pa] 
    P0  = 0.06      # [Sv]
    P1  = 40.       # [Sv Pa^-1]
    S0  = 0.15      # [Sv]
    SM  = 0.08      # [Sv]
    ST  = 0.0015    # [Sv K^-1]
    eps = 0.64      # [1]
    sgm = 5.67e-8   # [W m^-2 K^-4]
    Hs  = 350.      # [W m^-2]
    als = 0.65      # [1]
    alL = 0.7       # [1]
    alC = 0.27      # [1]
    rho = 1.0e3     # [kg m^-3]
    Vo  = 21.6e15   # [m^3]
    Cp  = 3985.     # [J kg^-1 K^-1] 
    ao  = 2.0e13    # [m^2]
    al  = 2.0e13    # [m^2]
    a   = ao + al   # [m^2]
    lmd = 10.       # [m]
    LEW = 4.0e6     # [m]
    
    Is  = 0.3*ao              # [m^2]
    Co  = Cp*Vo*rho # [j K^-1]

    spky = 3600*24*365*1000 # seconds per kiloyear
    def __init__(self):
        #self.u = u  # parameter u
        print 'initialized'
    def M(self,t): # Milankovich
        #return np.sin((t/self.spky)/100.*2.*np.pi) + \
        return np.sin((t/self.spky)/40.*2.*np.pi)/np.sqrt(2.)
    def Tf(self,t): # deep ocean temperature
        #return 273.-8.+5.*np.tanh((t/self.spky-1000.)/400.)
        if t<500*self.spky: return 260.
        elif t>1500*self.spky: return 270.
        else: return 260. + 10.*(t-500*self.spky)/1000/self.spky
    def asi(self,T,t): # sea ice area
        if T<self.Tf(t): return self.Is
        else: return 0.
    def ali(self,V): # land ice area
        return self.LEW**(1./3)*(V/2./self.lmd**(1./2))**(2./3)
    def P(self,T,t): # precipitation
        qT = self.qr * self.eq * self.A * np.exp(-self.B/T) / self.Ps
        return (self.P0 + self.P1*qT) * (1 - self.asi(T,t)/self.ao)
    def S(self,T,t): # ablation
        return self.S0 + self.SM*self.M(t) + self.ST*(T-273.)
    def __call__(self, x, t):
        # state vector x = [V,T]
        a_si = self.asi(x[1], t)
        a_li = self.ali(x[0])
        Vdot = ( self.P(x[1],t) - self.S(x[1],t) )*1e6
        Tdot = self.ao/self.Co*(-self.eps*self.sgm*x[1]**4 + \
                self.Hs*(1. - self.als*a_si/self.a - self.alL*a_li/self.a)*\
                (1 - self.alC))
        return [Vdot, Tdot]
        
        
        
        
        
        
