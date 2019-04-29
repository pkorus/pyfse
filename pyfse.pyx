cdef extern from "fse.h":

    size_t FSE_compress(void* dst, size_t dstCapacity, const void* src, size_t srcSize);

    size_t FSE_decompress(void* dst,  size_t dstCapacity, const void* cSrc, size_t cSrcSize);

def py_hello(name: bytes) -> None:
    print("Hello")

def compress(src: bytes) -> bytes:
    print("Compressing", src)
    cdef unsigned char dst[2000]
    cdef unsigned char * src_ptr = src 
    dst[0] = 10
    print("Init dst", dst)
    ret = FSE_compress(&dst, 2000, src_ptr, len(src))
    print('Comp ret: ', ret)
    print('Comp out: ', dst)
    return dst

def decompress(src: bytes) -> bytes:
    print("Decompressing", src)
    cdef unsigned char dst[10]
    cdef unsigned char * src_ptr = src 
    dst[0] = 12
    dst[1] = 0
    print("Init dst", dst)
    ret = FSE_decompress(&dst, 10, src_ptr, len(src))
    if ret == 0:
        raise ValueError("Error")
    dst[ret] = 0
    print('Decomp ret: ', ret)
    print('Decomp out: ', dst)
    return dst
