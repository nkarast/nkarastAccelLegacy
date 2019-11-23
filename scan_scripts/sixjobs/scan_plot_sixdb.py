import glob
import os
import re
import sys
sys.path.append('/afs/cern.ch/project/sixtrack/SixDesk_utilities/pro/utilities/externals/SixDeskDB/')
import sixdeskdb

import numpy as np
import matplotlib as mpl
import matplotlib.pyplot as plt
import matplotlib.cm as cm
from matplotlib import rc
from matplotlib.ticker import MaxNLocator
from matplotlib.ticker import ScalarFormatter
from scipy.ndimage.filters import gaussian_filter

from math import sqrt
from scipy.interpolate import griddata
from datetime import datetime

import contextlib
import pickle


def show_values(pc, fmt="%.2f", **kw):
  from itertools import izip
  pc.update_scalarmappable()
  ax = pc.get_axes()
  print pc.get_array()
  for p, color, value in izip(pc.get_paths(), pc.get_facecolors(), pc.get_array()):
    x, y = p.vertices[:-2, :].mean(0)
    if np.all(color[:3] > 0.5):
      color = (0.0, 0.0, 0.0)
    else:
      color = (1.0, 1.0, 1.0)
    ax.text(x, y, fmt % value, ha="center", va="center", color=color, **kw)



@contextlib.contextmanager
def nostdout():
  class DummyFile(object):
    def write(self, x): pass
  save_stdout = sys.stdout
  sys.stdout = DummyFile()
  yield
  sys.stdout = save_stdout


def study2da(study, func):
  print 'Processing', study, '...'
  with nostdout():
    try:
      db=sixdeskdb.SixDeskDB.from_dir('./studies/'+study+'/')
    except:
      print 'WARNING: some problems with sixdb occurred while loading the study'   
      return -1.
    try:
      db.mk_da()
    except:
      print 'WARNING: some problems with sixdb occurred while generating the table'
      return -1.
    try:
      seed,angle,da=db.get_da_angle().T
    except:
      print 'WARNING: some problems with sixdb occurred while extracting DAs'
      return -1.
  da = [item for item in da if item > 0.1] # sometimes it is negative or zero...
  if len(da)==0: return -5
  print da
  return float(func(da)) # eg. np.amin(da)

def readTxt(filename):
  # returns the luminosity data for the beta-xing plot, for the given intensity
  out = []
  beta, xing, lumi = np.loadtxt(filename, unpack=True)
  out.append(tuple(beta))
  out.append(tuple(xing))
  out.append(tuple(lumi))
  return out


def file2dic(study, mydic, study_template):
# collects the data from the study files into a dictionary
  da = study2da(study, np.amin)
  if da > 0.:
    #m = re.match(r"(?:xbi_check_v13_IMO0_C3_)(?P<X>[0-9](?:_)(?P<Y>[0-9]?)(:?P<I>[0-9]*\.[0-9]*)", study)
    m = re.match(r"(?:"+study_template+r")(?:_)(?P<X>[0-9]*)(?:_)(?P<Y>[0-9]*\.[0-9]*)",study)
    x = float(m.group("X"))
    y = float(m.group("Y"))
    key = (x,y)
    #print key
    mydic[key] = da 

def dic2out(mydic):
  out = []
  for key, aperture in mydic.iteritems():
    out.append((key[0],key[1],aperture))
  out.sort()
  return zip(*out) 

def getWorkspace():
# retrieve the name of the workspace from sixdeskenv
  with open('sixdeskenv') as f:
    for line in f:
      trimmed = ''.join(line.split())
      m = re.search(r'exportworkspace=(.*)', trimmed)
      if m:
        return m.group(1)
  raise Exception('"export workspace = ..." not found in sixdeskenv')

##################################################
counter = 0
study_template = "qb_BaselineNominal_C15_En2.5_D0.005_below" #"qb_BaselineUltimate_C7_En2.5_D0.005" #"qb_BaselineUltimate_C15_En2.5_D0.005" #"qb_BaselineNominal_C15_En2.5_D0.005"
db_output = study_template+'_output.pkl'
if ((not os.path.exists(db_output)) or (os.stat(db_output).st_size == 0)):
  dco = {}
  for filename in glob.glob('{}_*'.format(study_template)):

    print filename, counter+1
    counter+=1

    if ".db" not in filename:
      file2dic(filename, dco, study_template)
  
  out = dic2out(dco)
  with open(db_output, 'wn') as handle:
    pickle.dump(out, handle, protocol = pickle.HIGHEST_PROTOCOL)
else:
  with open(db_output, 'rb') as handle:
    print 'Opening...', db_output
    out = pickle.load(handle)

 
