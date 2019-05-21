from libc.stdlib cimport malloc, free

cdef extern from "fse.h":

    size_t FSE_compress(void* dst, size_t dstCapacity, const void* src, size_t srcSize);

    size_t FSE_decompress(void* dst,  size_t dstCapacity, const void* cSrc, size_t cSrcSize);

    size_t FSE_compressBound(size_t size);

    unsigned FSE_isError(size_t code);

    const char* FSE_getErrorName(size_t code);

def py_hello(name: bytes) -> None:
    print("Hello")

def easy_compress(src: bytes) -> bytes:
    cdef unsigned int dst_size = FSE_compressBound(len(src))
    cdef unsigned char *dst = <unsigned char*> malloc(dst_size * sizeof(unsigned char))
    cdef unsigned char * src_ptr = src 
    ret = FSE_compress(dst, dst_size, src_ptr, len(src))
    if FSE_isError(ret):
        raise ValueError("Encoding Error: {}".format(FSE_getErrorName(ret)))
    output_list = bytes(dst[:ret]) # Converts the locally allocated buffer to a Python structure
    free(dst)
    return output_list

def easy_decompress(src: bytes, max_length:int=0) -> bytes:
    cdef unsigned int dst_size = 10 * len(src) if max_length == 0 else max_length
    cdef unsigned char *dst = <unsigned char*> malloc(dst_size * sizeof(unsigned char))
    cdef unsigned char * src_ptr = src 
    ret = FSE_decompress(dst, dst_size, src_ptr, len(src))
    if FSE_isError(ret):
        raise ValueError("Decoding Error: {}".format(FSE_getErrorName(ret)))
    output_list = bytes(dst[:ret]) # Converts the locally allocated buffer to a Python structure
    free(dst)
    return output_list
