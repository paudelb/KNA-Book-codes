#!/bin/tcsh -f 

set cdir    = $cwd
set prog    = `basename $0`
set force   = 1
set animate = 1
set argv  = ( `getopt f:nh $argv`)
while ( "$argv[1]" != "--")
 switch ("$argv[1]")
  case -f:
   set force = $argv[2]
   shift
   shift
   breaksw
  case -n:
   set animate = 0
   shift
   breaksw
  case -h:
   goto usage
   shift
   breaksw
 endsw
end   # while
shift # get rid of --

if( $#argv != 13 )then
usage:
 cat << EOF > /dev/stderr
Usage: $prog -f <force> k1 k2 k3 k4 x10 x20 x30 v10 v20 v30 STEPS t0 tf
Other Options:
 -n Do not animate trajectory
Available forces (value of <force>):
1: ax= k2+k1 vy ay= k3-k1 vx az=k4              E+B field:  qB/m=k1 z qE/m=k2 x+k3 y+k4 z
2: B_1 = k1 (3 x1 x3)/r^5 B_2 = k1 (3 x2 x3)/r^5 B_3 = k1[(3 x3 x3)/r^5-1/r^3] Magnetic dipole
EOF
 exit(1)
endif

set k1    = $argv[1]
set k2    = $argv[2]
set k3    = $argv[3]
set k4    = $argv[4]
set x10   = $argv[5]
set x20   = $argv[6]
set x30   = $argv[7]
set v10   = $argv[8]
set v20   = $argv[9]
set v30   = $argv[10]
set STEPS = $argv[11]
set t0    = $argv[12]
set tf    = $argv[13]

# Check that velocities are well defined:
set errv  = `awk -v v1=$v10 -v v2=$v20 -v v3=$v30 'BEGIN{vsq=v1*v1+v2*v2+v3*v3;if(vsq>=1.0){err=1}else{err=0};print err;}'`
if( $errv )then
 echo "${prog}: Sorry, light/superluminal particle not allowed."
 echo "         v1=$v10  v2=$v20  v3=$v30                      "
 exit(1)
endif

# corresponds to the numeric value of $force:
# gives filename with function as sr_{name in parenthesis}.f90
set forcecode = (B Bd)

if( $force > $#forcecode)then
 echo "${prog}: Not valid code for type of force"
 goto usage
endif
gfortran -O2 sr.f90 sr_${forcecode[$force]}.f90 rksuite/rksuite.f -o sr
if( -f sr.dat) \mv -f sr.dat sr.dat.bak
./sr <<EOF
$k1 $k2 $k3 $k4
$STEPS $t0 $tf $x10 $x20 $x30 $v10 $v20 $v30
EOF

gnuplot -persist  -geometry 440x270 <<EOF
set term x11 1
plot "sr.dat" using 1:2  with lines title "x1(t)"
set term x11 2
plot "sr.dat" using 1:3  with lines title "x2(t)"
set term x11 3
plot "sr.dat" using 1:4  with lines title "x3(t)"
set term x11 4
plot "sr.dat" using 1:5  with lines title "v1(t)"
set term x11 5
plot "sr.dat" using 1:6  with lines title "v2(t)"
set term x11 6
plot "sr.dat" using 1:7  with lines title "v3(t)"
set term x11 7
plot "sr.dat" using 1:8  with lines title "E(t)"
set term x11 8
plot "sr.dat" using 1:9  with lines title "p1(t)"
set term x11 9
plot "sr.dat" using 1:10 with lines title "p2(t)"
set term x11 10
plot "sr.dat" using 1:11 with lines title "p3(t)"
set term x11 11
set title "trajectory"
set xlabel "x"
set ylabel "y"
set zlabel "z"
splot "sr.dat" u 2:3:4 w l notit
EOF

if( $animate)then
 set skip = `awk -v s=$STEPS 'BEGIN{s=int(s/100);if(s<1){s=1};print s}'`
 ./sr_animate.csh -d $skip -r
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
