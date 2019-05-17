import numpy as np
import pickle
import deepdish
from collections import Counter

import pyfse
import dahuffman

def shortstr(d, n=40):
    n2 = n // 2 - 2
    if len(d) > n:
        return ''.join((d[:n2].decode('utf8')) + ' .. ' + (d[-n2:].decode('utf8')))
    else:
        return str(d)

def entropy(p):
    if type(p) is not np.ndarray:
        p = np.array(list(p))
    return - float(np.sum(p * np.log2(p)))

input = b"Hello world, hello all, hello world, Hello, Hello, world, world" * 10
# input = bytes([1, 1, 2, 3, 4, 1, 2, 3, 2, 1, 1, 1, 1, 2, 2, 2, 1, 1, 3, 2, 4])
n = len(input)
n_show = 10

print('Input [{}]: {}'.format(len(input), shortstr(input)))

# Gather stats
input_stats = dict(Counter(input))
input_prob = {k: v/n for k, v in input_stats.items()}
input_entropy = entropy(input_prob.values())

print('Frequency stats:')
print('  Symbol probabilities: {}'.format({k: round(v, 2) for k, v in input_prob.items()}))
print('  Entropy: {:.2f}'.format(input_entropy))

# Python implementation of the Huffman codec
codec = dahuffman.HuffmanCodec.from_data(input_stats)
codec.print_code_table()
coded_huff = codec.encode(input)

print('Table: {}'.format(codec.get_code_table()))

print('Expected length: {:.1f} bytes'.format(len(input) * input_entropy / 8))
print('Huffman coded: {} bytes ({} including p. tables)'.format(len(coded_huff),
    len(pickle.dumps(codec.get_code_table())) + len(coded_huff)
))

# The ANS codec
coded_fse = pyfse.compress(input)
decoded_fse = pyfse.decompress(coded_fse)

print('FSE success: {}'.format(input == decoded_fse))
print('FSE coded: {} bytes (includes codec p. tables)'.format(len(coded_fse)))
print('FSE decoded [{}]: {}'.format(len(decoded_fse), shortstr(decoded_fse)))