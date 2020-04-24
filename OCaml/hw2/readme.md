# Hint Code for OCaml HW2

## About
* Still, not mandatory to be used.

## About the Files
* [pseudo_code.txt](./pseudo_code.txt)
    * It comes from Prof. Eggert's Fall 2019 lecture, refined by Xinyu Ma
    * Note that it is only a piece of **pseudo** code, please don't ask us why it has compilation error.
* [hw2tree_hint.py](./hw2tree_hint.py)
    * This piece of code introduces the structure of tree, and tree traversals. If you are already familiar with the tree structure, skip it.
* [hw2_matcher2parser.py](./hw2_matcher2parser.py)
    * Many felt it easy implementing a matcher, but get confused how to move on to parser; this is how (in logic only; you still need to write your own implementation).
* [option.ml](./option.ml)
    * You are not allowed to use the library functions in [Option](http://ocaml-lib.sourceforge.net/doc/Option.html). But listed here are some easy replacements of those library functions.
* [grammer_converter_sample.ml](./grammar_converter_sample.ml)
    * This is some sample test cases for grammar converter (converting from hw1-style grammar to hw2-style grammar), if you feel confused on how to test the correctness of that part please try this.
* [Why_Acceptor.ml](./Why_Acceptor.ml) is the hint code Xinyu provides to you. It'll help you have a better understanding on HW2 settings.
* [2006 hint code](./2006/) is the runnable copy of the 2006 hint code we provide you.

## A few more tips
* Check the [debugger](https://caml.inria.fr/pub/docs/manual-ocaml/debugger.html) if you love debuggers such as GDB etc. Not mandatory to use it.
* If you somehow didn't make it to finish ```make_matcher``` and ```make_parser``` in time, please at least put the default implementation as a placeholder:
```shell
let make_matcher gram accept frag = None;;
let make_parser gram frag = None;
```
so that you can avoid potential errors such as ```Unbound value make_matcher```.