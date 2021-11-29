#!/bin/tcsh -f 

#set DIMS    = (512) #4 8 12 16 24 32 36 42 48 64)
#set lambdas = (0.5 0.8 1.0 1.2 1.4 1.6 1.8 2.0 2.2 2.4 2.6 2.8 3.0 3.2 3.4 3.6 3.8 4.0 4.5 5.0 5.5 6.0 6.5 7.0 7.5 8.0 8.5 9.0 9.5 10.0 10.5 11.0 12.0 14.0 15.0 18.0 20.0 24.0 28.0 32.0 36.0 40.0 45.0 50.0 55.0 60.0 70.0 90.0 100.0 120.0 150.0 160.0 180.0 200.0 220.0 250.0 280.0 300.0 320.0 350.0 380.0 400.0 420.0 450.0 480.0 500.0)

set DIMS    = (750)
set lambdas = (0 5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 100) #50 200 1000 8000 20000)
set out     = data
set exe     = an
set src     = anharmonicOBS.f90

unlimit stacksize
unlimit memorylocked
# gfortran -O2 $src -o $exe -llapack -lblas
ifort  -fast -parallel  -mkl=parallel  $src -o $exe
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
