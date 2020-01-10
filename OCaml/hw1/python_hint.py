########################################################################
# For whoever new to Python: 
#     you may use this as pseudo code
#     it is not mandatory to use hint code
# Usage:
#     python python_hint.py
# To all students:
#     try implementing everything without the help from hint-code first
# Fall 2019 by Patricia Xiao
########################################################################

from math import *

def subset(a, b):
    '''
    check if a is a subset of b
    parameters: 
        a: list (representing a set)
        b: list
    return:
        boolean
    sample usage: subset([1,2], [1,2,3,4,5])
        # output: True  
    '''
    if len(a) == 0:
        return True
    else:
        if a[0] not in b:
            return False
        else:
            return subset(a[1:], b)

def equal_sets(a, b):
    '''
    check if the sets represented by two lists are equivalent
    parameters:
        a: list
        b: list
    return:
        boolean
    sample usage: equal_sets([1,2,3,4,5], [1,1,1,1,1,2,3,4,5])
        # output: True
    '''
    return subset(a, b) and subset(b, a)

def set_diff(a, b):
    '''
    parameters:
        a: list
        b: list
    return:
        a - b (as set)
    sample usage: set_diff([1,2,3,4,5], [1,2])
        # output: [3, 4, 5]
    '''
    if len(a) == 0:
        return []
    else:
        if a[0] in b:
            return set_diff(a[1:], b)
        else:
            return [a[0]] + set_diff(a[1:], b)

def set_union(a, b):
    '''
    parameters:
        a: list
        b: list
    return:
        boolean
    sample usage: set_union([1,2], [3, 4])
        # output: [1, 2, 3, 4]
    '''
    return a + set_diff(b, a)

def computed_fixed_point(eq, f, x):
    '''
    parameters:
        eq: a function (predicate) determining whether or not two inputs are equal
        f: the target function to compute the fixed point for
        x: the starting point of computing fixed point
    return: the computed fixed point for f with respect to x, 
        assuming that eq is the equality predicate for f's domain
    sample usage:
        computed_fixed_point((lambda x, y: x == y), (lambda x: x / 2 + 0.5), 1)
        # outputs: 1
    '''
    if eq(f(x), x):
        return x
    else:
        return computed_fixed_point(eq, f, f(x))

class symbol:
    def __init__(self, _type, _val):
        assert(_type in ['T', 'N'])
        self.type = _type
        self.value = _val
    def __call__(self):
        return self.value
    def __repr__(self):
        return "symbol {}: {}".format(self.type, self.value)
    def __eq__(self, other):
        return self.value == other.value and self.type == other.type 

sample_rules = [
    (symbol('N', 'Expr'), [symbol('T', "("), symbol('N', 'Expr'), symbol('T',")")]),
    (symbol('N', 'Expr'), [symbol('N', 'Num')]),
    (symbol('N', 'Expr'), [symbol('N', 'Expr'), symbol('N', 'Binop'), symbol('N', 'Expr')]),
    (symbol('N', 'Expr'), [symbol('N', 'Lvalue')]),
    (symbol('N', 'Expr'), [symbol('N', 'Incrop'), symbol('N', 'Lvalue')]),
    (symbol('N', 'Expr'), [symbol('N', 'Lvalue'), symbol('N', 'Incrop')]),
    (symbol('N', 'Lvalue'), [symbol('T', "$"), symbol('N', 'Expr')]),
    (symbol('N', 'Incrop'), [symbol('T', "++")]),
    (symbol('N', 'Incrop'), [symbol('T', "--")]),
    (symbol('N', 'Binop'), [symbol('T',"+")]),
    (symbol('N', 'Binop'), [symbol('T',"-")]),
    (symbol('N', 'Num'), [symbol('T', "0")]),
    (symbol('N', 'Num'), [symbol('T', "1")]),
    (symbol('N', 'Num'), [symbol('T', "2")]),
    (symbol('N', 'Num'), [symbol('T', "3")]),
    (symbol('N', 'Num'), [symbol('T', "4")]),
    (symbol('N', 'Num'), [symbol('T', "5")]),
    (symbol('N', 'Num'), [symbol('T', "6")]),
    (symbol('N', 'Num'), [symbol('T', "7")]),
    (symbol('N', 'Num'), [symbol('T', "8")]),
    (symbol('N', 'Num'), [symbol('T', "9")])]

sample_grammar = (symbol('N', 'Expr'), sample_rules[2:])


def equal_second_elem_sets(a, b):
    return equal_sets(a[1], b[1])

def get_reachable_symbols(params):
    rules, reachable_symbols = params
    if len(rules) == 0:
        return (rules, reachable_symbols)
    else:
        tmp_rule = rules[0]
        rest_rules = rules[1:]
        tmp_symbol = tmp_rule[0]
        right_hand_side = tmp_rule[1]
        if tmp_symbol in reachable_symbols:
            nonterminal = list(filter(lambda s: s.type == 'N', right_hand_side))
            return get_reachable_symbols((rest_rules, set_union(reachable_symbols, nonterminal)))
        else:
            return get_reachable_symbols((rest_rules, reachable_symbols))


def filter_reachable(g):
    '''
    keep only the reachable rules in grammar g
    parameters:
        g: a pair, first element is a symbol, second element is a list of rules
    return:
        grammar after filtered the symbols
    sample usage: filter_reachable(sample_grammar)
    '''
    start_symbol = g[0]
    rules = g[1]
    # step 1: find the reachable symbols
    _, reachable_symbols = computed_fixed_point(equal_second_elem_sets, get_reachable_symbols, (rules, [start_symbol]))
    # step 2: filter the rules
    filtered_rules = list(filter(lambda r: r[0] in reachable_symbols, rules))
    return (start_symbol, filtered_rules)


if __name__ == '__main__':
    print(filter_reachable(sample_grammar))
