# Python FSE

This repository contains simple Cython wrappers for the [finite state entropy (FSE)](https://github.com/Cyan4973/FiniteStateEntropy) codec.

## Setup

```
> git clone https://github.com/pkorus/pyfse
> cd pyfse
> pip3 install cython
> make
> python3 -m unittest -q
```

## Usage

The wrapper implements only the basic `compress` & `decompress` functions from the original codec. Both functions operate on `bytes` objects:

```python
import pyfse
x = bytes([x % 3 for x in range(100)])
y = pyfse.compress(x)
X = pyfse.decompress(y)
x == X
```

There is also a simple demo script to show a text coding example.

```
> python3 -m unittest -q
```