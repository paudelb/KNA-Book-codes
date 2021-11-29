#!/bin/tcsh -f 

set cdir = $cwd
set prog = `basename $0`
if( $#argv != 9 )then
usage:
 cat << EOF > /dev/stderr
Usage: $prog <omega_0> <omega> <gamma> <A> <STEPS> <t_f> <x_0> <v_0> <t_trans>
 t_trans: Number of steps to ommit from analysis
EOF
 exit(1)
endif


set omega0  = $argv[1] # 10.0
set omega   = $argv[2] # 14.0
set gamma   = $argv[3] # 0.2
set a0      = $argv[4] # 1.0
set STEPS   = $argv[5] # 10000
set TF      = $argv[6] # 40.0
set X0      = $argv[7] # 5.0
set V0      = $argv[8] # 0.0
set t_trans = $argv[9] #
gfortran -O2 fdp.f90 -o fdp
./fdp <<EOF
$omega0  $omega $gamma $a0         omega_0, omega, gamma, A
$STEPS   0.0    $TF    $X0  $V0    STEPS,T0,TF,X0,V0
EOF

mv fdp.dat tmp.fdp.dat
awk -v tt=$t_trans '/#/{print} $1>tt{print}' tmp.fdp.dat > fdp.dat
\rm tmp.fdp.dat
gnuplot -persist  -geometry 440x270 <<EOF
set term x11 1
plot "fdp.dat" using 1:2 with dots  title "x(t)"
set term x11 2
plot "fdp.dat" using 1:3 with lines title "v(t)"
set term x11 3
plot "fdp.dat" using 1:4 with lines title "E(t)"
set term x11 4
set size square
plot "fdp.dat" using 2:3 with dots  title "x-v"
# poincare plot:
set term x11 5
plot "<awk -v o=$omega -v s=$STEPS -v tf=$TF 'BEGIN{T=6.283185307179/o;dt=tf/s;}\$1%T<dt' fdp.dat" using 2:3 with points pt 20 ps 1  title "Poincare"
EOF

#fdp_meas.awk fdp.dat
echo "Kill gnuplot windows to proceed:"
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
