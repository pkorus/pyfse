import unittest
import pyfse
import utils


class EasyTest(unittest.TestCase):

    @classmethod
    def setUpClass(cls) -> None:
        EasyTest.inputs = {}

        with open('tests/string.txt') as f:
            EasyTest.inputs['ascii'] = f.read().encode('ascii')

        with open('tests/all_zeros.dat') as f:
            EasyTest.inputs['all_zeros'] = bytes([int(x) for x in f.read().strip()])

        with open('tests/binary.dat') as f:
            EasyTest.inputs['binary'] = bytes([int(x) for x in f.read()])

        with open('tests/numbers.dat') as f:
            EasyTest.inputs['numbers'] = bytes([127 + int(x) for x in f.read().split(', ')])

    def process_input(self, key):
        input = EasyTest.inputs[key]
        input_prob = utils.symbol_probabilities(input)
        input_entropy = utils.entropy(input_prob.values())

        print('\n# Test: {}'.format(key))
        print('Input size:             {:,} symbols'.format(len(input)))
        print('Entropy:                {:.2f}'.format(input_entropy))

        coded_fse = pyfse.compress(input)
        decoded_fse = pyfse.decompress(coded_fse)

        # Check if the coded stream is within 10% of the entropy
        self.assertLessEqual(len(coded_fse), 1.1 * len(input) * input_entropy / 8)
        self.assertGreaterEqual(len(coded_fse), len(input) * input_entropy / 8)

        self.assertTrue(input == decoded_fse)

        limit = len(input) * input_entropy / 8

        print('Theoretical limit:      {:,.1f} bytes'.format(limit))
        print('FSE coded stream:       {:,} bytes [{:.0f}%]'.format(len(coded_fse), 100 * len(coded_fse) / limit))
        print('Decoded stream equal?:  {}'.format(input == decoded_fse))

    def test_ascii(self):
        self.process_input('ascii')

    def test_numbers(self):
        self.process_input('numbers')

    def test_binary(self):
        self.process_input('binary')

    def test_all_zeros(self):
        self.assertRaises(pyfse.FSESymbolRepetitionError, lambda : self.process_input('all_zeros'))
