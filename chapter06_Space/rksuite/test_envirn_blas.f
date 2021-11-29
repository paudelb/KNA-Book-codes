C     Get d1mach.f and i1mach.f from netlib.org, put them in
C     subdirectory blas. Then compile with the command:
C     f77 test_envirn.f blas/d1mach.f blas/i1mach.f -o test
C     and run
C     ./test
      program testme
      implicit none
      integer OUTCH
      DOUBLE PRECISION  DWARF, MCHEPS
      INTEGER           I1MACH !blas routines
      DOUBLE PRECISION  D1MACH
      OUTCH = I1MACH(2)
      MCHEPS = D1MACH(3)
      DWARF = D1MACH(1)
      write(6,101)OUTCH,MCHEPS,DWARF
 101  format(I4,2E30.18)
      end
