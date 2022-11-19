for i in {1..32}; do

mkdir Model-${i}
cp AF-structures/prot${i}.pdb Model-${i}/prot.pdb
cd Model-${i}
cp ../tleap.all .
subst 'CYS A  49' 'CYX A  49' prot.pdb 
subst 'CYS A  54' 'CYX A  54' prot.pdb
subst 'CYS A 251' 'CYX A 251' prot.pdb 
subst 'CYS A 287' 'CYX A 287' prot.pdb
subst 'ASP A 216' 'ASH A 216' prot.pdb
tleap -s -f tleap.all
sander -O -i ../inputs/min.in -o min.out -p com_solvated.top -c com_solvated.crd -ref com_solvated.crd -r Partial_Mini.rst
sander -O -i ../inputs/full-min.in -o full-min.out -p com_solvated.top -c Partial_Mini.rst -r Full_Mini.rst
ambpdb -p com_solvated.top -c Full_Mini.rst > Full_Mini.pdb
echo 0 | gmx trjconv -s Full_Mini.pdb -f Full_Mini.pdb -o Full-min.gro
acpype -p com_solvated.top -x com_solvated.crd -b gmx

cd gmx.amb2gmx

echo q | gmx make_ndx -f gmx_GMX.gro
echo 4 | gmx genrestr -f gmx_GMX.gro -fc 500 500 500 -n index.ndx
gmx grompp -f ../../inputs/em.mdp -c ../Full-min.gro -p gmx_GMX.top -o em.tpr -maxwarn 1
gmx mdrun -ntmpi 1 -v -deffnm em

sleep 1s

gmx grompp -f ../../inputs/nvt.mdp -c em.gro -r em.gro -p gmx_GMX.top -o nvt.tpr -maxwarn 1

sleep 1s

gmx mdrun -s nvt.tpr -o nvt.trr -x nvt.xtc -cpo nvt.cpt -c nvtout.gro -e nvt.edr -g nvt.log -nb gpu -bonded gpu -pme gpu -pin on -v

sleep 1s

gmx grompp -f ../../inputs/npt.mdp -c nvtout.gro -r nvtout.gro -t nvt.cpt -p gmx_GMX.top -o npt.tpr -maxwarn 1

sleep 1s

gmx mdrun -s npt.tpr -o npt.trr -x npt.xtc -cpo npt.cpt -c nptout.gro -e npt.edr -g npt.log -nb gpu -bonded gpu -pme gpu -pin on -v

sleep 1s

gmx grompp -f ../../inputs/md.mdp -c nptout.gro -t npt.cpt -p gmx_GMX.top -o md.tpr -maxwarn 1

sleep 1s

gmx mdrun -s md.tpr -v -nb gpu -bonded gpu -pme gpu -nstlist 400 -update gpu -plumed plumed.dat
cd ../..
done
