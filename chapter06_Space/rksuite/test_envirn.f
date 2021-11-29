C     Get d1mach.f and i1mach.f from netlib.org, put them in
C     subdirectory blas. Then compile with the command:
C     f77 test_envirn.f blas/d1mach.f blas/i1mach.f -o test
C     and run
C     ./test

      program testme
      implicit none
      integer i,OUTCH
      double precision f,fi
      DOUBLE PRECISION  DWARF, MCHEPS
      INTEGER           I1MACH !blas routines
      DOUBLE PRECISION  D1MACH


      MCHEPS = 1.11D-16
      print *,'MCHEPS 100000   = ',1.0D0+100000.0D0  *MCHEPS
      print *,'MCHEPS 10000    = ',1.0D0+10000.0D0   *MCHEPS
      print *,'MCHEPS 1000     = ',1.0D0+1000.0D0    *MCHEPS
      print *,'MCHEPS 100      = ',1.0D0+100.0D0     *MCHEPS
      print *,'MCHEPS 10       = ',1.0D0+10.0D0      *MCHEPS
      print *,'MCHEPS 3   = ',1.0D0+3.0D0  *MCHEPS
      print *,'MCHEPS 2   = ',1.0D0+2.0D0  *MCHEPS
      print *,'MCHEPS 1   = ',1.0D0+1.0D0  *MCHEPS
      print *,'MCHEPS .1  = ',1.0D0+0.1D0  *MCHEPS
      print *,'MCHEPS .01 = ',1.0D0+0.01D0 *MCHEPS
      print *,'MCHEPS .001= ',1.0D0+0.001D0*MCHEPS

      DWARF = 2.23D-308
      print *,'DWARF 3      = ',3.0D0  *DWARF
      print *,'DWARF 2      = ',2.0D0  *DWARF
      print *,'DWARF 1      = ',1.0D0  *DWARF
      print *,'DWARF .1     = ',0.1D0  *DWARF
      print *,'DWARF .01    = ',0.01D0 *DWARF
      print *,'DWARF .001   = ',0.001D0*DWARF


      print *,'==================================================='
      MCHEPS = 1.11D-16
      MCHEPS = 1.111D-16
      DWARF = 2.23D-308
      f  = 1.0D0
      fi = 1.0D0
      do i=1,18
       write(6,100)i,' f=  ',f ,1.0D0+f *MCHEPS,
     $      (1.0D0+f *MCHEPS) - 1.0D0,f *DWARF
       write(6,100)i,' fi= ',fi,1.0D0+fi*MCHEPS,
     $      (1.0D0+fi*MCHEPS) - 1.0D0,fi*DWARF
       f  = f *10.0D0
       fi = fi/10.0D0
      enddo

C     Now we call blas routines if we have them:
      print *,'==================================================='

      OUTCH = I1MACH(2)
      MCHEPS = D1MACH(3)
      DWARF = D1MACH(1)
      write(6,101)OUTCH,MCHEPS,DWARF
 100  format(I4,A6,E15.8,3E30.18)
 101  format(I4,2E30.18)
      end

 
