#!/bin/tcsh -f 
#====================================================
set force   = rkA_2pcb.f90
set animate = 1 # set this to 0 if you don't want animation
#====================================================
# rkA_2pcb.csh  0.5 4000 10 -1 1 0.3 0 1 -1 -0.3 0
# rkA_2pcb.csh -0.5 4000 10 -1 1 0.3 0 1 -1 -0.3 0
#====================================================
set prog    = `basename $0`
if( $#argv != 11 )then
usage:
 cat << EOF > /dev/stderr
Usage: $prog  k1 Nt Tf x1 y1 vx1 vy1 x2 y2 vx2 vy2
EOF
 exit(1)
endif

set k1  = $argv[1]
set k2  = 0
set Nt  = $argv[2]
set Ti  = 0
set Tf  = $argv[3]
set x1  = $argv[4]
set y1  = $argv[5]
set vx1 = $argv[6]
set vy1 = $argv[7]
set x2  = $argv[8]
set y2  = $argv[9]
set vx2 = $argv[10]
set vy2 = $argv[11]

set exe = rkA
set out = rkA.dat
gfortran -O2 rkA.f90 $force -o $exe
$exe <<EOF
$k1 $k2
$Nt $Ti $Tf $x1 $y1 $vx1 $vy1 $x2 $y2 $vx2 $vy2
EOF
gnuplot -persist <<EOF
set term qt 1
plot "$out" u 2:3 w l t "1", "$out" u 6:7 w l t "2"
EOF

if( $animate)then
 set skip = `awk -v s=$Nt 'BEGIN{s=int(s/100);if(s<1){s=1};print s}'`
 ./rkA_animate2.csh -d $skip -r
endif
#  ---------------------------------------------------------------------
#  Copyright by Konstantinos N. Anagnostopoulos (2004-2014)
#  Physics Dept., National Technical University,
#  konstant@mail.ntua.gr, www.physics.ntua.gr/~konstant
#  
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, version 3 of the License.
#  
#  This program is distributed in the hope that it will be useful, but
#  WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#  General Public License for more details.
#  
#  You should have received a copy of the GNU General Public Liense along
#  with this program.  If not, see <http://www.gnu.org/licenses/>.
#  -----------------------------------------------------------------------
