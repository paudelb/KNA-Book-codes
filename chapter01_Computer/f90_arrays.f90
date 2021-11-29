

program arrays
 implicit none
 INTERFACE
  subroutine parray(b)
   real :: b(:,:)
   integer i,j
  end subroutine parray
 END INTERFACE
 integer :: i,j,n,m
 real    :: a(3), b(3,3), c(3,3)=-99.0, d(3,3)=-99.0, s
 integer :: semester(1000),grade(1000)
 logical :: pass(1000)
 !construct the matrix: use the RESHAPE function
 !|1.1 -1.2 -1.3|
 !|2.1  2.2 -2.3|
 !|3.1  3.2  3.3|
 b = RESHAPE((/  1.1,  2.1,  3.1, & !(notice rows<->columns)
                -1.2,  2.2,  3.2, &
                -1.3, -2.3,  3.3  /),(/3,3/))
 call parray(b)
 !same matrix, now exchange rows and columns: ORDER=(/2,1/)
 b = RESHAPE((/  1.2, -1.2, -1.3, &
                 2.1,  2.2, -2.3, &
                 3.1,  3.2,  3.3  /),(/3,3/),ORDER=(/2,1/))
 call parray(b)
 a = b(:,2) !a assigned the second column of b: a(i)=b(i,2)
 print *,'a(i)=b(i,2)=',a
 a = b(1,:) !a assigned the first  row    of b: a(i)=b(1,i)
 print *,'a(i)=b(1,i)=',a
 a = 2.0*b(:,3)+sin(b(2,:))!a(i) = 2*b(i,3)+sin(b(2,i))
 print *,'a(i)=       ',a
 a = 1.0+2.0*exp(-a)+b(:,3)!a(i) = 1+2*exp(-a(i))+b(i,3)
 print *,'a(i)=       ',a
 print *,'--------------------'
 s = SUM(b)                !returns sum of all      elements of b
 print *,'sa= ',s
 s = SUM(b,MASK=(b.gt.0))  !returns sum of positive elements of b
 print *,'sp= ',s
 a = SUM(b,DIM=1)          !each a(i) is the sum of the columns of b
 print *,'ac= ',a
 a = SUM(b,DIM=2)          !each a(i) is the sum of the rows    of b
 print *,'ar= ',a
 !repeat all the above using PRODUCT!
 !all instructions may be executed in parallel at any order... careful
 FORALL(i=1:3) c(i,i) = a(i) !set the diagonal of c 
 !compute upper bounds of indices in b:
 n=UBOUND(b,DIM=1);m=UBOUND(b,DIM=2) 
 !log needs positive argument, add a restriction ("mask")
 FORALL(i=1:n,j=1:m, b(i,j).gt.0.0 ) c(i,j) = log(b(i,j))
 call parray(c)
 !upper triangular part of matrix: careful, j=i+1:m NOT permitted
 FORALL(i=1:n,j=1:m, i     .lt.  j ) c(i,j) = b(i,j)
 call parray(c)
 !each statement executed BEFORE the next one!
 FORALL(i=2:n-1,j=2:n-1) 
  !all right hand side evaluated BEFORE the assignment
  !i.e., the OLD values of b averaged and then assigned to b
  b(i,j)=(b(i+1,j)+b(i-1,j)+b(i,j+1)+b(i,j-1))/4.0 
  c(i,j)=1.0/b(i+1,j+1) !the NEW values of b are assigned
 END FORALL
 ! assignment but only for elements  b(i,j) which are not  0
 WHERE (b     .ne. 0.0)              c      = 1.0/b
 call parray(c)
 !MATMUL(b,c) is evaluated, then d is assigned the result only
 !at positions where b>0.
 WHERE (b     .gt. 0.0)              d      = MATMUL(b,c)
 call parray(d)
 WHERE (grade .ge. 5  )
  semester = semester + 1 !student's semester increases by 1
  pass     = .true.
 ELSEWHERE
  pass     = .false.
 END WHERE
end program arrays

subroutine parray(b)
 real :: b(:,:)
 integer i,j
 print *,'# -----------------------------------------'
 do i=LBOUND(b,DIM=1),UBOUND(b,DIM=1)
  print ('(1000F6.1)'),( b(i,j),j=LBOUND(b,DIM=2),UBOUND(b,DIM=2))
 enddo
 print *,'# -----------------------------------------'
end subroutine parray
!  ---------------------------------------------------------------------
!  Copyright by Konstantinos N. Anagnostopoulos (2004-2014)
!  Physics Dept., National Technical University,
!  konstant@mail.ntua.gr, www.physics.ntua.gr/~konstant
!  
!  This program is free software: you can redistribute it and/or modify
!  it under the terms of the GNU General Public License as published by
!  the Free Software Foundation, version 3 of the License.
!  
!  This program is distributed in the hope that it will be useful, but
!  WITHOUT ANY WARRANTY; without even the implied warranty of
!  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
!  General Public License for more details.
!  
!  You should have received a copy of the GNU General Public Liense along
!  with this program.  If not, see <http://www.gnu.org/licenses/>.
!  -----------------------------------------------------------------------
