# Hint Code for Prolog

## About
* Still, not mandatory to be used.
* Remember it is gnu-prolog, not swi-prolog

## Getting Started
- Open terminal and type in gprolog to the toplevel, and exit by CTRL&D or CTRL&C + e
- [visualization](http://www.cdglabs.org/prolog/#/)

### Example
1. Have your code ready in, e.g. *hello.pl*
2. Enter gprolog to the toplevel.
3. From prolog toplevel, consult your code by either of the following ways:
    * ```[hello].```
    * ```consult(hello).```
4. Then you can run all the queries. e.g. ```ancestor(john,Who).```
5. To debug: trace. (and exit by notrace.)

## About the Files
* [hello.pl](./hello.pl)
    * Hint to get you started on prolog, containing the basic syntax.
* [examples.pl](./examples.pl)
    * Some more-complex examples.
* [unique_list.pl](./unique_list.pl)
    * An example from Kimmo's old slides, a showcase telling you the difference between **declarative** programming languages and imperative languages.
* [sudoku_cell.pl](./sudoku_cell.pl)
    * Hint code on basis of finite-domain solver.
* [list2D_hint.pl](./list2D_hint.pl)
    * Some examples on how to deal with a 2D array in prolog.
* [plain_domain.pl](./plain_domain.pl)
    * A piece of hint that might help you implement plain_tower with higher efficiency!