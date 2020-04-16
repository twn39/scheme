#lang racket/gui
(require sha)
(require racket/match)
(require file/md5)

(define frame (new frame% [label "SHA GUI App"]  
                   [width 540]
                   [x 500]
                   [y 300]
                   [alignment '(left top)]
                   [border 20]
                   ))


(define key-field (new text-field% [parent frame]
                       [label "Key: "]
                       ))

(define msg-field (new text-field% [parent frame]
                      [label "Message: "]
                      ))


(define hash-choice (new choice% [parent frame]
                    [label "算法:"]
                    [choices (list "SHA1" "SHA256" "HMAC-SHA1" "HMAC-SHA256")]
                    [horiz-margin 20]
                    
                    ))

;;;
(define simple-hash-compute (lambda (fn)
                             (simple-hash fn (send msg-field get-value))
                             ))

;;;
(define hmac-hash-compute (lambda (fn)
                            (hmac-hash fn (send key-field get-value) (send msg-field get-value))
                            ))

;;; simple hash
(define simple-hash (lambda (hash-fn msg)
                      (bytes->hex-string (hash-fn (string->bytes/utf-8 msg)))
                      ))

;;; hmac hash
(define hmac-hash (lambda (hash-fn key msg)
                     (bytes->hex-string (hash-fn (string->bytes/utf-8 key) (string->bytes/utf-8 msg)))
                    ))
;;; 定义callback
(define sha-compute-callback (lambda (button event)
                      (send result-msg set-label (hmac-hash-compute hmac-sha256))))

;;; md5
(define md5-hash (lambda ()
                   (bytes->hex-string (md5 (open-input-string (send msg-field get-value))))
                   ))
;;; match hash

(define match-hash (lambda (hash-name)
                     (match hash-name
                       ["SHA1" (send result-msg set-label (simple-hash-compute sha1))]
                       ["SHA256" (send result-msg set-label (simple-hash-compute sha256))]
                       ["HMAC-SHA1" (send result-msg set-label (hmac-hash-compute hmac-sha1 ))]
                       ["HMAC-SHA256" (send result-msg set-label (hmac-hash-compute hmac-sha256 ))]
                       ["MD5" (send result-msg set-label (md5-hash)) ]
                       )
                     ))


(define btn (new button% [parent frame]
                 [label "计算"]
                 [horiz-margin 20]
                 ;;;[callback sha-compute-callback]
                 [callback (lambda (button event)
                            (match-hash (send hash-choice get-string-selection))
                             )]
                 ))

(define result-label (new message% [parent frame]
                       [label "值："]
                       [horiz-margin 20]
                       ))

(define result-msg (new message% [parent frame]
                       [label "null"]
                       [min-width 540]
                       [horiz-margin 20]
                       [vert-margin 20]
                       ))

(send frame show #t)