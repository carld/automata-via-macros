; http://cs.brown.edu/~sk/Publications/Papers/Published/sk-automata-macros/paper.pdf
; Figure 5.

(library (automata-via-macros)
         (export automaton : accept ->)
         (import (rnrs))

; Auxiliary keywords in macros need to be defined because unbound
; library identifiers aren't equivalent to top-level identifiers
;
;     http://gwatt.github.io/csug/use.html#./use:s13
;     https://github.com/cisco/ChezScheme/issues/41

(define akw
  (lambda (x) (syntax-violation #f "misplaced auxiliary keyword" x)))

(define : akw)
(define accept akw)
(define -> akw)

(define-syntax automaton
  (syntax-rules (:)
    [(_ init-state
         (state : response ...) ...)
     (let-syntax
          ([process-state
            (syntax-rules (accept ->)
              [(_ accept)
               (lambda (stream)
                  (cond
                   [(null? stream) #t]
                   [else #f]))]
              [(_ (label -> target) (... ...))
              (lambda (stream)
                  (cond
                   [(null? stream) #f]
                   [else (case (car stream)
                            [(label) (target (cdr stream))]
                            (... ...)
                            [else #f])]))])])
          (letrec ([state (process-state response ...)] ...)
            init-state))]))

)
