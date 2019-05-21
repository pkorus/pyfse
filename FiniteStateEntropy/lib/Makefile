CC_FLAGS := -c -fPIC
CC = gcc

libfse.a: fse_compress.o fse_decompress.o entropy_common.o hist.o
	ar rcs $@ $^
    
%.o: %.c
	$(CC) $(CC_FLAGS) -o $@ $<

clean:
	rm *.o *.a
