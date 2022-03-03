# In case you want to start amber way of setting minimization
for i in {8,9,14,23,26,27,28,30,31}; do
cp min.in Model-${i}
cp full-min.in Model-${i}
cd Model-${i}
sander -O -i min.in -o min.out -p com_solvated.top -c com_solvated.crd -ref com_solvated.crd -r Partial_Mini.rst
sander -O -i full-min.in -o full-min.out -p com_solvated.top -c Partial_Mini.rst -r Full_Mini.rst
ambpdb -p com_solvated.top -c Full_Mini.rst > Full_Mini.pdb
echo 0 | gmx trjconv -s Full_Mini.pdb -f Full_Mini.pdb -o Full-min.gro
