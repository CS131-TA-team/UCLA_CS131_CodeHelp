#lang racket
#| don't forget to include the first-line above!
	otherwise there might be troubles
	this file is directly runnable by either
	    racket hello.ss
	or, open it in DrRacket and click run
 |#

(define (square x)
    (* x x))

; the sample exercise's answer (from slides)
(define (do-twice f x) (f (f x)))

; (my-length '(1 2 3 4))
(define (my-length lst)
    (cond
        [(empty? lst) 0]
        [else (+ 1 (my-length (rest lst)))]
    ))

; (eval my-program)
(define my-program '(display "Hello, World!\n"))


; namespace
; run the file as racket hello.ss
; or click run in DrRacket
(define ns (make-base-namespace))
(eval my-program ns)

; dynamic eval example
; possible usage: call from the interpreter:
;       (eval-formula '(+ x y))
;       (eval-formula '(+ (* x y) y))
(define (eval-formula formula)
    (eval `(let ([x 2]
                 [y 3])
             ,formula)))
; this version is with namespace
; could be evaluated from interpreter or inside this file as shown below
(define (formula-to-eval formula)
    `(let ([x 2] [y 3]) ,formula))
(eval (formula-to-eval '(+ x y)) ns)
(eval (formula-to-eval '(+ (* x y) y)) ns)

; a recursive example
; could be called as, e.g. (fib 10)
(define (fib n)
    (cond
        [(= n 1) 1]
        [(= n 2) 1]
        [else (+ (fib (- n 1)) (fib (- n 2)))]
    )
)
