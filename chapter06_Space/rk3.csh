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
1: ax=-k2 vx    ay=-k2 vy    az=-k2 vz - k1     Free fall
2: ax= k2+k1 vy ay= k3-k1 vx az=k4              E+B field:  qB/m=k1 z qE/m=k2 x+k3 y+k4 z
3: ax= (k1+k2*x3p)vy ay= -(k1+k2*x3p) * vx az=0 where x3p=(x3>0)?x3:0 B field with variable z-component. Not physical!
4: ax=vy(k1+k2 z)+vz k2 y ay= -vx (k1+k2 z) az= -vx k2 y qBy/m= -k2 y qBz/m = (k1+k2 z)k
5: a1=v2(k1+k2 x2) a2=-v1(k1+k2 x2) a3 = v1 k3 x3  qBy/m= k3 x3 qBz/m =k1+k2 x2
6: a1=-k1 x     ay=-k2 y     az=-k3 z           Simple harmonic oscillator
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


# corresponds to the numeric value of $force:
# gives filename with function as rk3_{name in parenthesis}.f
set forcecode = (g B Bz Bzy Byz hoc)

if( $force > $#forcecode)then
 echo "${prog}: Not valid code for type of force"
 goto usage
endif
gfortran -O2 rk3.f90 rk3_${forcecode[$force]}.f90 rksuite/rksuite.f -o rk3
./rk3 <<EOF
$k1 $k2 $k3 $k4
$STEPS $t0 $tf $x10 $x20 $x30 $v10 $v20 $v30
EOF

gnuplot -persist  -geometry 440x270 <<EOF
set term x11 1
plot "rk3.dat" using 1:2 with lines title "x1(t)"
set term x11 2
plot "rk3.dat" using 1:3 with lines title "x2(t)"
set term x11 3
plot "rk3.dat" using 1:4 with lines title "x3(t)"
set term x11 4
plot "rk3.dat" using 1:5 with lines title "v1(t)"
set term x11 5
plot "rk3.dat" using 1:6 with lines title "v2(t)"
set term x11 6
plot "rk3.dat" using 1:7 with lines title "v3(t)"
set term x11 7
plot "rk3.dat" using 1:8 with lines title "E(t)"
set term x11 8
set title "trajectory"
set xlabel "x"
set ylabel "y"
set zlabel "z"
splot "rk3.dat" u 2:3:4 w l notit
EOF

if( $animate)then
 set skip = `awk -v s=$STEPS 'BEGIN{s=int(s/100);if(s<1){s=1};print s}'`
 ./rk3_animate.csh -d $skip -r
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
