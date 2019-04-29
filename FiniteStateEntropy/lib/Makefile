CC = gcc

default: libfse.a

libfse.a: fse_compress.o fse_decompress.o entropy_common.o hist.o
	ar rcs $@ $^
    
fse.o: fse.h
	$(CC) -c fse_compress.c fse_decompress.c entropy_common.c hist.c

clean:
	rm *.o *.a
