#!/bin/tcsh -f 

set cdir = $cwd
set prog = `basename $0`
if( $#argv != 8 )then
usage:
 cat << EOF > /dev/stderr
Usage: $prog <omega_0> <omega> <gamma> <a_0> <STEPS> <t_f> <x_0> <v_0>
EOF
 exit(1)
endif


set omega0 = $argv[1] # 10.0
set omega  = $argv[2] # 14.0
set gamma  = $argv[3] # 0.2
set a0     = $argv[4] # 1.0
set STEPS  = $argv[5] # 10000
set TF     = $argv[6] # 40.0
set X0     = $argv[7] # 5.0
set V0     = $argv[8] # 0.0
gfortran -O2 dlo.f90 -o dlo
./dlo <<EOF
$omega0  $omega $gamma $a0         omega_0, omega, gamma, a_0
$STEPS   0.0    $TF    $X0  $V0    STEPS,T0,TF,X0,V0
EOF

gnuplot -persist  -geometry 440x270 <<EOF
set term x11 1
plot "dlo.dat" using 1:2 with lines title "x(t)"
set term x11 2
plot "dlo.dat" using 1:3 with lines title "v(t)"
set term x11 4
plot "dlo.dat" using 1:4 with lines title "E(t)"
set term x11 3
set size square
plot "dlo.dat" using 2:3 with lines title "x-v"
EOF

dlo_meas.awk dlo.dat
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
