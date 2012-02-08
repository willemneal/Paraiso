all: lib kh-cuda.out

kh-cuda.out: main-kh.cu  dist-cuda/Hydro.cu
	nvcc --ptx dist-cuda/Hydro.cu -O3  -Idist-cuda/  -o dist-cuda/Hydro.ptx -arch=sm_20 &
	nvcc main-kh.cu dist-cuda/Hydro.cu -O3   -Idist-cuda/ -o kh-cuda.out -arch=sm_20

dist-cuda/Hydro.cu:lib

lib:
	ghc -i../../ --make -O3  -fspec-constr-count=42 HydroMain.hs
	time ./HydroMain

recomp:
	ghc  -i../../ --make -O3 HydroMain.hs -fforce-recomp \
	-fspec-constr-count=16


clean:
	rm -fr *.o
	rm -fr *.out
	rm -fr dist/
	rm -f output/*.*

massive-test: lib
	nvcc massive-test.cu dist-cuda/Hydro.cu -O3 -Idist-cuda/ -o massive-test.out -arch=sm_20
	time ./massive-test.out