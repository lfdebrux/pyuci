import unittest
import os.path
import uci

CONFDIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'config')


class TestUCI(unittest.TestCase):

    def setUp(self):
        self.c = uci.UCI(CONFDIR)

    def test_get_string(self):
        s = self.c.get('example', 'test', 'string')
        self.assertEqual(s, 'some value')

    def test_get_list(self):
        l = self.c.get('example', 'test', 'collection')
        self.assertEqual(l, ['first item', 'second item'])

if __name__ == '__main__':
    unittest.main()
