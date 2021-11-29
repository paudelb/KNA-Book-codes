#!/bin/tcsh -f 

set DIMS    = (4 8 12 16 24 32 36 42 48 64)
set lambdas = (0.5 0.8 1.0 1.2 1.4 1.6 1.8 2.0 2.2 2.4 2.6 2.8 3.0 )

set out     = data
set exe     = an
set src     = anharmonic.f90

gfortran -O2 $src -o $exe -llapack -lblas
if( -f $out ) \mv $out ${out}.bak
foreach DIM ($DIMS)
 foreach lambda ($lambdas)
  echo -n "Working on DIM= $DIM lambda= $lambda "
  /usr/bin/time $exe <<EOF >> $out
$DIM
$lambda
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
