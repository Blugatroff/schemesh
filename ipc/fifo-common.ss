;;; Copyright (C) 2023-2025 by Massimiliano Ghilardi
;;;
;;; This program is free software; you can redistribute it and/or modify
;;; it under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 2 of the License, or
;;; (at your option) any later version.


#!r6rs

;; this file should be included only by files ipc/fifo-thread.ss or ipc/fifo-nothread.ss


(define-record-type (producer %make-producer producer?)
  (fields
    (mutable tail)
    mutex
    changed)
  (nongenerative producer-7c46d04b-34f4-4046-b5c7-b63753c1be39))



(define-record-type (consumer %make-consumer consumer?)
  (fields
    (mutable head)
    (mutable eof?)
    mutex
    changed)
  (nongenerative consumer-7c46d04b-34f4-4046-b5c7-b63753c1be39))


;; convert one of:
;; * an exact or inexact real, indicating the number of seconds
;; * a pair (seconds . nanoseconds) where both are exact integers
;; * a time object with type 'time-duration, which is copied
;;
;; to a time object with type 'time-duration
(define (make-time-duration duration)
  (cond
    ((real? duration)
      (let* ((seconds (exact (floor duration)))
             (ns      (exact (round (* 1e9 (- duration seconds))))))
        (make-time 'time-duration ns seconds)))
    ((pair? duration)
      (make-time 'time-duration (cdr duration) (car duration)))
    (else
      (assert* 'make-time-duration (time? duration))
      (assert* 'make-time-duration (eq? 'time-duration (time-type duration)))
      (make-time 'time-duration (time-nanosecond duration) (time-second duration)))))
