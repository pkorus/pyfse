from libc.stdlib cimport malloc, free

cdef extern from "fse.h":

    size_t FSE_compress(void* dst, size_t dstCapacity, const void* src, size_t srcSize);

    size_t FSE_decompress(void* dst,  size_t dstCapacity, const void* cSrc, size_t cSrcSize);

    size_t FSE_compressBound(size_t size);

    unsigned FSE_isError(size_t code);

    const char* FSE_getErrorName(size_t code);

class FSEException(Exception):
    pass

class FSENotCompressibleError(FSEException):
    pass

class FSESymbolRepetitionError(FSEException):
    pass

def compress(src: bytes) -> bytes:
    """
    Compress bytes from 'src' and return FSE coded bytes.

    Returns: 
        A bytes object with encoded input data.

    Raises:
        FSENotCompressibleError  - input data is not compressible
        FSESymbolRepetitionError - input data is a repetition of a single byte - use RLE encoding instead
        FSEException             - other encoding errors (see message for details)
    """
    cdef unsigned int dst_size = FSE_compressBound(len(src))
    cdef unsigned char *dst = <unsigned char*> malloc(dst_size * sizeof(unsigned char))
    cdef unsigned char * src_ptr = src 
    ret = FSE_compress(dst, dst_size, src_ptr, len(src))

    if FSE_isError(ret):
        raise FSEException("Encoding Error: {}".format(FSE_getErrorName(ret)))
    elif ret == 0:
        raise FSENotCompressibleError("Encoding Error: data is not compressible")
    elif ret == 1:
        raise FSESymbolRepetitionError("Encoding Error: input data is a repetition of a single byte - use RLE encoding instead")

    output = bytes(dst[:ret]) # Converts the locally allocated buffer to a Python structure
    free(dst)
    return output

def decompress(src: bytes, max_length:int=0) -> bytes:
    """
    Decompress FSE-coded bytes. The output buffer is allocated according to the provided max_length.

    Returns:
        A bytes object with decoded data.

    Raises:
        FSEException             - various decoding errors (see message for details)
    """
    cdef unsigned int dst_size = 10 * len(src) if max_length == 0 else max_length
    cdef unsigned char *dst = <unsigned char*> malloc(dst_size * sizeof(unsigned char))
    cdef unsigned char * src_ptr = src 
    ret = FSE_decompress(dst, dst_size, src_ptr, len(src))

    if FSE_isError(ret):
        raise FSEException("Decoding Error: {}".format(FSE_getErrorName(ret)))

    output = bytes(dst[:ret]) # Converts the locally allocated buffer to a Python structure
    free(dst)
    return output
