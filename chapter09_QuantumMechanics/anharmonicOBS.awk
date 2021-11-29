#!/bin/awk -f 

BEGIN{ nmax = 9;OFMT="%.17g";CONVFMT="%.17g"}

/^avX2/ && $3 == 0.5 { for(n=0;n<=nmax;n++){avX2[1,n] = $(n+4)} }
/^avP2/ && $3 == 0.5 { for(n=0;n<=nmax;n++){avP2[1,n] = $(n+4)} }
/^DxDp/ && $3 == 0.5 { for(n=0;n<=nmax;n++){DxDp[1,n] = $(n+4)} }
/^avX2/ && $3 == 2.0 { for(n=0;n<=nmax;n++){avX2[2,n] = $(n+4)} }
/^avP2/ && $3 == 2.0 { for(n=0;n<=nmax;n++){avP2[2,n] = $(n+4)} }
/^DxDp/ && $3 == 2.0 { for(n=0;n<=nmax;n++){DxDp[2,n] = $(n+4)} }



END{ 
    for(n=0;n<=nmax;n++){printf("%d& %8.6g& %8.6g& %8.6g& %8.6g& %8.6g& %8.6g\\\\\n",n,avX2[1,n],avP2[1,n],DxDp[1,n],avX2[2,n],avP2[2,n],DxDp[2,n]);}
}
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
