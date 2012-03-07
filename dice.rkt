#lang racket

(define (accumlate proc alist)
	(define (aux proc alist counter)
		(if (null? alist) counter
		    (aux proc (cdr alist) (+ counter
		    	      	   	     (proc (car alist))))))
		(aux proc alist 0))


(define (dicecoeff alist blist)
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
  (/ (dicenumer alist blist)
    (* 2 (length alist))))

(define (trial-creator base-list)
	(define (aux appendage base-list)
	(if (null? base-list)'()
	    (cons (list appendage 
	    	  	(car base-list))
		(aux appendage (cdr base-list)))))
	(define (dblaux xlist base-list)
	(if (null? xlist) '()
	    (cons (aux (car xlist) base-list)
	    	  (dblaux (cdr xlist) base-list))))
	(let ((xlist base-list))
	     (dblaux xlist base-list)))

(define trial
	(lambda (trial-body)
		(define (first-aux test-body counter)
			(if (null? test-body) counter
			   (first-aux (cdr test-body) 
			              (+ counter (dicecoeff (car (car test-body)) 
							(car (cdr (car test-body))))))))
		(define (aux test-body)
			(/ (first-aux test-body 0) (length test-body)))
		(let ((n (length trial-body)))
			(/ (accumlate aux trial-body) n))))

;; this takes the mean of means of multiple trials, in this context, multiple domains 
(define (mean-of-means trial list-of-trials)
	(let ((n (length list-of-trials)))
	(define (aux list-of-trials counter)
		(if (null? list-of-trials)
		    (/ counter n)
		   (aux (cdr list-of-trials) (+ counter (trial (car list of trials))))))
	(aux list-of-trials 0)))

;; this calculates the standard deviation of one trial, that is, of one domain
(define (standard-deviation atrial-body)
	(let ((m (trial atrial-body)))
		(define (list-gen alist)
			(if (null? alist) '()
			    (cons (diceceoff (car (car alist))
					    (car (cdr (car alist))))
				(list-gen alist))))
		(define (scnd-list-gen alist)
			(if (null? alist) '()
			   (cons (square (- m (car alist)))
                                 (scnd-list-gen (cdr alist)))))


			     
	
	
