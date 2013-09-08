(load "3.4-parallel.scm")

(define (exchange account1 account2)
    (let ((diff (- (account1 'balance) (account2 'balance))))
        ((account1 'withdraw) diff)
        ((account2 'deposit) diff)))

(define (make-account-and-serializer balance)
    (define (withdraw amount)
        (if (>= balance amount)
            (begin
                (set! balance (- balance amount))
                balance)
            "Insufficient funds"))
    (define (deposit amount)
        (set! balance (+ balance amount))
        balance)
    (let ((balance-serializer (make-serializer)))
        (define (dispatch m)
            (cond
                ((eq? m 'withdraw) withdraw)
                ((eq? m 'deposit)  deposit)
                ((eq? m 'serializer) balance-serializer)
                (else (error "unknown request -- MAKE-ACCOUNT" m))))
        dispatch))

(define (deposit account amount)
    (let ((s (account 'serializer))
          (d (account 'deposit)))
        ((s d) amount)))

(define (serialized-exchange account1 account2)
    (let ((serializer1 (account1 'serializer))
          (serializer2 (account2 'serializer)))
     ((serializer1 (serializer2 exchange)) account1 account2)))
