#lang racket
#| don't forget to include the first-line above!
	otherwise there might be troubles
	this file is directly runnable by either
	    racket hello.ss
	or, open it in DrRacket and click run

    for basic syntax introduction, please see slides and hello.ss
 |#

; hint on judging lambda
(define (lambda? x)
    (if (member x '(lambda λ)) #t #f)
)

(define (expr-compare x y)
    (cond
          [(equal? x y) x]
          [(and (boolean? x) (boolean? y)) 
             (if x
                 (if y #t '%)
                 (if y '(not %) #f)
             )
          ]
          ; if one of them is not list - which means that not function
          [(or (not (list? x)) 
               (not (list? y)))
            (list 'if '% x y)]
         ; and below here it is your work to figure out how to judge every case
    )
)

; compare and see if the (expr-compare x y) result is the same with x when % = #t
;                                                 and the same with y when % = #f
(define (test-expr-compare x y) 
    (and
        (equal? (eval x)
                (eval '(let ((% #t)) (expr-compare x y))))
        (equal? (eval y)
                (eval '(let ((% #f)) (expr-compare x y))))
    )
)

; you need to have more, and strong, test-cases here
(define test-expr-x
    (list 12
          12
          #t
          #f
          #t
          #f
          ;'a ; this could not go in here, it wouldn't be evaluated by test-expr-compare directly (why?)
     )
)

(define test-expr-y
    (list 12
          20
          #t
          #f
          #f
          #t
          ;'(cons a b) ; same as above, why?
     )
)

; the following line can be tested from interpreter
;     (test-expr-compare (first test-expr-x) (first test-expr-y))
;     (expr-compare 'a '(cons a b)) 
;     (expr-compare '(cons a b) '(cons a b))
;     (lambda? 'λ)