#now plotting
x = np.unique(np.array(out[0]))
factor = 1.0 #2.0e-6*np.sqrt(0.25*7460.5/2.5e-6)
y = factor*np.unique(np.array(out[1]))

#y = np.unique(np.array(out[1]))
#dx = x[-1]-x[-2]
#dy = y[-1]-y[-2]

# for contour
xx1, yy1 = np.meshgrid(x,y) 
# for pcolormesh
xx2, yy2 = xx1, yy1 #np.meshgrid(np.append(x, x[-1]+dx)-dx/2., np.append(y,y[-1]+dy)-dy/2.)

# modify the bin size to better fit the 15cm beta* line
#yy2[0] = [12.5]*len(yy2[0])
#yy2[1] = [17.5]*len(yy2[1])


z = griddata((out[0], factor*np.array(out[1])), out[2], (xx1, yy1), method='linear') #interpolates missing points
z1 = gaussian_filter(z, sigma=0.6)
z2 = z #gaussian_filter(z, sigma=0.4)

x1, y1 = xx1[0], [row[0] for row in yy1]
x2, y2 = xx2[0], [row[0] for row in yy2]


#rc('font',**{'family':'sans-serif','sans-serif':['Helvetica']})
mpl.rcParams.update({'font.size': 20}) 
plt.rcParams.update({'mathtext.default': 'regular'})


#plt.close('all')
fig = plt.figure("scan2", figsize=(12,10))
ax  = fig.add_subplot(111)
#ax.set_title("Min DA LHC Run-III, $\mathbf{r_{\mathrm{ATS}}}$=1.6, $n_{b}$=2484, $\mathbf{\epsilon_{n}}$=2.5$\mathbf{\mu}$m, $\mathbf{Q^{\'}}$=15\n$\mathbf{Q_{Y}}$=$\mathbf{Q_{X}}$+0.005, $\mathbf{I_{MO}}$=+500A, $\mathbf{L_{\mathrm{lev}}^{IP8}}$=$\mathbf{2\cdot 10^{33}}$ Hz/$\mathbf{cm^{2}}$", fontsize=20, fontweight='bold', y=1.08)
ax.set_xlabel("$\\beta^{*}$ [m]", fontsize=18, fontweight='bold')
ax.set_ylabel("Fractional $\mathbf{Q_{X}}$", fontsize=18, fontweight='bold')



plt.setp(ax.get_xticklabels(), fontsize=20)
plt.setp(ax.get_yticklabels(), fontsize=20)

cf = plt.pcolormesh(x2,y2,z2, cmap=cm.RdBu)
minDA = 3.0
maxDA = 9.0
plt.clim(minDA, maxDA)
cbar = plt.colorbar(cf, ticks=np.linspace(minDA, maxDA, (maxDA-minDA)*2.+1))
cbar.set_label('DA [$\mathbf{\sigma}$]', rotation=90, fontsize=16, fontweight='bold')
cbar.ax.tick_params(labelsize=16)

#add contour lines

levels = [2.0, 3.0, 4.0, 4.5, 5.0, 5.5, 6.0, 6.5, 7.0, 8.0, 9.0]

ct = plt.contour(x1, y1, z1, levels, colors='k', linewidths=3)

### Do Lumi Contours:
#lumiOut = readTxt("lumi_XBI_I2.2.txt")
#zL = griddata((lumiOut[1],lumiOut[0]), np.array(lumiOut[2]),(xx1,yy1), method="cubic")  
#levelsL = [4.,5.,6.,7.5,9,11,14]
#ctL = plt.contour(x1, y1, zL, levelsL, colors='red', linewidths=3)


plt.tight_layout()
#plt.plot([62.299, 62.3355], [60.299, 60.3355], ls=':', lw=3, c='white', alpha=0.4)
plt.clabel(ct, colors = 'k', fmt = '%2.1f', fontsize=16)
#plt.clabel(ctL, colors = 'red', fmt = '%2.1f', fontsize=16)
#plt.savefig(getWorkspace()+'_'+study_template+"_"+datetime.now().strftime("%Y%m%d")+'_scanSixDB.pdf', dpi=300)
#plt.savefig(getWorkspace()+'_'+study_template+"_"+datetime.now().strftime("%Y%m%d")+'_scanSixDB_sigma.png', dpi=300)
show_values(cf, fontsize=9)
#plt.plot([62.299, 62.3355], [60.299, 60.3355], ls=':', lw=3, c='white', alpha=0.4)
#plt.savefig(getWorkspace()+'_'+study_template+"_"+datetime.now().strftime("%Y%m%d")+'_scanSixDB_values.pdf', dpi=300)

plt.show()

