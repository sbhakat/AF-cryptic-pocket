# Accelerating cryptic pocket discovery using AlphaFold

**Conformational generation using Google Colabfold**

```
notebook=https://colab.research.google.com/github/sokrypton/ColabFold/blob/main/beta/AlphaFold2_advanced_beta.ipynb
sequence=LGSSNDNIELVDFQNIMFYGDAEVGDNQQPFTFILDTGSANLWVPSVKCTTAGCLTKHLYDSSKSRTYEKDGTKVEMNYVSGTVSGFFSKDLVTVGNLSLPYKFIEVIDTNGFEPTYTASTFDGILGLGWKDLSIGSVDPIVVELKNQNKIENALFTFYLPVHDKHTGFLTIGGIEERFYEGPLTYEKLNHDLYWQITLDAHVGNIMLEKANCIVDSGTSAITVPTDFLNKMLQNLDVIKVPFLPFYVTLCNNSKLPTFEFTSENGKYTLEPEYYLQHIEDVGPGLCMLNIIGLDFPVPTFILGDPFMRKYFTVFDYDNHSVGIALAKKNL
msa_method=jackhmmer
homooligomer=1
pair_mode=unpaired+paired
pair_cov=50
pair_qid=30
cov=75
qid=30
max_msa=32:64
subsample_msa=True
num_relax=None
use_turbo=True
use_ptm=True
rank_by=pLDDT
num_models=1
num_samples=32
num_ensemble=1
max_recycles=3
tol=0
is_training=True
use_templates=False
```
In order to launch MD simulations from AlphaFold generated structures you need to install ```Ambertools2022```, ```Gromacs 2021``` patched with ```Plumed 2.7```

**Sampling of cryptic pocket by AlphaFold**:

Projection of AlphaFold-generated structures (black dots) on reweighted free energy surface along χ1 and χ2 angles of Trp41 reveal that AlphaFold primarily generates structures in low-energy basins. Path along minimum free energy pathway between open and closed basin is calculated using string method and highlighted in blue line. Metadynamics simulations were performed using χ1 and χ2 angles of Trp41 as CVs starting from unliganded holo PM II (PDB: 2BJU). 

![error](/fes-af.png)

