#lang racket
(define (rawnumer shorter longer)
  (define (aux shorter longer counter)
    (cond ((null? shorter) counter)
          ((eq? (car shorter)
                (car longer))
           (aux (cdr shorter)
                (cdr longer)
                (+ counter 1)))
          (else (aux (cdr shorter)
                     (cdr longer)
                     counter))))
  (if (< (length shorter)
         (length longer))
      (aux shorter longer 0)
      (aux longer shorter 0)))

(define (dicenumer alist blist)
  (let ((x  (rawnumer alist blist)))
    (* x 2)))

(define (dicecoeff alist blist)
  (/ (dicenumer alist blist)
    (* 2 (length alist))))

(define (lister astring)
(let ((x (string-length astring)))
  (define (aux counter)
    (if (= x counter) '()
        (cons (string-ref astring counter)
              (aux (+ counter 1)))))
  (aux 0)))

(define (accumlate proc alist)
	(define (aux proc alist counter)
		(if (null? alist) counter
		    (aux proc (cdr alist) (+ counter
		    	      	   	     (proc (car alist))))))
		(aux proc alist 0))

(define (multi-list-test test test-body)
	(define (aux test test-body counter)
		(if (null? test-body) counter
		    (aux test (cons (cadr test-body)
		    	      	    (cdr test-body))
				    (+ counter
		    	      	       (test (car test-body)
					     (cadr test-body))))))
		(aux test test-body 0))

(define (dice-trial dice-test test-body)
	(/ (mult-list-test dice-test test-body)
	   (length test-body)))




 