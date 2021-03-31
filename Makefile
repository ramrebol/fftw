# makefile 31/03/2021

include template_mkmf

.DEFAULT:
	-touch $@
all:fftw_test

decimal.o: ./decimal.f90
	$(FC) $(FFLAGS) $(OTHERFLAGS) -c	./decimal.f90

fftw_module.o: ./fftw_module.f90 decimal.o
	$(FC) $(FFLAGS) $(OTHERFLAGS) -c	./fftw_module.f90

fftw_test.o: ./fftw_test.f90 fftw_module.o decimal.o
	$(FC) $(FFLAGS) $(OTHERFLAGS) -c	./fftw_test.f90

SRC = ./decimal.f90 ./fftw_module.f90 ./fftw_test.f90
OBJ = fftw_test.o fftw_module.o  decimal.o 
clean: neat
	-rm -f .cppdefs $(OBJ) ./fftw_test *.mod
neat:
	-rm -f $(TMPFILES)
TAGS: $(SRC)
	etags $(SRC)
tags: $(SRC)
	ctags $(SRC)
fftw_test: $(OBJ)
	$(LD) -o ./fftw_test $(OPTL) $(OBJ) $(LIBFFTW)
