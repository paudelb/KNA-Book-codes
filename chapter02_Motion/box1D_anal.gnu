set log x
set log y
set xlabel "{/Symbol d}t"
set ylabel "{/Symbol d}x (%)"
xerror(x,y) = (x>=y)?(200*(x-y)/(x+y)):(200*(y-x)/(x+y))
# -------------------------------------------
set key bottom right
set term qt
plot [1e-5:0.1][0.0001:100] \
     "box1D_anal.dat" u 2:(xerror($4 ,$8 )) w p ps 2  t "method 1",\
     "box1D_anal.dat" u 2:(xerror($6 ,$8 )) w p ps 2  t "method 2"
set term postscript color enhanced eps  24
set out "box1D_anal_err_1.eps"
replot
set out
# -------------------------------------------
set key bottom left
set term qt
plot [1e-5:0.1][0.0001:100] \
     "box1D_anal.dat" u 2:(xerror($10,$14)) w p ps 2 t "method 3",\
     "box1D_anal.dat" u 2:(xerror($12,$14)) w p ps 2 t "method 4"
set term postscript color enhanced eps 24
set out "box1D_anal_err_2.eps"
replot
set out
# -------------------------------------------
# -------------------------------------------
set key bottom right
set term qt
plot [1e-5:0.1][0.0001:100] \
     "box1D_anal.dat" u 2:(xerror($4 ,5  )) w p ps 2  t "method 1",\
     "box1D_anal.dat" u 2:(xerror($6 ,5  )) w p ps 2  t "method 2",\
     "box1D_anal.dat" u 2:(xerror($8 ,5  )) w p ps 2 t "accurate"
set term postscript color enhanced eps  24
set out "box1D_anal_err_3.eps"
replot
set out
# -------------------------------------------
set key bottom left
set term qt
plot [1e-5:0.1][0.000001:1000] \
     "box1D_anal.dat" u 2:(xerror($10,5  )) w p ps 2 t "method 3",\
     "box1D_anal.dat" u 2:(xerror($12,5  )) w p ps 2 t "method 4",\
     "box1D_anal.dat" u 2:(xerror($14,5  )) w p ps 2 t "accurate"
set term postscript color enhanced eps 24
set out "box1D_anal_err_4.eps"
replot
set out
# -------------------------------------------
set term qt
set xlabel ""
set ylabel ""
unset log x
unset log y
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
