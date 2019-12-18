'''
python example on dictionary and class usages and important tricks
'''

# nevermind this is my tool to make beautiful print, you don't need it
# but I also use this as an example to show you how simple class works
# notice the difference between variables of a class and variables of an object
# notice the special function's usage
# in fact, (object) is optional in syntax since it is by default an object already
# we can simply do:
# class Colors: 
# and it works exactly the same way
class Colors(object):
    # these are the values of the whole class
    # it means that you have access to them after you define the class
    # you don't have to call them through any instance (object)
    PURPLE = '\033[95m'
    CYAN = '\033[96m'
    DARKCYAN = '\033[36m'
    BLUE = '\033[94m'
    GREEN = '\033[92m'
    YELLOW = '\033[93m'
    RED = '\033[91m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'
    END = '\033[0m'
    # here are some of the special methods of a python class
    def __init__(self, name=None):
        '''
        the initialize function is called whenever we initialize an object of this class
        called when, e.g. 
            color = Colors("my colors")
        note that name has default value (None), so name is optional
        if we receive name, name is a field of this object we are initializing, not the whole class
        '''
        self.name = name
    def __repr__(self):
        '''
        observed when calling from interpreter directly
        for example, with color = Colors("my colors")
        if we call from the command line:
            color
        then we'll see the following line printed
        '''
        return "repr: color object \"{}\"".format(self.name)
    def __str__(self):
        '''
        called when converting this object into a string: (assuming color=Colors("my colors"))
            print(color)
            str(color)
        '''
        return "object \"{}\" converted to string".format(self.name)
    def __call__(self, text=None):
        '''
        this is called when:
            color()
            color(text)
        '''
        print("it makes no sense to do this in this case, I am simply showing you the usage of __call__")
        return text
    # there are of course many other interesting built-in functions in python, but I don't think you need them
    # actually it is not mandatory to use class for your project
    def bold(self, text):
        return Colors.BOLD + text + Colors.END
    def red(self, text):
        return Colors.RED + text + Colors.END
    def yellow(self, text):
        return Colors.YELLOW + text + Colors.END
    def blue(self, text):
        return Colors.BLUE + text + Colors.END
    def green(self, text):
        return Colors.GREEN + text + Colors.END

# generator
def batch_generator(dataset, batch_size = 64):
    '''
    dataset in this case is expected to be a list
    batch_size has default value 64
    sample usage:
        dataset = list(range(1000))
        batches = batch_generator(dataset)
        print(next(batches))
        print(next(batches))
    '''
    max_length = len(dataset)
    cursor_index = 0
    while cursor_index < max_length:
        cursor_index += batch_size
        yield dataset[cursor_index - batch_size:cursor_index]


# dictionary
my_dict = {1: "integer", "2": {2}, 3: 3, 4: (4,), (5,6):"pair"}
# my_dict.keys()
# my_dict.values()
# my_dict.items()

def dict_from_keys_values(keys_list, values_list):
    '''
    this is a very important usage of zip
    will likely to accelerate your code dramatically compared with iteration
    '''
    return dict(zip(keys_list, values_list))

def create_vocabulary(word_list, reverse=False):
    vocabulary = dict.fromkeys(word_list, 0)
    for word in word_list:
        vocabulary[word] += 1
    vocabulary = sort_by_value(vocabulary) # sorted by values from small to large
    return vocabulary

def sort_by_value(d, reverse=False):
    return dict(sorted(d.items(), key=lambda x: x[1], reverse=reverse))

if __name__ == '__main__':
    color = Colors("my colors")
    color()
    print("showing the keys of my_dict using {}".format(color.bold("enumerate")))
    for i,k in enumerate(my_dict.keys()):
        print("\tthe {1}-th key is {0}".format(k,i))
    for v,pair in zip(my_dict.values(),my_dict.items()):
        print("\tthe value {0} comes from the key-value pair {1}".format(v,pair))
    print("this is an example showing how to create a dictionary from key list and value list (and a scenario showing some other features of dict BTW)")
    dataset_example = ["hello", "world", "hello", "every", "one", \
                        "this", "is", "a", "sample", "test", "case", \
                        "for", "every", "one", "of", "you", \
                        "to", "get", "a", "better", "understanding",
                        "on", "how", "flexible", "a", "dictionary", "could", "be"]
    vocabulary = create_vocabulary(dataset_example)
    unique_words = list(vocabulary.keys())
    reversed_dict = dict_from_keys_values(unique_words, range(len(unique_words)) )
    print(reversed_dict)









