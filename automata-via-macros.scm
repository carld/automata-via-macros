; http://cs.brown.edu/~sk/Publications/Papers/Published/sk-automata-macros/paper.pdf
; Figure 5.

(define-module (automata-via-macros)
   #:export (automaton))

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

