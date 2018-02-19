import numpy as np
import matplotlib.pyplot as plt
from scipy.spatial import Voronoi, voronoi_plot_2d
from scipy.sparse import coo_matrix
import imageio

def PolyArea(x,y):
    return(0.5*np.abs(np.dot(x,np.roll(y,1)) - np.dot(y,np.roll(x,1))))

def grid1(d,k,n):
    # d -- k-space data
    # k -- k-trajectory, scaled -0.5 to 0.5
    # n -- image size
    
    # Convert k-space samples to matrix indices
    nx = (n/2+1) + n*np.real(k)
    ny = (n/2+1) + n*np.imag(k)

    # output array m
    m = np.zeros((n,n),dtype=complex)

    for lx in range(-1,2):
        for ly in range(-1,2):

            # find nearest samples
            nxt = np.round(nx + lx)
            nyt = np.round(ny + ly)
            
            # compute weighting for triangular kernel
            kwx = np.maximum(1 - np.absolute(nx - nxt),np.zeros(nx.shape))
            kwy = np.maximum(1 - np.absolute(ny - nyt),np.zeros(ny.shape))


            # map samples outside the matrix to the edges
            nxt = np.maximum(nxt,np.ones(nxt.shape))
            nxt = np.minimum(nxt,n*np.ones(nxt.shape))

            nyt = np.maximum(nyt,np.ones(nyt.shape))
            nyt = np.minimum(nyt,n*np.ones(nyt.shape))

            # use sparse matrix to turn k-space trajectory into 2D matrix
            #m = m + np.array(nxt,nyt,d.*kwx.*kwy.*w,n,n)
            #m = m + coo_matrix((np.multiply(np.multiply(d,kwx),kwy), (nxt-1, nyt-1)), shape=(n,n))

            tmp = np.zeros((n,n),dtype=complex)
            tmp[np.array(nxt,dtype=np.uint16) - 1,np.array(nyt,dtype=np.uint16) - 1] = np.multiply(np.multiply(d,kwx),kwy)
            m = m + tmp

    # zero out edge samples, since these may be due to samples outside
    # the matrix
    m[:,0] = 0
    m[:,n-1] = 0
    m[0,:] = 0
    m[n-1,:] = 0

    return(m)

# Kaiser-Bessel window
#M = 10
#beta = 0.5
#win = np.kaiser(M,beta)

# Now for the trajectory with equations (choose Lissajou)
#a = 3
#b = 7
#delta = np.pi
N = 145**2
#t = np.linspace(-np.pi,np.pi,N)
#x = np.sin(a*t + delta)
#y = np.sin(b*t)

# testing x,y
x = np.linspace(-1,1,np.sqrt(N))
y = np.linspace(-1,1,np.sqrt(N))

x0,y0 = np.meshgrid(x,y)
x = np.reshape(x0,(N,))
y = np.reshape(y0,(N,))

# Let's look at it just for fun
#plt.figure()
#plt.scatter(x,y)
#plt.plot(x,y,linewidth=0.5)
#plt.show()

#Sj = zip(x,y)

# We also need a voronoi diagram!
#opts = []
#vor = Voronoi(Sj,opts)
#voronoi_plot_2d(vor)
#plt.show()

# calculate the areas for every voronoi region
#areas = np.zeros((len(vor.regions),1))
#for ii,reg in enumerate(vor.regions):
#    verts = np.zeros((len(reg),2))
#    for jj,vert_idx in enumerate(reg):
#        verts[jj] = vor.vertices[vert_idx]
#    areas[ii] = PolyArea(verts[:,0],verts[:,1])

# We'll also need to load in the Shepp-Logan phantom
im = imageio.imread('https://upload.wikimedia.org/wikipedia/commons/thumb/c/c7/SheppLogan_Phantom.svg/145px-SheppLogan_Phantom.svg.png')
im = im[:,:,0] # remove color

# Put it into k-space
IM = np.fft.fftshift(np.fft.fft2(im))

# Sample this image at the points given by the Lissajou trajectory
xs = np.array(np.round(im.shape[0]/2*(x+1)),dtype=np.uint32)
ys = np.array(np.round(im.shape[1]/2*(y+1)),dtype=np.uint32)

# Complex k-space data is now d
d = IM[xs,ys]

# scale xs, ys to kmax, -.5 -> .5
xss = 1.0*xs/(2*im.shape[0])
yss = 1.0*ys/(2*im.shape[1])

# k-space trajectory (kx,ky) is now k = kx + 1j*ky
k = xss + 1j*yss

m = grid1(d,k,im.shape[0])
im1 = np.fft.ifft2(m)

#m = np.zeros(im.shape,dtype=complex)
#m[xs,ys] = d
#im1 = np.fft.ifft2(m)

plt.figure()
plt.imshow(im,cmap='gray')
plt.title('Original')

plt.figure()
plt.scatter(x,y)
plt.title('Trajectory')

plt.figure()
#plt.imshow(np.absolute(im1),cmap='gray')
plt.imshow(np.absolute(im1),cmap='gray')
plt.title('Reconstructed')
#plt.scatter(im.shape[0]/2*(x + 1),im.shape[1]/2*(y + 1))
plt.show()
