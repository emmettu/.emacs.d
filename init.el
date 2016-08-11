(defun go-go-emacs ()
  (setup-package-management)
  (bootstrap-use-package)
  (prettify)
  (install-plugins))

(defun setup-package-management ()
  (require 'package)
  (setq package-enable-at-startup nil)

  (add-to-list 'package-archives
               '("melpa" . "https://melpa.org/packages/") t)
  (package-initialize))

(defun bootstrap-use-package ()
  (unless (package-installed-p 'use-package)
    (package-refresh-contents)
    (package-install 'use-package))
  (setq use-package-always-ensure t))

(defun prettify ()
  ;; Improve the look of emacs

  ;; Shrink font
  (set-face-attribute 'default nil :height 100)
  ;; Smart line breaking
  (global-visual-line-mode)
  ;; Remove GUI things
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (setup-theme)
  (setup-smart-modeline))

(defun setup-smart-modeline ()
  (use-package smart-mode-line
               :init
               (setq sml/no-confirm-load-theme t)
               (sml/setup)))

(defun setup-theme ()
  (use-package solarized-theme
               :init (load-theme 'solarized-dark t)))

(defun setup-evil ()
  (use-package key-chord)
  (use-package evil-escape)
  (use-package evil
               :init
               (evil-mode 1)
               (key-chord-mode 1)
               (key-chord-define evil-insert-state-map "jk" 'evil-normal-state)
               (evil-escape-mode)
               (setq-default evil-escape-key-sequence "jk")))

(defun setup-helm ()
  (use-package helm
               :init
               (helm-mode 1)
               (define-key helm-map (kbd "C-k") #'helm-previous-line)
               (define-key helm-map (kbd "C-j") #'helm-next-line)
               (define-key helm-find-files-map (kbd "C-h") #'helm-find-files-up-one-level)
               (define-key helm-find-files-map (kbd "C-l") 'nil)
               (define-key helm-map (kbd "C-l") #'helm-execute-persistent-action)))

(defun setup-projectile ()
  (use-package helm-projectile
               :commands (helm-projectile)))

(defun setup-yasnippets ()
  (use-package yasnippet
               :defer t
               :init
               (yas-global-mode 1)))

(defun setup-company ()
  (use-package company
               :defer t
               :config (global-company-mode)))

(defun setup-haskell ()
  (use-package haskell-mode
               :mode ("\\.hs\\'" "\\.lhs\\'")
               :config
               (add-hook 'haskell-mode-hook 'interactive-haskell-mode)))

(defun install-plugins ()
  (setup-evil)
  (setup-yasnippets)
  (setup-helm)
  (setup-projectile)
  (setup-company)
  (setup-haskell))

(go-go-emacs)
