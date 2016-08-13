(defun go-go-emacs ()
  (setup-package-management)
  (bootstrap-use-package)
  (prettify)
  (install-plugins)
  (set-global-bindings))

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
  (set-face-attribute 'default nil :height 100)
  (setq inhibit-splash-screen t)
  (setq inhibit-startup-message t)
  (global-visual-line-mode)
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (setup-theme)
  (setup-smart-modeline)
  (show-trailing-whitespace))

(defun setup-smart-modeline ()
  (use-package smart-mode-line
    :init
    (display-time-mode 1)
    (setq rm-whitelist " #")
    (add-hook 'prog-mode-hook 'column-number-mode)
    (setq sml/theme 'respectful)
    (setq sml/no-confirm-load-theme t)
    (sml/setup)))

(defun setup-theme ()
  (if window-system
      (load-window-theme)
    (load-terminal-theme)))

(defun load-window-theme ()
  (use-package solarized-theme
    :init (load-theme 'solarized-dark t)))

(defun load-terminal-theme ()
  (use-package monokai-theme
    :init (load-theme 'monokai t)))

(defun show-trailing-whitespace ()
  (add-hook 'text-mode-hook 'set-trailing-whitespace)
  (add-hook 'prog-mode-hook 'set-trailing-whitespace))

(defun set-trailing-whitespace ()
  (setq show-trailing-whitespace t))

(defun setup-evil ()
  (use-package key-chord)
  (use-package evil
    :init
    (evil-mode 1)
    (key-chord-mode 1)
    (key-chord-define evil-insert-state-map "jk" 'evil-normal-state))
  (setup-relative-line-numbers)
  (setup-evil-escape)
  (setup-evil-leader))

(defun setup-relative-line-numbers ()
  (use-package nlinum-relative
    :init
    (nlinum-relative-setup-evil)
    (set-face-attribute 'nlinum-relative-current-face nil
			:inherit 'linum
			:foreground nil
			:background nil)
    (add-hook 'prog-mode-hook 'nlinum-relative-mode)
    (add-hook 'text-mode-hook 'nlinum-relative-mode)))

(defun setup-evil-leader ()
  (use-package evil-leader
    :init
    (global-evil-leader-mode)
    (evil-leader/set-leader "<SPC>")
    (setq evil-leader/in-all-states t)
    (setq evil-leader/non-normal-prefix "C-")
    (add-leader-bindings)))

(defun setup-evil-escape ()
  (use-package evil-escape
    :init
    (evil-escape-mode)
    (setq-default evil-escape-key-sequence "jk")))

(defun add-leader-bindings ()
  (evil-leader/set-key "x" 'helm-M-x)
  (evil-leader/set-key "f" 'helm-find-files)
  (evil-leader/set-key "g" 'magit-status)
  (evil-leader/set-key "F" 'helm-recentf)
  (evil-leader/set-key "b" 'helm-mini)
  (evil-leader/set-key "p" 'helm-projectile)
  (evil-leader/set-key "a" 'org-agenda)
  (evil-leader/set-key "s" 'save-buffer)
  (evil-leader/set-key "e" 'eshell)
  (evil-leader/set-key "k" 'kill-buffer)
  (evil-leader/set-key "x" 'helm-M-x)
  (evil-leader/set-key "0" 'delete-window)
  (evil-leader/set-key "1" 'delete-other-windows)
  (evil-leader/set-key "w" 'persp-switch)
  (evil-leader/set-key "o" 'other-window))

(defun setup-helm ()
  (use-package helm
    :init
    (helm-mode 1)
    (define-key helm-map (kbd "C-k") #'helm-previous-line)
    (define-key helm-map (kbd "C-j") #'helm-next-line)
    (define-key helm-find-files-map (kbd "C-h") #'helm-find-files-up-one-level)
    (define-key helm-find-files-map (kbd "C-l") nil)
    (define-key helm-map (kbd "C-l") #'helm-execute-persistent-action)
    (helm-autoresize-mode t)))

(defun setup-projectile ()
  (use-package helm-projectile
    :commands (helm-projectile)))

(defun setup-yasnippets ()
  (use-package yasnippet
    :init
    (yas-global-mode 1)))

(defun setup-company ()
  (use-package company
    :config
    (global-company-mode)
    (evil-define-key 'insert company-mode-map (kbd "C-j") 'company-select-next)
    (evil-define-key 'insert company-mode-map (kbd "C-k") 'company-select-previous)))

(defun setup-haskell ()
  (use-package haskell-mode
    :mode ("\\.hs\\'" "\\.lhs\\'")
    :config
    (add-hook 'haskell-mode-hook 'interactive-haskell-mode)))

(defun setup-magit ()
  (use-package magit
    :commands (magit-status)
    :config
    (global-auto-revert-mode t)
    (use-package evil-magit)))

(defun setup-shells ()
  (use-package eshell
    :commands (eshell)
    :init (setup-eshell)))

(defun setup-eshell ()
  (setq
   eshell-buffer-shorthand t
   eshell-cmpl-ignore-case t
   eshell-cmpl-cycle-completions nil
   eshell-history-size 10000
   eshell-hist-ignoredups t
   eshell-error-if-no-glob t
   eshell-glob-case-insensitive t
   eshell-scroll-to-bottom-on-input 'all)

  (add-hook 'eshell-mode-hook
	    (lambda ()
	      (eshell-cmpl-initialize)
	      (setup-eshell-keybindings))))

(defun setup-eshell-keybindings ()
  (define-key eshell-mode-map [remap eshell-pcomplete] 'helm-esh-pcomplete)
  (evil-define-key 'insert eshell-mode-map (kbd "C-r") 'helm-eshell-history))

(defun setup-persp ()
  (use-package persp-mode
    :commands (persp-switch)
    :init (persp-mode)))

(defun setup-circe ()
  (use-package circe
    :commands (circe)
    :config
    (set-channels)
    (circe-prettify)
    (circe-enable-logging)))

(defun set-channels ()
  (setq circe-network-options
	'(("Freenode"
	   :nick "emmettu"
	   :realname "Emmett Underhill"
	   :channels ("#izverifier" "#haskell" "#emacs"))
	  ("vanaltj"
	   :nick "emmettu"
	   :realname "Emmett Underhill"
	   :host "irc.vanaltj.com"
	   :port "6667"
	   :channels ("#botland" "#oldterns")))))

(defun circe-prettify ()
  (setq circe-reduce-lurker-spam t)
  (enable-circe-color-nicks)
  (setq circe-color-nicks-everywhere t))

(defun circe-enable-logging ()
  (load "lui-logging" nil t)
  (enable-lui-logging-globally))

(defun irc ()
  (interactive)
  (circe "Freenode")
  (circe "vanaltj"))

(defun install-plugins ()
  (setup-evil)
  (setup-yasnippets)
  (setup-helm)
  (setup-projectile)
  (setup-company)
  (setup-haskell)
  (setup-magit)
  (setup-shells)
  (setup-persp)
  (setup-circe))

(defun set-global-bindings ()
  (global-set-key (kbd "M-h") 'evil-window-left)
  (global-set-key (kbd "M-j") 'evil-window-down)
  (global-set-key (kbd "M-k") 'evil-window-up)
  (global-set-key (kbd "M-l") 'evil-window-right))

(go-go-emacs)
