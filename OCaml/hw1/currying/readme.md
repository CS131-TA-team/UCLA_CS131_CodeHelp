# An Early Start on Currying

This is a simple OCaml currying example showing how it works & how to check OCaml assembly.

## Generate Assembly Code

```shell
ocamlopt -S -inline 20 -nodynlink currying.ml -o currying.opt
ocamlopt -S -inline 20 -nodynlink no_currying.ml -o no_currying.opt
```

And check the ```currying.s``` and ```no_currying.s``` files.