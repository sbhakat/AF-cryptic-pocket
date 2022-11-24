set term postscript eps colour size 6.4,4.4 font "Times-Roman,28" 
set style fill transparent solid 0.2
set output 'af-chi1-chi2-trp.eps'

set xlabel 'Trp {/Symbol c}1 (Rad)'
set ylabel 'Trp {/Symbol c}2 (Rad)'
set cbrange [0:40]

set xrange [-pi:pi]
set yrange [-pi:pi]

set parametric
set pm3d map
set contour base
#set dgrid3d

set palette rgb 30,31,32
set cntrparam levels incr 0,5,40
set palette maxcolors 12

sp 'fes_trpchi1chi2.dat' u 1:2:3 notitle, 'COLVAR-combined-32snapshots' u 9:10:(0.0) w p ps 2.0 pt 7 lc 8 notitle, 'tranpath_neb_DtoB.dat' u 2:3:(0.0) w l ls 1 lt rgb "blue" lw 2 notitle
