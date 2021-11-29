!     Get d1mach.f and i1mach.f from netlib.org, put them in
!     subdirectory blas. Then compile with the command:
!     f77 test_envirn.f blas/d1mach.f blas/i1mach.f -o test
!     and run
!     ./test
program testme
 implicit none
 integer ::  OUTCH
 real(8) ::  DWARF, MCHEPS
 real(8) ::  x
 integer ::  I1MACH !blas routines
 real(8) ::  D1MACH
 OUTCH  = I1MACH(2)
 MCHEPS = D1MACH(3)
 DWARF  = D1MACH(1)
 write(6,101)OUTCH,MCHEPS,DWARF,1.0D0+MCHEPS

 MCHEPS  = epsilon(x)/2.0D0
 DWARF   = tiny(x)
 write(6,101)OUTCH,MCHEPS,DWARF,1.0D0+MCHEPS

101 format(I4,3E30.18)
end program testme
