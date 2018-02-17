import numpy as np
import matplotlib.pyplot as plt
from scipy.spatial import Voronoi, voronoi_plot_2d

def PolyArea(x,y):
    return(0.5*np.abs(np.dot(x,np.roll(y,1)) - np.dot(y,np.roll(x,1))))

# Kaiser-Bessel window
M = 10
beta = 0.5
win = np.kaiser(M,beta)

# Now for the trajectory with equations (choose Lissajou)
a = 5
b = 7
delta = np.pi/2
N = 75
t = np.linspace(-np.pi,np.pi,N)
x = np.sin(a*t + delta)
y = np.sin(b*t)

# Let's look at it just for fun
#plt.figure()
#plt.scatter(x,y)
#plt.plot(x,y,linewidth=0.5)
#plt.show()

Sj = zip(x,y)

# We also need a voronoi diagram!
opts = []
vor = Voronoi(Sj,opts)
voronoi_plot_2d(vor)
plt.show()

# calculate the areas for every voronoi region
areas = np.zeros((len(vor.regions),1))
for ii,reg in enumerate(vor.regions):
    verts = np.zeros((len(reg),2))
    for jj,vert_idx in enumerate(reg):
        verts[jj] = vor.vertices[vert_idx]
    areas[ii] = PolyArea(verts[:,0],verts[:,1])

# We'll also need to load in the Shepp-Loagan phantom
