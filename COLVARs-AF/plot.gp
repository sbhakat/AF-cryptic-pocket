set term postscript eps colour size 6.4,4.4 font "Times-Roman,28" 
set style fill transparent solid 0.2

set output 'af-tyr-trp.eps'

set xlabel 'Tyr {/Symbol c}1 (Rad)'
set ylabel 'Tyr-Trp (nm)'

set xrange [-pi:pi]
set yrange [0.2:1.8]
set cbrange [0:40]

set parametric
set pm3d map
set contour base

set palette rgb 30,31,32
set cntrparam levels incr 0,5,40
set palette maxcolors 12

sp 'fes_chi1_trp.dat' u 1:2:3 notitle, 'COLVAR-combined-32snapshots' u 6:3:(0.0) w p ps 2.0 pt 7 lc 8 notitle

reset

set term postscript eps colour size 6.4,4.4 font "Times-Roman,28" 
set style fill transparent solid 0.2

set output 'af-tyr-asp.eps'

set xlabel 'Tyr {/Symbol c}1 (Rad)'
set ylabel 'Tyr-Asp (nm)'

set xrange [-pi:pi]
set yrange [0.2:1.8]
set cbrange [0:40]

set parametric
set pm3d map
set contour base

set palette rgb 30,31,32
set cntrparam levels incr 0,5,40
set palette maxcolors 12

sp 'fes_chi1_asp.dat' u 1:2:3 notitle, 'COLVAR-combined-32snapshots' u 6:8:(0.0) w p ps 2.0 pt 7 lc 8 notitle

reset

set term postscript eps colour size 6.4,4.4 font "Times-Roman,28" 
set style fill transparent solid 0.2
set output 'af-dist2.eps'

set xlabel 'Tyr {/Symbol c}1 (Rad)'
set ylabel 'Flap distance (nm)'

set xrange [-pi:pi]
set yrange [0.6:2.4]
set cbrange [0:40]

set parametric
set pm3d map
set contour base

set palette rgb 30,31,32
set cntrparam levels incr 0,5,40
set palette maxcolors 12

sp 'fes_chi1_open.dat' u 1:2:3 notitle, 'COLVAR-combined-32snapshots' u 6:2:(0.0) w p ps 2.0 pt 7 lc 8 notitle

reset

set term postscript eps colour size 6.4,4.4 font "Times-Roman,28" 
set style fill transparent solid 0.2
set output 'af-chi1-chi2.eps'

set xlabel 'Tyr {/Symbol c}1 (Rad)'
set ylabel 'Tyr {/Symbol c}2 (Rad)'

set xrange [-pi:pi]
set yrange [-pi:pi]
set cbrange [0:40]

set parametric
set pm3d map
set contour base

set palette rgb 30,31,32
set cntrparam levels incr 0,5,40
set palette maxcolors 12

sp 'fes_chi1chi2.dat' u 1:2:3 notitle, 'COLVAR-combined-32snapshots' u 6:7:(0.0) w p ps 2.0 pt 7 lc 8 notitle

reset

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

sp 'fes_trpchi1chi2.dat' u 1:2:3 notitle, 'COLVAR-combined-32snapshots' u 9:10:(0.0) w p ps 2.0 pt 7 lc 8 notitle
