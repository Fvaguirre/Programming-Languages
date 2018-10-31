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

;; Contract: flatten : x must be a list
;; Purpose: to take a list and remove internal parenthesis
;; Example: (flatten '( (1 2) (3 4) ) ) will produce '( 1 2 3 4)
;; Definition:
(define (flatten x)
  (cond ((null? x) '())
        ((pair? x) (append (flatten (car x)) (flatten (cdr x))))
        (else (list x))))


;; Contract: lst must be a list
;; Purpose: Takes a list and finds max increasing run
;; Example: (findCurr '(1 2 0 -1) ) will produce 2
;; Definition:
(define (findCurr lst)
    (let loop ((L lst)
               (bestMax 0)
               (currMax 1))
      (cond
      ((null? (cdr L) ) currMax)
      ((< (car L) (cadr L)) (loop (cdr L) bestMax (+ 1 currMax)) )
      (else (loop (cdr L) bestMax currMax))
      )
      )
    )

;; Contract: lst must be a  2-D list of lists
;; Purpose: Takes a list of lists and finds the max increasing run
;; from the internal lists
;; Example: (findBurr '(1 2 0 -1) '(1 2 3 4) ) will produce 4
;; Definition:
(define (findBest lst)
  (let loop ((L lst )
             (best 0))
    (cond
      ((null? L) best)
      ((< best (findCurr (car L) )) (loop (cdr L) (findCurr (car L)) ) )
      (else (loop (cdr L) best ))
      )
    )
  )

;; Contract: lst must be a list
;; Purpose: Takes a list and returns a list with num number of items from original
;; Example: (get-n-items '(1 2 3 4 5) 3) will produce '(1 2 3)
;; Definition:
(define get-n-items
    (lambda (lst num)
        (if (and (> num 0) (not (null? lst)))
            (cons (car lst) (get-n-items (cdr lst) (- num 1)))
            '()))) ;'

;; Contract: lst must be 1-D list 1 <= start <= len(lst) && 0 <= count <= len(lst) -1
;; Purpose: Takes a list and a start index and count and returns a sliced list from
;; start index offset with count # of elements from lst
;; Example: (slice '(1 2 3 4 5) 2 2) will produce '(2 3 4)
;; Definition:
(define slice
    (lambda (lst start count)
        (if (and (> start 1) (null? lst))
            (slice (cdr lst) (- start 1) count)
            (get-n-items lst count))))


;; Contract: lst must be a 1-D list
;; Purpose: Takes a list and returns a list of sublists of lst from
;; lst[len-count]: lst[count]
;; Example: (makeLists '(1 2 3 4) 4 0) will produce '((1 2 3 4) (2 3 4) (3 4) (4) )
;; Definition: 
(define (makelists lst len count)
  (if (or (equal? count len) (null? lst) )
      '()
      (cons (slice lst count (- len count)  ) (makelists (cdr lst) len (+ count 1)))
      )
  )
;; Contract: lst must be 1-D lst
;; Purpose: Takes a list and returns the maximum increasing subsequence (helps lis_fast)
;; Example: (lis_fast '(1 0 2 8 -1 10)) -> (1 2 8 10)
;; Definition:
(define (lis_fast_helper lst)
  (lis_slow lst)
 )
;; Contract:lst must be 1-D list
;; Purpose: Takes a list and returns the leftmost maximum increasing subsequence
;; Example: (lis_fast '(1 0 2 8 -1 10)) -> (1 2 8 10)
;; Definition:
(define (lis_fast lst)
  (if (null? lst) '()
      (lis_fast_helper lst)
      )
 )
  






