# ########################   Makefile  ############################
# $@ target, $< first dependency, $^ all dependencies, 
# $* "stem" of target filename e.g. %.f: %.F will five foo for foo.f
FC     =  gfortran
OBJS   =  global_data.o getopt.o main.o init.o met.o wolff.o measure.o end.o options.o ranlux.o 
FFLAGS = -O2

is: $(OBJS)
	$(FC) $(FFLAGS) $^ -o $@

$(OBJS):   global_data.f90
options.o: getopt.f90
%.o: %.f90
	$(FC) $(FFLAGS)   -c -o $@ $<

getopt_m.mod: getopt.f90 getopt.o
	@true  #true is a command that does nothing
global_data.mod: global_data.f90 global_data.o
	@true
clean:
	/bin/rm -f *.o is core* *.mod

