'''
for a python class (e.g. Node)
    __init__ is called when initializing it
    __repr__ is called as representation
    __str__ is used to generate a string representation, take effect when calling str(node) to initialize it
    __eq__ is the reload of =
    __call__ is called when we call an instance, e.g. node()
'''

class Node:
    def __init__(self, value, children):
        self.value = value
        self.children = children
    def is_node(self):
        return True
    def is_leaf(self):
        return False
    def __repr__(self):
        return "Node ({}, [{}])".format(self.value, ",".join(map(str, self.children)))
    def __str__(self):
        return "Node ({}, [{}])".format(self.value, ",".join(map(str, self.children)))

class Leaf:
    def __init__(self, value):
        self.value = value
    def __repr__(self):
        return "Leaf {}".format(self.value)
    def __str__(self):
        return "Leaf {}".format(self.value)
    def is_node(self):
        return False
    def is_leaf(self):
        return True

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
    def is_terminal(self):
        return self.type == 'T'
    def is_nonterminal(self):
        return self.type == 'N'

example_tree = Node('root', [
                                Leaf ('1.1'), 
                                Node('1.2', [Leaf ('2.1'), Node ('2.2', [Leaf ('3.1')]), Leaf ('2.3')]), 
                                Leaf('1.3'), 
                                Node('1.4', [Leaf ('2.4')])
                            ]
                    )
naive_rules = {
    'SimpleExpr': [
                    [symbol('N', 'LeftExpr'), symbol('N', 'Binop'), symbol('N', 'RightExpr')],
                    [symbol('N', 'Num')]
                ],
    'Binop': [[symbol('T', "+")], [symbol('T', "-")], [symbol('T', "*")], [symbol('T', "/")]],
    'LeftExpr': [
                    [symbol('N', 'Num')],
                    [symbol('T', "("), symbol('N', 'Num'), symbol('N', 'Binop'), symbol('N', 'Num'), symbol('T', ")")]
                ],
    'RightExpr': [
                    [symbol('N', 'Num')],
                    [symbol('T', "("), symbol('N', 'Num'), symbol('N', 'Binop'), symbol('N', 'Num'), symbol('T', ")")]
                ],
    'Num': [[symbol('T', "0")], [symbol('T', "1")], [symbol('T', "2")], [symbol('T', "3")], [symbol('T', "4")], 
            [symbol('T', "5")], [symbol('T', "6")], [symbol('T', "7")], [symbol('T', "8")], [symbol('T', "9")]]
}

naive_grammar = (
        'SimpleExpr',
        naive_rules
    )

def PreorderTraversal(tree):
    '''
    visit Root first, then Children from left to right
    '''
    if tree.is_leaf():
        return [tree.value]
    else:
        result = [tree.value]
        for child in tree.children:
            result += PreorderTraversal(child)
        return result

def PostorderTraversal(tree):
    '''
    visit Children from left to right, then Root
    '''
    if tree.is_leaf():
        return [tree.value]
    else:
        result = []
        for child in tree.children:
            result += PostorderTraversal(child)
        result.append(tree.value)
        return result

def example_function(x, y=None):
    if y is None:
        return lambda y: example_function(x, y)
    else:
        return x + y

def print_list(terminate_symbols):
    print("".join(terminate_symbols))

def brutal_force_expand(rules, symbol_list, terminate_prefix):
    if len(symbol_list) == 0:
        # reached the end of the symbol list
        print_list(terminate_prefix)
    else:
        first_symbol = symbol_list[0]
        rest_symbols = symbol_list[1:]
        if first_symbol.is_terminal():
            brutal_force_expand(rules, rest_symbols, terminate_prefix+[first_symbol()])
        else:
            right_hand_side_list = rules[first_symbol()]
            for rhs in right_hand_side_list:
                brutal_force_expand(rules, rhs + rest_symbols, terminate_prefix)

if __name__ == '__main__':
    print("depth-first traversals:")
    print("note that I used the terms pre-order and post-order INACCURATELY - \n \
    these terms should be used ONLY for BINARY trees (all nodes at most 2 children) \n \
    please DONOT mess-up the concepts.")
    print("pre-order style (root-first):",PreorderTraversal(example_tree))
    print("post-order style (child-first)",PostorderTraversal(example_tree))
    print("explaination of the idea of currying:")
    print("example_function(2,3)={}".format(example_function(2,3)))
    print("example_function(2)(3)={}".format(example_function(2)(3)))
    print("silly example of generating all possible expressions\
    Becareful: you CAN'T use this logic in your code - WHY? (infinite loop / functional expression)")
    start_symbol = naive_grammar[0]
    rules = naive_grammar[1]
    brutal_force_expand(rules, [symbol('N', start_symbol)], [])







