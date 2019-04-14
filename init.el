;; set up package repositories.
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/"))
(package-initialize)
;; package management (unless a package is already installed, synchronize with repositories and install package.
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(unless (package-installed-p 'dracula-theme)
  (package-refresh-contents)
  (package-install 'dracula-theme))

;; uses use-package to manage other packages... Ensures that all packages are installed and enabled.
(use-package which-key
  :ensure t
  :init
  (which-key-mode))

;; load settings.
(org-babel-load-file (expand-file-name "~/.emacs.d/config.org"))

;; load looks and feels
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)
