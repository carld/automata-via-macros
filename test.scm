
; add ./ to the guile load path,
; so the automaton module can be loaded from the same
; directory as this file is in
(add-to-load-path (dirname (current-filename)))

; load the automaton module
(use-modules (automata-via-macros))

; a state machine for parsing car/cdr combinations
(define m2
  (automaton init
    [init : (c -> more)]
    [more : (a -> more)
            (d -> more)
            (r -> end)]
    [end : accept]))

(define-syntax test
  (syntax-rules()
    ((_ expression expectation)
       (cond
          ((equal? expression expectation)  
               (display "TEST OK" )(newline))
          (else  (error "Unexpected result " ))))))

(test  (m2 `(c a d r))  #t)
(test  (m2 `(c d a a d r))  #t)
(test  (m2 `(r))  #f)
(test  (m2 `(i))  #f)
(test  (m2 `(a))  #f)
(test  (m2 `(c))  #f)
(test  (m2 `(c a r))  #t)

