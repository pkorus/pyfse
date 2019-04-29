import pyfse

input = b"Hello world, hello all, hello world, Hello, Hello, world, world"
input = bytes([1, 1, 2, 3, 4, 1, 2, 3, 2, 1, 1, 1, 1, 2, 2, 2, 1, 1, 3, 2, 4])

out_c = pyfse.compress(input)
out_d = pyfse.decompress(out_c)

print('Input: {} ({}) --> {}'.format(input, len(input), list(input)))
print('Compressor out ({}): {}'.format(len(out_c), list(out_c)))
print('De-compressor out ({}): {}'.format(len(out_d), list(out_d)))
print('De-out: {}'.format(out_d))