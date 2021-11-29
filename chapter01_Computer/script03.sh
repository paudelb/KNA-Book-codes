#!/bin/bash

files=(area_01.f90  area_02.f90  area_03.f90  area_04.f90)
R=(1.0 2.0 3.0 4.0 5.0 6.0 7.0 8.0 9.0 10.0)


echo "Hello $user Today is " `date`

for file in "${files[@]}"
do
    echo "# ----------- Working on file $file "
    gfortran $file -o area
    ./area <<EOF
${R[0]}
${R[1]}
${R[2]}
${R[3]}
${R[4]}
${R[5]}
${R[6]}
${R[7]}
${R[8]}
${R[9]}
EOF
 echo "# ----------- Done "
 if [ -f AREA.DAT ];
 then
  cat AREA.DAT
 fi
done
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
