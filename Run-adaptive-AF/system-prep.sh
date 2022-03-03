for i in {1..32}; do
mkdir Model-${i}
cp PDBs-rename/prot${i}.pdb Model-${i}/prot.pdb
cd Model-${i}
cp ../tleap.all .
subst 'CYS A  49' 'CYX A  49' prot.pdb 
subst 'CYS A  54' 'CYX A  54' prot.pdb
subst 'CYS A 251' 'CYX A 251' prot.pdb 
subst 'CYS A 287' 'CYX A 287' prot.pdb
subst 'ASP A 216' 'ASH A 216' prot.pdb
tleap -s -f tleap.all
acpype -p com_solvated.top -x com_solvated.crd -b gmx
#echo q | gmx make_ndx -f gmx.amb2gmx/gmx_GMX.gro
cd gmx.amb2gmx
echo q | gmx make_ndx -f gmx_GMX.gro
echo 4 | gmx genrestr -f gmx_GMX.gro -fc 500 500 500 -n index.ndx
cd ../..
done
