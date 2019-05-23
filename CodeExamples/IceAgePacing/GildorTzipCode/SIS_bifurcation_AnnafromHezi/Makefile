# adva (alpha):
# -------------
# witn adva, do not use -i8 compilation flag with Nag!!!
FORTRAN=g77
FLAGS=   -O2 -C -c -fbounds-check # for adva:  -fast -r8 -convert big_endian 
#FLAGS= -C -g2 -O0 -r8  # -convert big_endian 
LIBS= /usr/local/lib/libnag.a

all: Output/SIS_bifurcation.exe Output/insolation.exe

Output/SIS_bifurcation.exe: Output/SIS_bifurcation.o SIS_bifurcation.h Output/insolation.o
	F -o Output/SIS_bifurcation.exe Output/SIS_bifurcation.o Output/insolation.o ${LIBS}
Output/insolation.exe: Output/insolation.o Output/insolation_main.o
	F -o Output/insolation.exe Output/insolation.o Output/insolation_main.o ${LIBS}
Output/SIS_bifurcation.o: SIS_bifurcation.f SIS_bifurcation.h
	g77 ${FLAGS} -c SIS_bifurcation.f; \mv SIS_bifurcation.o Output/
Output/insolation.o: insolation.f
	g77 ${FLAGS} -c insolation_main.f insolation.f; \mv insolation.o Output/
Output/insolation_main.o: insolation_main.f
	g77 ${FLAGS} -c insolation_main.f; \mv insolation_main.o Output/
