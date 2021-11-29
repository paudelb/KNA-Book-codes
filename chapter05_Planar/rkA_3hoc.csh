#!/bin/tcsh -f 
#====================================================
set force   = rkA_3hoc.f90
set animate = 1 # set this to 0 if you don't want animation
#====================================================
#set s60 = 0.8660254037844386  # sin(60o)
#rkA_3hoc.csh 1 4000 2.5  0.5 0  0     0      -0.5 0  0   0       0 $s60 0    0 !still system
#rkA_3hoc.csh 1 4000 12   0.5 0  1     0      -0.5 0  1   0       0 $s60 1    0 !translational mode
#rkA_3hoc.csh 1 4000 12   0.5 0 -0.5  -$s60   -0.5 0 -0.5 $s60    0 $s60 1    0
#rkA_3hoc.csh 1 4000 12   0.7 0  0     0      -0.7 0  0   0       0 $s60 0.01 0
#====================================================
set prog    = `basename $0`
if( $#argv != 15 )then
usage:
 cat << EOF > /dev/stderr
Usage: $prog  k1 Nt Tf x1 y1 vx1 vy1 x2 y2 vx2 vy2 x3 y3 vx3 vy3
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
set x3  = $argv[12]
set y3  = $argv[13]
set vx3 = $argv[14]
set vy3 = $argv[15]

set exe = rkA
set out = rkA.dat
gfortran -O2 rkA.f90 $force -o $exe
$exe <<EOF
$k1 $k2
$Nt $Ti $Tf $x1 $y1 $vx1 $vy1 $x2 $y2 $vx2 $vy2 $x3 $y3 $vx3 $vy3
EOF
gnuplot -persist <<EOF
set term qt 1
plot "$out" u 2:3 w l t "1", "$out" u 6:7 w l t "2", "$out" u 10:11 w l t "3"
EOF

if( $animate)then
 set skip = `awk -v s=$Nt 'BEGIN{s=int(s/100);if(s<1){s=1};print s}'`
 ./rkA_animate3.csh -d $skip -r
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
