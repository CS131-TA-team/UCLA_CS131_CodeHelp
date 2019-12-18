'''
This is a hint from matcher to parser

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
        return str(self.value)
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
    'Expr': [
                    [symbol('T', "("), symbol('N', 'Expr'), symbol('N', 'Binop'), symbol('N', 'Expr'), symbol('T', ")")],
                    [symbol('N', 'Num')]
                ],
    'Binop': [[symbol('T', "+")], [symbol('T', "-")], [symbol('T', "*")], [symbol('T', "/")]],
    'Num': [[symbol('T', "0")], [symbol('T', "1")], [symbol('T', "2")], [symbol('T', "3")], [symbol('T', "4")], 
            [symbol('T', "5")], [symbol('T', "6")], [symbol('T', "7")], [symbol('T', "8")], [symbol('T', "9")]]
}

start_symbol = 'Expr'

naive_grammar = (
        start_symbol,
        naive_rules
    )

# (2 + (6 - 3))
rules_record = [
    ('Expr', [symbol('T', "("), symbol('N', 'Expr'), symbol('N', 'Binop'), symbol('N', 'Expr'), symbol('T', ")")]),
    ('Expr', [symbol('N', 'Num')]),
    ('Num', [symbol('T', "2")]),
    ('Binop', [symbol('T', "+")]),
    ('Expr', [symbol('T', "("), symbol('N', 'Expr'), symbol('N', 'Binop'), symbol('N', 'Expr'), symbol('T', ")")]),
    ('Expr', [symbol('N', 'Num')]),
    ('Num', [symbol('T', "6")]),
    ('Binop', [symbol('T', "-")]),
    ('Expr', [symbol('N', 'Num')]),
    ('Num', [symbol('T', "3")])
]
rhs_record = [
    [symbol('T', "("), symbol('N', 'Expr'), symbol('N', 'Binop'), symbol('N', 'Expr'), symbol('T', ")")],
    [symbol('N', 'Num')],
    [symbol('T', "2")],
    [symbol('T', "+")],
    [symbol('T', "("), symbol('N', 'Expr'), symbol('N', 'Binop'), symbol('N', 'Expr'), symbol('T', ")")],
    [symbol('N', 'Num')],
    [symbol('T', "6")],
    [symbol('T', "-")],
    [symbol('N', 'Num')],
    [symbol('T', "3")]
]

def rhs2children(rhs):
    children = []
    for sym in rhs:
        if sym.is_terminal():
            children.append( Leaf(sym()) )
        else:
            children.append( Node(sym(), []) )
    return children

def constructing_tree(rhs_traced, temp_root):
    if temp_root.is_node() and len(rhs_traced) > 0:
        # if this is a node, need to expand its child and remove one rule from the traced list
        tmp_rhs = rhs_traced[0]
        rhs_traced = rhs_traced[1:]
        temp_root.children = rhs2children(tmp_rhs)
        for i in range(len(temp_root.children)):
            (rhs_traced, temp_root.children[i]) = constructing_tree(rhs_traced, temp_root.children[i])
    return (rhs_traced, temp_root)


def print_a_tree(tree, level_indent=0):
    '''
    this function is for elegant printing only
    never needed for OCaml
    '''
    print_indent = level_indent * "    "
    tmp_value = tree.value
    print("{}{}".format(print_indent, tmp_value))
    if tree.is_node():
        children_level = level_indent + 1
        for child in tree.children:
            print_a_tree(child, children_level)
def print_rule_list(rule_list):
    '''
    again, only for beautiful printing
    '''
    for rule in rule_list:
        print("{} -> {}".format(rule[0], rule[1]))
def print_rhs_list(rhs_list):
    '''
    again, only for printing in python
    '''
    for rhs in rhs_list:
        print(rhs)

if __name__ == '__main__':
    print("If we know that the order of rules used for expanding the start_symbol all the way until the fragment?\n"
          "For example, the rules we've used to expand the symbol list starting with the staring-symbol is:\n")
    print_rule_list(rules_record)
    print("\nAnd obviously, the corresponding right-hand-side list is:\n")
    print_rhs_list(rhs_record)
    print("\nWe are able to reconstruct the tree easily:\n")
    (_, tree) = constructing_tree(rhs_record, Node(start_symbol, []))
    print_a_tree(tree)
    print("\nBut remember that this is not the OCaml way of solving problems (e.g. loop is not allowed).")
    print("Plus, this is not the only way out. This helper function is not necessarily used. DONOT be restricted.\n")







