
;; Contract: sub_seq_calc : list list -> list
;; Purpose: compiles a subsequence from the given list
;; Example: list = (1 2 3 2 4 1 2)
;;          (sub_seq_calc list sub_seq) returns (1 2 3 4) since that
;;          is the first subsequence we come across with this list
;; Definition:
(define (sub_seq_calc list sub_seq)
  (cond ((null? sub_seq) (sub_seq_calc (cdr list) (cons (car list) sub_seq)))
        ((null? list) (reverse sub_seq))
        ((>= (car list) (car sub_seq)) (sub_seq_calc (cdr list) (cons (car list) sub_seq)))
        (else (sub_seq_calc (cdr list) sub_seq))))


;; Contract: max_sub_seq : list length length -> length
;; Purpose: find the length of the longest subsequence
;; Example: list = (1 2 3 2 4 1 2))
;;          (max_sub_seq sub_seq max_len max_sub) would return 4 since the
;;          longest subsequences that can be made are of length 4
;; Definition:
(define (max_sub_seq sub_seq max_len max_sub)
  (cond ((null? sub_seq) max_sub)
        ((> (length (car sub_seq)) max_len) (max_sub_seq (cdr sub_seq) (length(car sub_seq)) (car sub_seq)))
        (else (max_sub_seq (cdr sub_seq) max_len max_sub))))


;; Contract: lis_slow_helper : list, list -> list
;; Purpose: creates a list of all subsequences
;; Example: list = (1 2 3 2 4 1 2)
;;          (lis_slow_helper list sub_seq) returns a list of all subsequences
;;          made by this list ((1 2 3 4) (1 2 2 4) (1 2 2 2))
;; Definition:
(define (lis_slow_helper list sub_seq)
  (cond ((null? list) sub_seq)
        (else (cons(sub_seq_calc list '()) (lis_slow_helper (cdr list) sub_seq)))))


;; Contract: lis_slow : list -> list
;; Purpose: return the max subsequence in ascending order of a list 
;; Example: list = (1 2 3 2 4 1 2)
;;          (lis_slow list) returns (1 2 3 4)
;; Definition:
(define (lis_slow list)
  (max_sub_seq (lis_slow_helper list '()) 0 '()))


(lis_slow '(1 2 3 2 4 1 2 2 6 4 7 1))








(define (increment i j)
  (cond ((equal? i j) ((+ i 1)(= j 0)))
        ((< j i) (+ j 1)))
)






