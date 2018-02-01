LIBS=

all: test_bin
	stack ghc -- -no-hs-main -optc-O -O2 -dynamic -shared -fPIC -o htesting.so utils.c src/Types.hs src/Lib.hs src/TH.hs -lHSrts-ghc8.2.2 -stubdir stub $(LIBS) 

test_bin: test.c
	gcc test.c -o test_bin -ldl
