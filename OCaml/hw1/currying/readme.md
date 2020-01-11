# An Early Start on Currying

## Generate Assembly Code

```shell
ocamlopt -S -inline 20 -nodynlink currying.ml -o currying.opt
ocamlopt -S -inline 20 -nodynlink no_currying.ml -o no_currying.opt
```

And check the ```currying.s``` and ```no_currying.s``` files.