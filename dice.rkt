#lang racket
(require "trial1.rkt")
(require "trial2.rkt")
(require "trial3.rkt")
(require "test4.rkt")

(define (accumlate proc alist)
	(define (aux proc alist counter)
		(if (null? alist) counter
		    (aux proc (cdr alist) (+ counter
		    	      	   	     (proc (car alist))))))
		(aux proc alist 0))
;; accumlate the elements of a numerical list
(define (list-accumulate alist)
	(define (add-zero x)
		(+ x 0))
	(accumlate add-zero alist))


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

;; a new trial creator
;;(define (new-trial-creator alist)
;;	(define (aux appendage baselist)
;;		(if (null? baselist) '()
;;		    (cons (list appendage baselist)
;;                        (aux appendage xlist))
;;		


(define trial
	(lambda (trial-body)
		(define (first-aux test-body counter)
			(if (null? test-body) counter
			   (first-aux (cdr test-body) 
			              (+ counter (dicecoeff (car (car test-body)) 
							(car (cdr (car test-body))))))))
		(define (aux trial-body counter)
			(if (null? trial-body) counter
			    (aux (cdr trial-body)
                                 (+ counter 
                                    (/ (first-aux (car trial-body) 0) 
                                       (length (car trial-body))))))) 
		(let ((n (length trial-body)))
			(/ (aux trial-body 0) n))))

;; this takes the mean of means of multiple trials, in this context, multiple domains 
(define (mean-of-means trial list-of-trials)
	(let ((n (length list-of-trials)))
	(define (aux list-of-trials counter)
		(if (null? list-of-trials)
		    (/ counter n)
		   (aux (cdr list-of-trials) (+ counter (trial (car list-of-trials))))))
	(aux list-of-trials 0)))

;; this calculates the standard deviation of one trial, that is, of one domain
(define (standard-deviation atrial-body)
	(let ((m (trial atrial-body)))
	(define (list-gen alist)
		(if (null? alist) '()
		     (cons (sqr (- m (dicecoeff (car (car alist))
				      (car (cdr (car alist))))))
		           (list-gen (cdr alist)))))
	(define (second-list-gen atrial-body)
		(if (null? atrial-body) '()
		    (cons (list-gen (car atrial-body))
                          (second-list-gen (cdr atrial-body)))))
        (define (tree-walk atree counter)
		(define (branch-walk abranch counter)
			(if (null? abranch) counter
                            (branch-walk (cdr abranch) (+ counter (car abranch)))))
                (if (null? atree) counter
		    (tree-walk (cdr atree) (+ counter (branch-walk (car atree) 0)))))
	(define (enum-elements alist counter)
		(define (aux alist counter)
			(if (null? alist) counter
			    (aux (cdr alist) (+ counter 1))))
		(if (null? alist) counter
		    (enum-elements (cdr alist) (+ counter (aux (car alist) 0)))))
	(let ((x (tree-walk (second-list-gen atrial-body) 0))
              (y (enum-elements (second-list-gen atrial-body) 0)))
		(sqrt (/ x y)))))

	
                    

	      
		
		


			     
	
	
