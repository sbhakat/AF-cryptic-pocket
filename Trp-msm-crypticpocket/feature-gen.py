#msmbuilder imports 
from msmbuilder.dataset import dataset
from msmbuilder.featurizer import ContactFeaturizer
from msmbuilder.featurizer import DihedralFeaturizer
from msmbuilder.decomposition import tICA
from msmbuilder.cluster import MiniBatchKMeans
from msmbuilder.msm import ContinuousTimeMSM
from msmbuilder.utils import verbosedump,verboseload
from msmbuilder.cluster import KCenters
from msmbuilder.utils import load,dump

#other imports
import os,glob,shutil
import numpy as np
import mdtraj as md
import pandas as pd 
import pickle
#prettier plots

#Loading the trajectory
ref = md.load('prot.pdb')
#a = ref.top.select("resid 73 to 87")
b = ref.top.select("resid 42")
#c = np.concatenate((b, a), axis=None)

## Path to .xtc files
ds = dataset("../*.xtc", topology="prot.pdb", atom_indices=b, stride=20)


#Featurization
featurizer = DihedralFeaturizer(types=['chi1', 'chi2'])
dump(featurizer,"transformed_raw_featurizer.pkl")

#from msmbuilder.utils import load,dump
f=DihedralFeaturizer(types=['chi1', 'chi2'], sincos=False)
dump(f,"raw_featurizer.pkl")

#featurizer = DihedralFeaturizer(types=['chi1', 'chi2'], resids= 73,74,75,76,77,78,79,80,81,82,83)
diheds = featurizer.fit_transform(ds)
dump(diheds, "features.pkl")
                            
dihedsraw = f.fit_transform(ds)
dump(dihedsraw, "raw-features.pkl")     
#print(ds[0].shape)
print(diheds[0].shape)

# this basically maps every feature to atom indices. 
#df1 = pd.DataFrame(featurizer.describe_features(ds))
#dump(df1, "feature_descriptor.pkl")

#Robust scaling
from msmbuilder.preprocessing import RobustScaler
scaler = RobustScaler()
scaled_diheds = scaler.fit_transform(diheds)

dump(scaled_diheds, "scaled-transformed-features.pkl")
