import numpy as np
from time import *

class Solver:
    """Solver Superclass"""
    def __init__(self, f, dt, sigma=0):
#         self.f = f
        self.f  = lambda x, t: np.asarray(f(x, t), float)
        self.dt = dt
    def set_initial_condition(self, x0, t0=0):
        self.x = [] # x[k] is solution/state array at time t[k]
        self.t = [] # time levels in the solution process
        self.x.append(x0)
        self.t.append(t0)
        self.k = 0 # time level counter
    def set_sigma(self, sigma=0):
        self.sigma = sigma
        if sigma.size!=len(self.x[0]):
            print 'Error: sigma needs to be an array of the same dimension as x'+\
                  ', including possible slowly varying parameter.'
    def solve(self, T):
        t = 0
        start = clock()
        while t < T:
            xnew = self.advance() # the numerical formula
            self.x.append(xnew)
            t = self.t[-1] + self.dt
            self.t.append(t)
            self.k += 1
        #print 'done in %.3f seconds!' % (clock()-start)
        return np.array(self.x), np.array(self.t)
    def advance(self):
        raise NotImplementedError

"""Solving algorithms subclasses"""
class ForwardEuler(Solver):
    def advance(self):
        x, dt, f, k, t = self.x, self.dt, self.f, self.k, self.t[-1]
        xnew = x[k] + f(x[k], t)*dt
        return xnew

class EulerMaruyama(Solver):
    def advance(self):
        x, dt, f, k, t = self.x, self.dt, self.f, self.k, self.t[-1]
        sigma = self.sigma
        xnew = x[k] + f(x[k], t)*dt + sigma*self.dW(dt)
        return xnew
    def dW(self, delta_t): 
        """Sample a random number at each call."""
        return np.random.normal(loc = 0.0, scale = np.sqrt(delta_t))
    
class RungeKutta4(Solver):
    def advance(self):
        x, dt, f, k, t = self.x, self.dt, self.f, self.k, self.t[-1]
        dt2 = dt/2.0
        K1 = dt*f(x[k], t)
        K2 = dt*f(x[k] + 0.5*K1, t + dt2)
        K3 = dt*f(x[k] + 0.5*K2, t + dt2)
        K4 = dt*f(x[k] + K3, t + dt)
        xnew = x[k] + (1/6.0)*(K1 + 2*K2 + 2*K3 + K4)
        return xnew