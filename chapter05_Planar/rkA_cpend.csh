#!/bin/tcsh -f 
#====================================================
set force   = rkA_cpend.f90
set animate = 0 # set this to 0 if you don't want animation
#====================================================
# 
# 
#====================================================
set prog    = `basename $0`
if( $#argv != 8 )then
usage:
 cat << EOF > /dev/stderr
Usage: $prog  k1 k2 Nt Tf th1 om1 th2 om2
EOF
 exit(1)
endif

set k1  = $argv[1]
set k2  = $argv[2]
set Nt  = $argv[3]
set Ti  = 0
set Tf  = $argv[4]
set th1 = $argv[5]
set om1 = $argv[6]
set th2 = $argv[7]
set om2 = $argv[8]

set exe = rkA
set out = rkA.dat
gfortran -O2 rkA.f90 $force -o $exe
$exe <<EOF
$k1 $k2
$Nt $Ti $Tf $th1 $om1 $th2 $om2
EOF

#Now we transform rkA.dat to (x,y) coordinates 
#and create a new one:
set out1 = ${out:r}_theta.dat
/bin/mv -f $out $out1
awk '{l=1;\
      t=$1;th1=$2;om1=$3;th2=$4;om2=$5;E=$6;\
      x1=l*sin(th1);y1=-l*cos(th1);x2=l+l*sin(th2);y2=-l*cos(th2);\
      v1x=(om1*l)*cos(th1);v1y=(om1*l)*sin(th1);\
      v2x=(om2*l)*cos(th2);v2y=(om2*l)*sin(th2);\
      print t,x1,y1,v1x,v1y,x2,y2,v2x,v2y,E}' $out1 > $out
gnuplot -persist <<EOF
set term qt 1
plot [-1.1:2.1][-1.1:1.1]"$out" u 2:3 w l t "(x1,y1)", "$out" u 6:7 w l t "(x2,y2)",0 notit
set term qt 2
# plot "rkA_theta.dat" u 1:(\$2-int(\$2/(2*pi))*(2*pi)) w l t "theta1", "./rkA_theta.dat" u 1:(\$4-int(\$4/(2*pi))*(2*pi)) w l t "theta2"
#plot "rkA_theta.dat" u 1:(acos(cos(\$2))) w l t "theta1", "./rkA_theta.dat" u 1:(acos(cos(\$4))) w l t "theta2"
plot "rkA_theta.dat" u 1:(atan2(sin(\$2),cos(\$2))) w l t "theta1", "./rkA_theta.dat" u 1:(atan2(sin(\$4),cos(\$4))) w l t "theta2"
set term qt 3
plot "rkA.dat" u 1:2 w l t "x1(t)", "rkA.dat" u 1:3 w l t "y1(t)"
set term qt 4
plot "rkA.dat" u 1:6 w l t "x2(t)", "rkA.dat" u 1:7 w l t "y2(t)"
EOF

if( $animate)then
 set skip = `awk -v s=$Nt 'BEGIN{s=int(s/100);if(s<1){s=1};print s}'`
 ./rkA_animate2.csh -x -1.1 -X 2.1 -y -1.1 -Y 1.1 -d $skip -r
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
