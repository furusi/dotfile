(recentf-mode 1)
(setq recentf-max-menu-items 25)
;;(global-set-key "\C-x\ \C-r" 'recentf-open-files)
(global-set-key "\C-x\ \C-r" 'helm-recentf)

(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;; Orgを追加
  (add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives '("gnu" . (concat proto "://elpa.gnu.org/packages/")))))
(package-initialize)
(eval-when-compile
    (unless (require 'use-package nil t)
    (package-install 'use-package))
  )

(show-paren-mode t)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ediff-window-setup-function (quote ediff-setup-windows-plain))
 '(inhibit-startup-screen t)
 '(org-agenda-files
   (quote
    ("~/Dropbox/org/task.org" "~/Dropbox/org/notes.org")))
 '(package-selected-packages
   (quote
    (init-loader keyfreq esup spaceline-all-the-icons org-plus-contrib elpy exec-path-from-shell jedi yasnippet-snippets yasnippet which-key helm-themes leuven-theme highlight smartparens parent-mode highlight-parentheses helm web-mode ac-html auto-save-buffers-enhanced undohist fuzzy slime prodigy ox-rst sphinx-mode slack org-ac undo-tree atom-dark-theme gradle-mode package-utils simplenote2 ac-skk magit auto-complete manrkdown-mode ddskk))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(set-face-attribute 'default nil :height 140)



;; Emacs起動時にrst.elを読み込み
(use-package rst
  :ensure t)
;; 拡張子の*.rst, *.restのファイルをrst-modeで開く
(setq auto-mode-alist
      (append '(("\\.rst$" . rst-mode)
		("\\.rest$" . rst-mode)) auto-mode-alist))
;; 背景が黒い場合はこうしないと見出しが見づらい
;;(setq frame-background-mode 'dark)
;; 全部スペースでインデントしましょう
(add-hook 'rst-mode-hook '(lambda() (setq indent-tabs-mode nil)))

(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status))
  )


(use-package gradle-mode)

(use-package eww
  :config
  (setq eww-search-prefix "http://www.google.co.jp/search?q=")
  )



;;(setq coding-system-for-read 'utf-8)
;;(load-theme 'atom-dark t)
(load-theme 'leuven t)

(use-package ddskk
  :ensure t
;;  :defer t
  :bind (("C-x C-j" . skk-mode))
  :init
  (setq skk-large-jisyo "~/.emacs.d/skk-get-jisyo/SKK-JISYO.L")
  (setq skk-search-katakana t)
  (setq skk-use-act t)
  (setq skk-henkan-show-candidates-keys '(?a ?o ?e ?u ?h ?t ?n ?s))
  :config
  (setq skk-show-icon t)
  (setq skk-egg-like-newline t);;non-nilにするとEnterでの確定時に改行しない
  ;; ▼モードで BS を押したときには確定しないで前候補を表示する
  (setq skk-delete-implies-kakutei nil)
  )

(use-package skk-study
  :after ddskk)

;;
;; Org mode
;;
(use-package ox-latex
  :config
  
  (add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
  (setq org-latex-default-class "bxjsarticle")
  (setq org-latex-pdf-process '("latexmk -e '$latex=q/uplatex %S/' -e '$bibtex=q/upbibtex %B/' -e '$biber=q/biber --bblencoding=utf8 -u -U --output_safechars %B/' -e '$makeindex=q/upmendex -o %D %S/' -e '$dvipdf=q/dvipdfmx -o %D %S/' -norc -gg -pdfdvi %f"))
;(setq org-latex-pdf-process '("latexmk -e '$lualatex=q/lualatex %S/' -e '$bibtex=q/upbibtex %B/' -e '$biber=q/biber --bblencoding=utf8 -u -U --output_safechars %B/' -e '$makeindex=q/upmendex -o %D %S/' -norc -gg -pdflua %f"))
;(setq org-export-in-background t)
  (setq org-file-apps
	'(("pdf" . "open -a Skim %s")))

  (add-to-list 'org-latex-classes
	       '("bxjsarticle"
		 "\\documentclass[autodetect-engine,dvi=dvipdfmx,11pt,a4paper,ja=standard]{bxjsarticle}
[NO-DEFAULT-PACKAGES]
\\usepackage{amsmath}
\\usepackage{newtxtext,newtxmath}
\\usepackage{graphicx}
\\usepackage{hyperref}
\\ifdefined\\kanjiskip
  \\usepackage{pxjahyper}
  \\hypersetup{colorlinks=true}
\\else
  \\ifdefined\\XeTeXversion
      \\XeTeXgenerateactualtext=1
      \\hypersetup{colorlinks=true}
  \\else
    \\ifdefined\\directlua
      \\hypersetup{pdfencoding=auto,colorlinks=true}
    \\else
      \\hypersetup{unicode,colorlinks=true}
    \\fi
  \\fi
\\fi"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

(add-to-list 'org-latex-classes
             '("jlreq"
               "\\documentclass[11pt,paper=a4]{jlreq}
[NO-DEFAULT-PACKAGES]
\\usepackage{amsmath}
\\usepackage{newtxtext,newtxmath}
\\ifdefined\\kanjiskip
  \\usepackage[dvipdfmx]{graphicx}
  \\usepackage[dvipdfmx]{hyperref}
  \\usepackage{pxjahyper}
  \\hypersetup{colorlinks=true}
\\else
  \\usepackage{graphicx}
  \\usepackage{hyperref}
  \\hypersetup{pdfencoding=auto,colorlinks=true}
\\fi"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

(add-to-list 'org-latex-classes
             '("jlreq-tate"
               "\\documentclass[tate,11pt,paper=a4]{jlreq}
[NO-DEFAULT-PACKAGES]
\\usepackage{amsmath}
\\usepackage{newtxtext,newtxmath}
\\ifdefined\\kanjiskip
  \\usepackage[dvipdfmx]{graphicx}
  \\usepackage[dvipdfmx]{hyperref}
  \\usepackage{pxjahyper}
  \\hypersetup{colorlinks=true}
\\else
  \\usepackage{graphicx}
  \\usepackage{hyperref}
  \\hypersetup{pdfencoding=auto,colorlinks=true}
\\fi"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))) )


(use-package org-capture
  :bind (("\C-cc" . org-capture))
  :config
  (setq org-directory (expand-file-name "~/Dropbox/org/"))
  (setq org-capture-templates
	`(
	  ("t" "Task" entry
	   (file ,(concat org-directory "task.org"))
	   "* TODO %? %i\n %a\n")
	  ("n" "note" entry
	   (file ,(concat org-directory "notes.org"))
	   "* %?\n %a\n %T")
	  ("r" "reading" entry
	   (file ,(concat org-directory "reading.org"))
	   "* %?\n %a\n %T") ))
  )

(use-package org
  :mode (("\\.org$" . org-mode))
  :ensure org-plus-contrib
  :config
  (setq org-mobile-directory "~/Dropbox/アプリ/MobileOrg")
  (setq org-mobile-files
	(list "~/Dropbox/org/notes.org"
	      "~/Dropbox/org/todo.org"
	      "~/Dropbox/org/task.org"
	      "~/Dropbox/org/iphone.org"
	      ))
  (setq org-mobile-inbox-for-pull "~/Dropbox/org/iphone.org")
  (setq org-tag-alist
  '(("@OFFICE" . ?o) ("@HOME" . ?h) ("SHOPPING" . ?s)
    ("MAIL" . ?m) ("PROJECT" . ?p) ("備忘録" . ?b)))

  :bind (("\C-cl" . org-store-link)
	 ("\C-ca" . org-agenda)
	 ("\C-cb" . org-iswitchb))  
  )



(use-package undo-tree
  :bind (("M-/" . undo-tree-undo))
  :init
  (undo-tree-mode)
  :config
  (global-undo-tree-mode t)  
  )



(use-package org-ac
  :ensure t
  :defer t
  :config
  (org-ac/config-default)
  )

;; Make config suit for you. About the config item, eval the following sexp.
;; (customize-group "org-ac")



(require 'auto-complete-config)
(ac-config-default)
(add-to-list 'ac-modes 'text-mode)         ;; text-modeでも自動的に有効にする
(add-to-list 'ac-modes 'fundamental-mode)  ;; fundamental-mode
(add-to-list 'ac-modes 'org-mode)
(add-to-list 'ac-modes 'yatex-mode)
(ac-set-trigger-key "TAB")
(setq ac-use-menu-map t)       ;; 補完メニュー表示時にC-n/C-pで補完候補選択
(setq ac-use-fuzzy t)          ;; 曖昧マッチ



(autoload 'run-prolog "prolog" "Start a Prolog sub-process." t)
(autoload 'prolog-mode "prolog" "Major mode for editing Prolog programs." t)
(autoload 'mercury-mode "prolog" "Major mode for editing Mercury programs." t)
(setq prolog-system 'swi)
(setq auto-mode-alist (append '(("\\.pl$" . prolog-mode)
				("\\.swi$" . prolog-mode)
                                ("\\.m$" . mercury-mode))
                               auto-mode-alist))


(setq recentf-max-saved-items 2000) ;; 2000ファイルまで履歴保存する
(setq recentf-auto-cleanup 'never)  ;; 存在しないファイルは消さない
(setq recentf-exclude '("/recentf" "COMMIT_EDITMSG" "/.?TAGS" "^/sudo:" "/\\.emacs\\.d/games/*-scores" "/\\.emacs\\.d/\\.cask/" "/\\.emacs\\.d/elpa/"))
(setq recentf-auto-save-timer (run-with-idle-timer 30 t 'recentf-save-list))
(put 'narrow-to-region 'disabled nil)



;; SLIMEのロード
(use-package slime
  :config
  (setq inferior-lisp-program "sbcl")
  (slime-setup '(slime-repl slime-fancy slime-banner)) )

(org-babel-do-load-languages
 'org-babel-load-languages '((C . t)))

(require 'undohist)
(undohist-initialize)
;;; 永続化を無視するファイル名の正規表現
(setq undohist-ignored-files
      '("/tmp/" "COMMIT_EDITMSG"))

(use-package auto-save-buffers-enhanced
  :ensure t
  :config
  ;;; 1秒後に保存
  (setq auto-save-buffers-enhanced-interval 1)
  (auto-save-buffers-enhanced t)
;;; Wroteのメッセージを抑制
  (setq auto-save-buffers-enhanced-quiet-save-p t)
  )


(use-package web-mode
  :ensure t)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[gj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

;;helm

(use-package helm
  :bind (("M-x" . helm-M-x)
	 ("M-y" . helm-show-kill-ring)
	 ("C-x b" . helm-mini)
	 ("C-x C-f" . helm-find-files)  )
  :config
  (helm-autoresize-mode 1)
  (helm-mode 1)
  )

(use-package helm-config
  :config (helm-mode 1))

(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to do persistent action
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB works in terminal
(define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z


(use-package which-key
  :config
;;; 3つの表示方法どれか1つ選ぶ
  (which-key-setup-side-window-bottom)    ;ミニバッファ
;; (which-key-setup-side-window-right)     ;右端
;; (which-key-setup-side-window-right-bottom) ;両方使う
  (which-key-mode 1)
  )

;;yasnippet
(use-package yasnippet
  :ensure t
  :defer t
  :config
  (yas-global-mode 1)
  )


(defvar mode-line-cleaner-alist
  '( ;; For minor-mode, first char is 'space'
    (yas-minor-mode . " Ys")
    (paredit-mode . " Pe")
    (eldoc-mode . "")
    (abbrev-mode . "")
    (undo-tree-mode . " Ut")
    (elisp-slime-nav-mode . " EN")
    (helm-gtags-mode . " HG")
    (flymake-mode . " Fm")
    ;; Major modes
    (lisp-interaction-mode . "Lisp")
    (python-mode . "Py")
    (ruby-mode   . "Rb")
    (emacs-lisp-mode . "Elisp")
    (markdown-mode . "Mkd")))

;;mode lineの設定
(defun clean-mode-line ()
  (interactive)
  (loop for (mode . mode-str) in mode-line-cleaner-alist
        do
        (let ((old-mode-str (cdr (assq mode minor-mode-alist))))
          (when old-mode-str
            (setcar old-mode-str mode-str))
          ;; major mode
          (when (eq mode major-mode)
            (setq mode-name mode-str)))))

(add-hook 'after-change-major-mode-hook 'clean-mode-line)
(use-package exec-path-from-shell
  :ensure t
  :config
  (setq exec-path-from-shell-check-startup-files nil)
  (exec-path-from-shell-initialize)
  )

(use-package jedi
  :ensure t
 ; :defer t
  )
(add-hook 'python-mode-hook
          '(lambda()
             (jedi:ac-setup)
             (setq jedi:complete-on-dot t)
             (local-set-key (kbd "M-TAB") 'jedi:complete)))

(use-package elpy
  :config
  (elpy-enable)
  )


(use-package spaceline :ensure t
  :disabled t
  :config
  (setq-default mode-line-format '("%e" (:eval (spaceline-ml-main)))))

(use-package spaceline-config :ensure spaceline
  :disabled t
  :config
  (spaceline-helm-mode 1)
  (spaceline-spacemacs-theme))

(use-package spaceline-all-the-icons
  :disabled t
  :after spaceline
  :config (spaceline-all-the-icons-theme))

(use-package smart-mode-line
  :ensure t
  :init
  (column-number-mode t) ;; 列番号の表示
  (line-number-mode t) ;; 行番号の表示
  (defvar sml/no-confirm-load-theme t)
  (defvar sml/theme 'dark) ;; お好みで
  (defvar sml/shorten-directory -1) ;; directory pathはフルで表示されたいので
  (sml/setup)
  )

(use-package keyfreq
  :config
  (keyfreq-mode 1)
  (keyfreq-autosave-mode 1)
  )

(set-language-environment 'Japanese)
(prefer-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)
(setq file-name-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)

