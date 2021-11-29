#!/bin/tcsh -f 


set DIMS    = (950)
set lambdas = (0.001 0.002 0.004 0.006 0.008 0.0092 0.01 0.011 0.012 0.013 0.015 0.02 0.022 0.025 0.03 0.035 0.04 0.05 0.06 0.08 0.1 0.15 0.20 0.25 0.30 0.35 0.4 0.5 0.6 0.8  1 1.3 1.6 2 3 4 5 8 10 14 20 30) # 0.8 1.0 1.2 1.4 1.6 1.8 2.0 2.2 2.4 2.6 2.8 3.0 )

set out     = dw.dat
set exe     = dw
set src     = doublewell.f90


#gfortran -O2 $src -o $exe -llapack -lblas
ifort  -fast -parallel  -mkl=parallel  $src -o $exe
if( -f $out ) \mv $out ${out}.bak
foreach DIM ($DIMS)
 foreach lambda ($lambdas)
  echo -n "Working on DIM= $DIM lambda= $lambda "
  /usr/bin/time $exe <<EOF |grep ^EV >> $out
$DIM $DIM 20
$lambda $lambda 20.0
EOF
 end
end
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
