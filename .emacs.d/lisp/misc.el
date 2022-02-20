;;;  -*- lexical-binding: t -*-
(defun my-set-frame-width ()
  (interactive)
  (set-frame-width (selected-frame)
                   (my-set-frame--prompt "frame width" (frame-width))))
(defun my-set-frame-height ()
  (interactive)
  (set-frame-height (selected-frame)
                    (my-set-frame--prompt "frame height" (frame-height))))

(defun my-set-frame--prompt (prompt-message present-value)
  (if (window-system)
      (let ((width (string-to-number
                    (read-from-minibuffer
                     (format "%s(present: %s): " prompt-message present-value)))))
        (when (< width 1)
          (error (format "%s must be number is bigger than 0: %s" prompt-message width)))
        width)
    (error "Error: window system only")))

(defun factoral (n)
  (if (> n 0)
      (* n (factoral (- n 1)))
    1))

(defun combination (n r)
  (/ (factoral n) (* (factoral r) (factoral (- n r)))))

(defvar my-resize-window-map
  (let ((map (make-sparse-keymap)))
    (suppress-keymap map)
    (mapc (lambda (char)
            (define-key map (string char)
              'my--resize-window-help-message))
          (number-sequence #x21 #x7F))
    (mapc (lambda (e)
            (define-key map (string (car e))
              (lambda ()
                (interactive)
                (apply (cadr e) (cddr e)) (my--resize-window-help-message))))
          '((?> . (enlarge-window-horizontally 1))
            (?< . (shrink-window-horizontally 1))
            (?+ . (enlarge-window 1))
            (?= . (enlarge-window 1))
            (?- . (shrink-window 1))))
    map
    ))

(defun my--resize-window-help-message ()
  (interactive)
  (message "+/-: change height, >/<: change width, q: quit"))

(defun my-resize-window-interactively ()
  ""
  (interactive)
  (let ((original-map (current-local-map)))
    (my--resize-window-help-message)
    (define-key my-resize-window-map (string ?q)
      (lambda ()
        (interactive)
        (use-local-map original-map)
        (define-key my-resize-window-map (string ?q) nil)
        (message "quit")))
      (use-local-map my-resize-window-map)
    ))
