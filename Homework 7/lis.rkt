(define (sub_seq_calc list sub_seq)
  (cond ((null? sub_seq) (sub_seq_calc (cdr list) (cons (car list) sub_seq)))
        ((null? list) (reverse sub_seq))
        ((>= (car list) (car sub_seq)) (sub_seq_calc (cdr list) (cons (car list) sub_seq)))
        (else (sub_seq_calc (cdr list) sub_seq))))

(define (max_sub_seq sub_seq max_len max_sub)
  (cond ((null? sub_seq) (write max_len) max_sub)
        ((> (length (car sub_seq)) max_len) (max_sub_seq (cdr sub_seq) (length(car sub_seq)) (car sub_seq)))
        (else (max_sub_seq (cdr sub_seq) max_len max_sub))))
  
(define (lis_slow_helper list sub_seq)
  (cond ((null? list) sub_seq)
        (else (cons(sub_seq_calc list '()) (lis_slow_helper (cdr list) sub_seq)))))
  
(define (lis_slow list)
  (max_sub_seq (lis_slow_helper list '()) 0 '()))



;(define lis_fast list sub_seq
;  )

(lis_slow '(1 2 3 2 4 1 2))

