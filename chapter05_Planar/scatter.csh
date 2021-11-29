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

if( $#argv != 11 )then
usage:
 cat << EOF > /dev/stderr
Usage: $prog -f <force> k1 k2 x10 x20 v10 v20 STEPS t0 tf x20_max dx20
Other Options:
 -n Do not animate trajectory
Available forces (value of <force>):
1: ax= k1*x1/r^3      ay= k1*x2/r^3       Coulomb Force
2: ax= k1*x1/r^k2     ay= k1*x2/r^k2      power law central force
3: ax= f(r)*x1/r      ay= f(r)*x2/r       f(r)=1/r^2-r/k1^3, r<k1
4: ax= f(r)*x1/r      ay= f(r)*x2/r       f(r)=k1 e^(-r/k2) (1+r/k2) (Yukawa)
EOF
 exit(1)
endif

set k1    = $argv[1]
set k2    = $argv[2]
set x10   = $argv[3]
set x20   = $argv[4]
set v10   = $argv[5]
set v20   = $argv[6]
set STEPS = $argv[7]
set t0    = $argv[8]
set tf    = $argv[9]
set x20f  = $argv[10]
set dx20  = $argv[11]

# corresponds to the numeric value of $force:
# gives filename with function as rk2_{name in parenthesis}.f90
set forcecode = (cb pow hy yu)

if( $force > $#forcecode)then
 echo "${prog}: Not valid code for type of force"
 goto usage
endif
gfortran -O2 scatter.f90 rk2_${forcecode[$force]}.f90 -o scatter
./scatter <<EOF
$k1 $k2
$STEPS $t0 $tf $x10 $x20 $v10 $v20
$x20f $dx20
EOF

gnuplot -persist  -geometry 440x270 <<EOF
set term qt 1
set xlabel "b"
set ylabel "theta"
plot "< grep @   scatter.dat" using 2:3 with lines notit
set term qt 2
set xlabel "theta"
set ylabel "sigma"
plot "< grep ds= scatter.dat" using 2:4 with lines notit
set term qt 3
set log y
replot
unset log
EOF

grep "sigmatot=" scatter.dat
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
