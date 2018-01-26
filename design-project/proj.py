import numpy as np
import matplotlib.pyplot as plt
from scipy.spatial import Voronoi

# Kaiser-Bessel window
M = 10
beta = 0.5
win = np.kaiser(M,beta)

# Now for the trajectory with equations (choose Lissajou)
a = 5
b = 7
delta = np.pi/2
t = np.linspace(-np.pi,np.pi,300)
x = np.sin(a*t + delta)
y = np.sin(b*t)

# Let's look at it just for fun
plt.figure()
plt.plot(x,y)
plt.show()

# We also need a way to sample it
xs = []
ys = []
Sj = zip(xs,ys)

# We also need a voronoi diagram!
opts = []
vor = Voronoi(Sj,opts)

# We'll also need to load in the Shepp-Loagan phantom
