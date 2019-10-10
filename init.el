;; init.el --- Load the full configuration -*- lexical-binding: t -*-
;; Commentary:

; This file is currently the only manual configuration.

;; Code:

; set up package repositories.
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
         '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

; package management (unless a package is already installed, synchronize with repositories and install package.
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

; uses use-package to manage other packages... Ensures that all packages are installed and enabled.
(use-package which-key
  :ensure t
  :init
  (which-key-mode))

; org mode bootstrap
(use-package ox-twbs
  :ensure t)

; bullets
(use-package org-bullets
  :ensure t
  :config
  (add-hook 'org-mode-hook 'org-bullets-mode))

; Allows editing with files that need further permission
(use-package sudo-edit
  :ensure t
  :bind ("C-c e" . sudo-edit))

; theme
(use-package spacemacs-common
    :ensure spacemacs-theme
    :config (load-theme 'spacemacs-dark t))

; toggle dark-light theme
(use-package heaven-and-hell
  :ensure t
  :init
  (setq heaven-and-hell-theme-type 'dark) ; Omit to use light by default
  (setq heaven-and-hell-themes
    '((light . spacemacs-light)
      (dark . spacemacs-dark))) ; Themes can be the list: (dark . (tsdh-dark wombat))
  :hook (after-init . heaven-and-hell-init-hook)
  :bind (("C-c <f6>" . heaven-and-hell-load-default-theme)
     ("<f6>" . heaven-and-hell-toggle-theme)))

; relative line
(use-package linum-relative
  :ensure t
  :init

  ; Use `display-line-number-mode` as linum-mode's backend for smooth performance
  (setq linum-relative-backend 'display-line-numbers-mode))

(use-package expand-region
  :ensure t
  :bind ("C-q" . er/expand-region))

; project management
(use-package projectile
  :ensure t
  :init
    (projectile-mode 1))

; dashboard for load-up
(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-items '((recents . 10)
              (projects . 5)
              (agenda . 5)))
  (setq dashboard-startup-banner "~/.emacs.d/img/emacs.png")
  (setq dashboard-banner-logo-title
    (format "Emacs ready in %.2f seconds with %d garbage collections."
        (float-time (time-subtract after-init-time before-init-time)) gcs-done)))

(use-package rainbow-delimiters
  :ensure t
  :init
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

(use-package rainbow-mode
  :ensure t
  :init (add-hook 'prog-mode-hook 'rainbow-mode))

(use-package neotree
  :ensure t
  :bind ([f8] . neotree-toggle))

(use-package ido-vertical-mode
  :ensure t
  :init (ido-vertical-mode 1)
  :config (setq ido-vertical-define-keys 'C-n-and-C-p-only))

(use-package smex
  :ensure t
  :init (smex-initialize))

(use-package ivy
  :ensure t
  :bind ("C-c C-r" . 'ivy-resume)
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t))

(use-package swiper
  :ensure t
  :bind ("C-s" . swiper))

(use-package counsel
  :ensure t
  :config (counsel-mode))

(use-package undo-tree
  :ensure t
  :init (setq undo-tree-visualizer-timestamps t)
  :config (global-undo-tree-mode))

(use-package multiple-cursors
  :ensure t
  :config
  (global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
  (global-set-key (kbd "C->") 'mc/mark-next-like-this)
  (global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
  (global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this))

(use-package yasnippet
  :ensure t
  :config
  (use-package yasnippet-snippets
    :ensure t)
  (yas-reload-all)
  (yas-global-mode 1))

(use-package flycheck
  :ensure t
  :init (add-hook 'prog-mode-hook 'flycheck-mode))

(use-package company
  :ensure t
  :config
  (setq company-idle-delay 0)
  (setq company-minimum-prefix-length 2)
  :init
  (add-hook 'after-init-hook 'global-company-mode))

; tooltips
(use-package company-quickhelp
  :ensure t
  :config
  (setq company-quickhelp-delay 1)
  (company-quickhelp-mode))

; git
(use-package magit
  :ensure t)

(use-package git-gutter
  :ensure t
  :config
  (global-git-gutter-mode +1))

(use-package evil-leader
  :ensure t
  :config
  (global-evil-leader-mode)
  (evil-leader/set-leader "<SPC>"))

(use-package evil
  :ensure t
  :bind ("C-c b t" . evil-switch-to-windows-last-buffer)
  :init
  (setq evil-normal-state-cursor '("orchid")
    evil-emacs-state-cursor '("light blue")
    evil-insert-state-cursor '("SpringGreen" bar)
    evil-replace-state-cursor '("chocolate1" hbar)
    evil-visual-state-cursor '("gray"))
  :config
  (evil-mode 1)
  ; remap C-u for vim-like functionality.
  (define-key evil-normal-state-map (kbd "C-u") 'evil-scroll-up)
  (define-key evil-visual-state-map (kbd "C-u") 'evil-scroll-up)
  (define-key evil-insert-state-map (kbd "C-u")
    (lambda ()
      (interactive)
      (evil-delete (point-at-bol) (point)))))

(use-package evil-mc
  :ensure t
  :config
  (global-evil-mc-mode 1))

(use-package evil-nerd-commenter
  :ensure t)

(use-package evil-escape
  :ensure t
  :config
  (define-key evil-insert-state-map  (kbd "C-g") #'evil-escape)
  (define-key evil-replace-state-map (kbd "C-g") #'evil-escape)
  (define-key evil-visual-state-map  (kbd "C-g") #'evil-escape)
  (define-key evil-operator-state-map (kbd "C-g") #'evil-escape))

(use-package evil-surround
  :ensure t
  :config
  (global-evil-surround-mode 1))

(use-package quickrun
  :ensure t)

(use-package ace-window
  :ensure t
  :bind
  ("C-x o" . 'ace-window))

(use-package avy
  :ensure t
  :bind ("C-:" . avy-goto-char))

; clean mode-line with diminish
(use-package diminish
  :ensure t
  :init
  (diminish 'rainbow-mode)
  (diminish 'which-key-mode)
  (diminish 'drag-stuff-mode)
  (diminish 'subword-mode)
  (diminish 'undo-tree-mode)
  (diminish 'ivy-mode)
  (diminish 'eldoc-mode)
  (diminish 'counsel-mode))

;; hydra - command states
(use-package hydra
  :ensure t)

;; text dragging
(use-package drag-stuff
  :ensure t
  :config
  (drag-stuff-global-mode t))

;; distraction-free writing
(use-package olivetti
  :ensure t
  :init
  (setq olivetti-body-width 80))

(use-package ranger
  :ensure t
  :init (setq ranger-show-literal nil)
  :config
  (global-set-key (kbd "C-c d") 'deer)
  )

;; evil for Org-mode
(use-package evil-org
  :ensure t
  :after org
  :config
  (add-hook 'org-mode-hook 'evil-org-mode)
  (add-hook 'evil-org-mode-hook
            (lambda ()
              (evil-org-set-key-theme)))
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

;; winum for quick window switching
(use-package winum
  :ensure t
  :init
  (setq winum-keymap
    (let ((map (make-sparse-keymap)))
      (define-key map (kbd "M-0") 'winum-select-window-0-or-10)
      (define-key map (kbd "M-1") 'winum-select-window-1)
      (define-key map (kbd "M-2") 'winum-select-window-2)
      (define-key map (kbd "M-3") 'winum-select-window-3)
      (define-key map (kbd "M-4") 'winum-select-window-4)
      (define-key map (kbd "M-5") 'winum-select-window-5)
      (define-key map (kbd "M-6") 'winum-select-window-6)
      (define-key map (kbd "M-7") 'winum-select-window-7)
      (define-key map (kbd "M-8") 'winum-select-window-8)
      map))
  :config
  (winum-mode))

; Window management in emacs
(use-package eyebrowse
  :ensure t
  :config (progn
	    (define-key eyebrowse-mode-map (kbd "C-1") 'eyebrowse-switch-to-window-config-1)
	    (define-key eyebrowse-mode-map (kbd "C-2") 'eyebrowse-switch-to-window-config-2)
	    (define-key eyebrowse-mode-map (kbd "C-3") 'eyebrowse-switch-to-window-config-3)
	    (define-key eyebrowse-mode-map (kbd "C-4") 'eyebrowse-switch-to-window-config-4)
	    (define-key eyebrowse-mode-map (kbd "C-5") 'eyebrowse-switch-to-window-config-5)
	    ))
(require 'eyebrowse)
(eyebrowse-mode t)


;; fun stuff
(use-package speed-type
  :ensure t)

;; hydras
(defhydra hydra-zoom (global-map "<f2>")
  "zoom"
  ("g" text-scale-increase "in")
  ("l" text-scale-decrease "out"))

(defhydra hydra-evil-drag-stuff ()
  "drag text"
  ("k" drag-stuff-up "up")
  ("j" drag-stuff-down "down")
  ("h" drag-stuff-left "left")
  ("l" drag-stuff-right "right"))

(defhydra hydra-resize-window ()
  "resize window"
  ("[" shrink-window-horizontally "shrink horizontally")
  ("]" enlarge-window-horizontally "enlarge horizontally")
  ("{" shrink-window "shrink vertically")
  ("}" enlarge-window "enlarge vertically")
  ("=" balance-windows "balance"))

;;prefix naming
(require 'which-key)
(dolist (pf '("SPC "))
  (which-key-declare-prefixes
    (concat pf "b") "buffer"
    (concat pf "c") "comment"
    (concat pf "p") "project"
    (concat pf "r") "rings"
    (concat pf "t") "toggle"
    (concat pf "w") "window"
    (concat pf "x") "text"))

;; some experimental functions used as shortcuts in evil
(defun switch-to-scratch-buffer ()
  "Switch to scratch buffer."
  (interactive)
  (switch-to-buffer "*scratch*"))

(defun home ()
  "Switch to dashboard buffer."
  (interactive)
  (switch-to-buffer "*dashboard*"))

(defun counsel-jump-in-buffer ()
  "Jump in buffer with `counsel-imenu' or `counsel-org-goto' if in `org-mode'."
  (interactive)
  (call-interactively
   (cond
    ((eq major-mode 'org-mode) 'counsel-org-goto)
    (t 'counsel-imenu))))

;; Vim key bindings
(require 'evil-leader)
(require 'evil-nerd-commenter)
(require 'counsel)
(global-evil-leader-mode)
(evil-leader/set-key
  "."  'evilnc-copy-and-comment-operator
  "TAB" 'evil-switch-to-windows-last-buffer
  "\\" 'evilnc-comment-operator ; if you prefer backslash key
  "bh" 'home
  "bn" 'next-buffer
  "bp" 'previous-buffer
  "bs" 'switch-to-scratch-buffer
  "cc" 'evilnc-copy-and-comment-lines
  "ci" 'evilnc-comment-or-uncomment-lines
  "cl" 'evilnc-quick-comment-or-uncomment-to-the-line
  "cp" 'evilnc-comment-or-uncomment-paragraphs
  "cr" 'comment-or-uncomment-region
  "cv" 'evilnc-toggle-invert-comment-line-by-line
  "ps" 'counsel-semantic
  "ry" 'counsel-yank-pop
  "tr" 'linum-relative-toggle
  "to" 'olivetti-mode
  "wh" 'windmove-left
  "wj" 'windmove-down
  "wk" 'windmove-up
  "wl" 'windmove-right
  "ws" 'ace-swap-window
  "wd" 'ace-delete-window
  "wr" 'hydra-resize-window/body
  "xd" 'hydra-evil-drag-stuff/body
  "ji" 'counsel-jump-in-buffer
)

;; start emacs as daemon for emacsclient functionality.
(server-start)

;; debug on init
(setq debug-on-error t)

;; encoding
(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;; this calls ansi-term with bash as default shell
(defvar my-term-shell "/bin/bash")
(defadvice ansi-term (before force-bash)
  (interactive (list my-term-shell)))
(ad-activate 'ansi-term)

;; graphic stuff

(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

;; font
(set-face-attribute 'default nil :height 120 :family "Anonymous Pro")

;; highlight line
(when window-system (add-hook 'prog-mode-hook 'hl-line-mode))

;; smooth scroll
(setq scroll-conservatively 100)

;; disable bell
(setq ring-bell-function 'ignore)

;; disable backup files and auto-saving
(setq make-backup-file nil)
(setq auto-save-default nil)

;; change yes or no answer to y or n to reduce key presses
(defalias 'yes-or-no-p 'y-or-n-p)

;; easier reading
(setq scroll-margin 7)

;; correctly treats camel case as separate words
(global-subword-mode 1)

;; enable auto pairing for some types...
(setq electric-pair-pairs '(
			    (?\( . ?\))
			    (?\[ . ?\])
			    (?\{ . ?\})

			    ))
(electric-pair-mode t)

;; show paren for easy lisp editing
(show-paren-mode 1)

;; symbols enables
(when window-system (global-prettify-symbols-mode t))

;; modeline linum and column
(setq line-number-mode t)
(setq column-number-mode t)

;; semantic mode
(add-hook 'prog-mode-hook 'semantic-mode)

;; edit source in current window... no new tab
(setq org-src-window-setup 'current-window)

;; visually indent subheadings to improve readability
(add-hook 'org-mode-hook 'org-indent-mode)

;; spell checking
(add-hook 'text-mode-hook 'flyspell-mode)
(add-hook 'prog-mode-hook 'flyspell-prog-mode)

;; (setq inhibit-compacting-font-caches t)

;; makes src blocks easier to read
(setq org-src-fontify-natively t
      org-src-tab-acts-natively t)

;; time stamp when todo is done
(setq org-log-done 'time)

(global-set-key (kbd "C-c gh")
		(lambda ()
		  (interactive)
		  (require 'ranger)
		  (deer "~/.emacs.d/")))
;; agenda
(setq org-agenda-files (list "/mnt/Share/Org/organizer.org"
			     ))
;; shortcut
(global-set-key (kbd "C-c go")
		(lambda ()
		  (interactive)
		  (find-file "/mnt/Share/Org/organizer.org")))

(global-set-key (kbd "C-c gw")
		(lambda ()
		  (interactive)
		  (dired "/mnt/Share")))

;; remove suspend emacs shortcut
(global-unset-key (kbd "C-z"))

;; better buffer manager
(global-set-key (kbd "C-x C-b") 'ibuffer)

;; shortcut to open up ansi-term
(global-set-key (kbd "C-c C-<return>") 'ansi-term)

(defun my-setup-indent (n)
  ;; java/c/c++
  (setq c-basic-offset n)
  ;; web development
  (setq coffee-tab-width n) ; coffeescript
  (setq javascript-indent-level n) ; javascript-mode
  (setq js-indent-level n) ; js-mode
  (setq js2-basic-offset n) ; js2-mode, in latest js2-mode, it's alias of js-indent-level
  (setq web-mode-markup-indent-offset n) ; web-mode, html tag in html file
  (setq web-mode-css-indent-offset n) ; web-mode, css in html file
  (setq web-mode-code-indent-offset n) ; web-mode, js code in html file
  (setq css-indent-offset n) ; css-mode
  )
(my-setup-indent 4)

(defun kill-current-buffer ()
  "Kill the current buffer."
  (interactive)
  (kill-buffer (current-buffer)))
(global-set-key (kbd "C-x k") 'kill-current-buffer)

(defun config-reload ()
  "Reload config main config file."
  (interactive)
  (load-file "~/.emacs.d/init.el"))
(global-set-key (kbd "C-c c r") 'config-reload)

(defun config-edit ()
  "Find and open config file for editing."
  (interactive)
  (find-file "~/.emacs.d/init.el"))
(global-set-key (kbd "C-c c e") 'config-edit)

;; split window horizontally and let cursor position
(defun split-and-follow-horizontally ()
  "Split and follow for horizontal splits."
  (interactive)
  (split-window-below)
  (balance-windows)
  (other-window 1))
(global-set-key (kbd "C-x 2") 'split-and-follow-horizontally)

;; split window vertically and toggle cursor position
(defun split-and-follow-vertically ()
  "Split and follow for vertical splits."
  (interactive)
  (split-window-right)
  (balance-windows)
  (other-window 1))
(global-set-key (kbd "C-x 3") 'split-and-follow-vertically)

;; load looks and feels
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

;; Local Variables:
;; coding: utf-8
;; no-byte-compile: t
;; End:
;;; init.el ends here
