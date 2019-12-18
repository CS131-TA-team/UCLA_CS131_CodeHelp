#lang racket

(define (unify-term lhs rhs)
  (cond
    ; Identical
    [(equal? lhs rhs) '()]
    ; >=1 variable
    [(symbol? lhs) `((,lhs ,rhs))]
    [(symbol? rhs) `((,rhs ,lhs))]
    ; >=1 atom (not equal)
    [(or (string? lhs) (string? rhs)) #f]
    ; All relation
    [(not (equal? (length lhs) (length rhs))) #f]
    [#t (unify-list lhs rhs)]))

(define (subst term var value)
  (cond
    ; If it's a variable
    [(symbol? term) (if (equal? term var) value term)]
    ; If it's an atom
    [(string? term) term]
    ; If it's a relation
    [#t (map (lambda (t) (subst t var value)) term)]))

(define (subst-all term lst)
  (foldr (lambda (v t) (subst t (car v) (cadr v))) term lst))

(define (unify-list llst rlst)
  (if (empty? llst)
      '()
      ; First unify the tail
      (let ([tail-result (unify-list (cdr llst) (cdr rlst))])
        (if (not tail-result)
            #f
            ; Then apply the result to the head of each list
            (let* ([new-lh (subst-all (car llst) tail-result)]
                   [new-rh (subst-all (car rlst) tail-result)]
                   [head-result (unify-term new-lh new-rh)])
              (if (not head-result)
                  #f
                  ; And concatenate the result with tail-result
                  (append head-result tail-result)))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define (map-foldr proc init lst)
  (if (empty? lst)
      (list '() init)
      (let* ([rest-result (map-foldr proc init (cdr lst))]
             [tail (car rest-result)]
             [result (proc (car lst) (cadr rest-result))]
             [ret-list (cons (car result) tail)]
             [ret-acc (cadr result)])
        (list ret-list ret-acc))))

(define (rename-symbol-aux term table)
  (cond
    [(string? term) (list term table)]
    [(symbol? term) (let* ([old (assoc term table)])
                      (if old
                          (list (cadr old) table)
                          (let* ([new-sym (gensym)])
                            `(,new-sym ((,term ,new-sym) ,@table)))))]
    [#t (map-foldr rename-symbol-aux table term)]))

(define (rename-symbol term)
  (car (rename-symbol-aux term '())))

(define (resolution clause goals query)
  (let* ([sub (unify-term (car clause) (car goals))]
         [new-goals (append (cdr clause) (cdr goals))])
    (if (not sub)
        #f
        (list (map (lambda (t) (subst-all t sub)) new-goals)
              (subst-all query sub)))))

(define (solve goals query program)
  (if (empty? goals)
      query
      (for/or ([c program])
        (let ([trial (resolution (rename-symbol c) goals query)])
          (if trial
              (solve (car trial) (cadr trial) program)
              #f)))))

(define (prolog query program)
  (solve (list query) query program))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;plus(z, X, X).
;plus(s(X), Y, s(Z)) :- plus(X, Y, Z).
;plus(s(z), s(s(z)), X)?
(define test1-program
  '((("plus" "z" X X))
    (("plus" ("s" X) Y ("s" Z)) ("plus" X Y Z))))
(define test1-query1
  '("plus" ("s" "z") ("s" ("s" "z")) X))
(define test1-query2
  '("plus" X ("s" ("s" "z")) ("s" ("s" ("s" "z")))))
(define test1-query3
  '("plus" ("s" "z") X ("s" ("s" ("s" "z")))))

;car(cons(X, Y), X).
;car(cons(a, nil), X)?
(define test2-program
  '((("car" ("cons" X Y) X))))
(define test2-query
  '("car" ("cons" "a" "nil") X))

;plus(z, X, X).
;plus(s(X), Y, s(Z)) :- plus(X, Y, Z).
;fib(s(z), s(z)).
;fib(s(s(z)), s(s(z))).
;fib(s(s(X)), Y) :- fib(s(X), Y1), fib(X, Y2), plus(Y1, Y2, Y).
;fib(s(s(s(s(z)))), Y)?
(define test3-program
  '((("plus" "z" X X))
    (("plus" ("s" X) Y ("s" Z)) ("plus" X Y Z))
    (("fib" ("s" "z") ("s" "z")))
    (("fib" ("s" ("s" "z")) ("s" ("s" "z"))))
    (("fib" ("s" ("s" X)) Y) ("fib" ("s" X) Y1) ("fib" X Y2) ("plus" Y1 Y2 Y))))
(define test3-query
  '("fib" ("s" ("s" ("s" ("s" ("s" "z"))))) Y))

;p(f(Y)) :- q(Y), r(Y).
;p(b).
;q(h(Z)) :- t(Z).
;r(h(a)).
;t(a).
;p(X)?
(define test4-program
  '((("p" ("f" Y)) ("q" Y) ("r" Y))
    (("p" "b"))
    (("q" ("h" Z)) ("t" Z))
    (("r" ("h" "a")))
    (("t" "a"))))
(define test4-query
  '("p" X))