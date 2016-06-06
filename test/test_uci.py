import unittest
import os.path
import uci

CONFDIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'config')


class TestUCI(unittest.TestCase):

    def setUp(self):
        self.c = uci.UCI(CONFDIR)

    def test_no_config(self):
        self.assertRaises(uci.NoConfigError, self.c.get, 'foo', 'bar', 'baz')

    def test_no_section(self):
        self.assertRaises(uci.NoSectionError, self.c.get,
                          'example', 'bar', 'baz')

    def test_no_option(self):
        self.assertRaises(uci.NoOptionError, self.c.get,
                          'example', 'test', 'baz')

    def test_none_argument(self):
        self.assertRaises(TypeError, self.c.get, None, None, None)

    def test_sections(self):
        self.assertEqual(self.c.sections('example'), ['test'])

    def test_has_section(self):
        self.assertTrue(self.c.has_section('example', 'test'))
        self.assertFalse(self.c.has_section('example', 'bar'))

    def test_options(self):
        self.assertEqual(
                         self.c.options('example', 'test'),
                         ['string', 'boolean', 'collection'])

    def test_has_option(self):
        self.assertTrue(self.c.has_option('example', 'test', 'string'))
        self.assertFalse(self.c.has_option('example', 'test', 'baz'))

    def test_items(self):
        self.assertEqual(
                         self.c.items('example', 'test'),
                         [('string', 'some value'),
                          ('boolean', '1'),
                          ('collection', ['first item', 'second item'])])

    def test_get_string(self):
        s = self.c.get('example', 'test', 'string')
        self.assertEqual(s, 'some value')

    def test_get_list(self):
        l = self.c.get('example', 'test', 'collection')
        self.assertEqual(l, ['first item', 'second item'])

if __name__ == '__main__':
    unittest.main()
