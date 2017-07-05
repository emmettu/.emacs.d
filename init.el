(defun go-go-emacs ()
  (setup-package-management)
  (bootstrap-use-package)
  (prettify)
  (install-plugins)
  (set-global-bindings)
  (sane-itize-defaults))

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
  (set-default-font "Hack")
  (setq inhibit-splash-screen t)
  (setq inhibit-startup-message t)
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (setup-theme)
  (setup-smart-modeline)
  (show-trailing-whitespace)
  (setq uniquify-buffer-name-style 'post-forward))

(defun setup-smart-modeline ()
  (use-package smart-mode-line
    :init
    (setq display-time-default-load-average nil)
    (setq display-time-24hr-format t)
    (display-time-mode 1)
    ; (display-battery-mode)
    (setq rm-whitelist " #")
    (setq evil-mode-line-format nil)
    (add-hook 'prog-mode-hook 'column-number-mode)
    (setq sml/theme 'respectful)
    (setq sml/no-confirm-load-theme t)
    (sml/setup)
    (add-to-list 'sml/replacer-regexp-list '("^~/workspace/" ":WRK:") t)))

(defun setup-theme ()
  (if (daemonp)
      (add-hook 'after-make-frame-functions 'do-setup-theme)
    (do-setup-theme)))

(defun do-setup-theme (&optional frame)
  (when frame
    (select-frame frame))
  (if (display-graphic-p)
      (load-window-theme)
    (load-terminal-theme)))

(defun load-window-theme ()
  (use-package doom-themes
    :init (load-theme 'doom-one t)))

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

  (define-key evil-normal-state-map (kbd "H") #'evil-prev-buffer)
  (define-key evil-normal-state-map (kbd "L") #'evil-next-buffer)
  (setup-relative-line-numbers)
  (setup-evil-escape)
  (setup-evil-leader)
  (setup-evil-commentary))

(defun setup-relative-line-numbers ()
  (use-package linum-relative
    :init
    (linum-relative-mode)
    (setq linum-relative-current-symbol "")
    (set-face-attribute 'linum-relative-current-face nil
			:inherit 'linum
			:foreground "white"
			:weight 'normal
			:background nil)
    (add-hook 'prog-mode-hook 'linum-relative-mode)
    (add-hook 'text-mode-hook 'linum-relative-mode)))

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
    (setq-default evil-escape-key-sequence "jk")
    (setq-default evil-escape-unordered-key-sequence t)))

(defun setup-evil-commentary ()
  (use-package evil-commentary
    :init (evil-commentary-mode)))

(defun add-leader-bindings ()
  (evil-leader/set-key "x" 'counsel-M-x)
  (evil-leader/set-key "f" 'counsel-find-file)
  (evil-leader/set-key "g" 'magit-status)
  (evil-leader/set-key "F" 'counsel-recentf)
  (evil-leader/set-key "b" 'ivy-switch-buffer)
  (evil-leader/set-key "pp" 'counsel-projectile-switch-project)
  (evil-leader/set-key "pf" 'counsel-projectile-find-file)
  (evil-leader/set-key "pd" 'counsel-projectile-find-dir)
  (evil-leader/set-key "ps" 'counsel-projectile-rg)
  (evil-leader/set-key "pb" 'counsel-projectile-switch-to-buffer)
  (evil-leader/set-key "a" 'org-agenda)
  (evil-leader/set-key "s" 'save-buffer)
  (evil-leader/set-key "e" 'eshell)
  (evil-leader/set-key "t" 'shell)
  (evil-leader/set-key "r" 'deer)
  (evil-leader/set-key "k" 'kill-buffer)
  (evil-leader/set-key "0" 'delete-window)
  (evil-leader/set-key "1" 'delete-other-windows)
  (evil-leader/set-key "ww" 'eyebrowse-create-window-config)
  (evil-leader/set-key "wr" 'eyebrowse-rename-window-config)
  (evil-leader/set-key "ws" 'eyebrowse-switch-to-window-config)
  (evil-leader/set-key "wl" 'eyebrowse-next-window-config)
  (evil-leader/set-key "wh" 'eyebrowse-prev-window-config)
  (evil-leader/set-key "wp" 'eyebrowse-last-window-config)
  (evil-leader/set-key "o" 'other-window)
  (evil-leader/set-key-for-mode 'emacs-lisp-mode "i" 'counsel-imenu)
  (evil-leader/set-key-for-mode 'python-mode "i" 'counsel-imenu))

(defun setup-ivy ()
  (use-package ivy
    :config
    (ivy-mode 1)
    (define-key ivy-mode-map (kbd "C-j") #'ivy-next-line)
    (define-key ivy-mode-map (kbd "C-k") #'ivy-previous-line)
    (define-key ivy-mode-map (kbd "C-l") #'ivy-alt-done)
    (setq ivy-use-virtual-buffers t))
  (use-package counsel
    :config
    (define-key counsel-find-file-map (kbd "C-h") #'counsel-up-directory))
  (use-package swiper
    :config
    (define-key evil-normal-state-map (kbd "/") #'swiper)))

(defun setup-projectile ()
  (use-package counsel-projectile
    :commands (counsel-projectile)))

(defun setup-yasnippets ()
  (use-package yasnippet
    :defer 3
    :config
    (yas-global-mode 1)))

(defun setup-flycheck ()
  (use-package flycheck
    :defer 3
    :init
    :config
    ;(setq exec-path (append exec-path '("~/.cargo/bin")))
    ;(setenv "PATH" (concat (getenv "PATH") ":/home/emmett/.cargo/bin"))
    (add-hook 'flycheck-mode-hook 'flycheck-rust-setup)
    (global-flycheck-mode)))

(defun setup-company ()
  (use-package company
    :defer 3
    :config
    (global-company-mode)
    (define-key company-active-map [tab] 'company-select-next)
    (define-key company-active-map (kbd "TAB") 'company-select-next)
    (define-key company-active-map (kbd "<backtab>") 'company-select-previous)
    (setq company-idle-delay 0.3)))

(defun setup-cpp ()
  (use-package cc-mode
    :mode
    ("\\.cpp\\'" . c++-mode)
    ("\\.h\\'" . c++-mode)
    :config
    (use-package company-irony)
    (add-to-list 'company-backends 'company-irony)
    (flycheck-irony-setup)))

(defun setup-haskell ()
  (use-package haskell-mode
    :mode ("\\.hs\\'" "\\.lhs\\'")
    :config
    (add-hook 'haskell-mode-hook 'interactive-haskell-mode)))

(defun setup-magit ()
  (use-package magit
    :commands (magit-status)
    :config
    (use-package evil-magit)))

(defun setup-shells ()
  (use-package eshell
    :commands (eshell)
    :init (setup-eshell))
  (setq comint-prompt-read-only t)
  (setq comint-process-echoes t)
  (setq comint-buffer-maximum-size 2048)
  (add-hook 'shell-mode-hook 'setup-hist-hook)
  (add-hook 'comint-output-filter-functions 'comint-truncate-buffer)
  (define-key comint-mode-map (kbd "C-j") 'comint-next-input)
  (define-key comint-mode-map (kbd "C-k") 'comint-previous-input)
  (define-key comint-mode-map (kbd "C-r") 'counsel-shell-history))

(defun setup-hist-hook ()
  (setq comint-input-ring-file-name "~/.histfile")
  (comint-read-input-ring t))

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
  (evil-define-key 'insert eshell-mode-map (kbd "C-r") 'counsel-esh-history)
  (evil-define-key 'insert eshell-mode-map (kbd "C-j") 'eshell-next-matching-input-from-input)
  (evil-define-key 'insert eshell-mode-map (kbd "C-k") 'eshell-previous-matching-input-from-input))

(defun setup-eyebrowse ()
  (use-package eyebrowse
    :init
    (eyebrowse-mode)
    (eyebrowse-setup-evil-keys)
    (eyebrowse-setup-opinionated-keys)
    (setq eyebrowse-wrap-around t)
    (setq eyebrowse-switch-back-and-forth t)))

(defun setup-circe ()
  (use-package circe
    :commands (circe)
    :config
    (set-channels)
    (circe-prettify)
    (circe-enable-logging)
    (setq lui-flyspell-p t))
  (use-package helm-circe))

(defun set-channels ()
  (setq circe-network-options
	'(("Freenode"
	   :nick "emmettu"
	   :realname "Emmett Underhill"
	   :channels ("#izverifier" "#haskell" "#emacs"))
	  ("RHAT"
	   :nick "eunderhi"
	   :realname "Emmett Underhill"
	   :host "irc.devel.redhat.com"
	   :port "6667"
	   :channels ("#eapintern" "#eapto" "#essc" "#internTO" "#internTO2015" "#jboss" "#thefoobar" "#jbossas" "#prod" "#jbossqa" "#projectncl" "#soancl" "#toronto" "#rel-eng"))
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
  ;(circe "Freenode")
  (circe "RHAT")
  (circe "vanaltj"))

(defun setup-notmuch ()
  (use-package notmuch))

(defun setup-smtp ()
   (use-package smtpmail
     :init
     (setq message-send-mail-function 'smtpmail-send-it
	   smtpmail-stream-type 'starttls
	   smtpmail-default-smtp-server "smtp.gmail.com"
	   smtpmail-smtp-server "smtp.gmail.com"
	   smtpmail-smtp-service 587)))

(defun install-plugins ()
  (setup-evil)
  (setup-yasnippets)
  (setup-flycheck)
  (setup-ivy)
  (setup-projectile)
  (setup-company)
  (setup-dumb-jump)
  (setup-ranger)
  (setup-haskell)
  (setup-cpp)
  (setup-python)
  (setup-rust)
  (setup-magit)
  (setup-shells)
  (setup-eyebrowse)
  (setup-circe)
  (setup-notmuch)
  (setup-popwin))

(defun setup-dumb-jump ()
  (use-package dumb-jump)
  (evil-define-key 'insert prog-mode-map (kbd "C-]") 'dumb-jump-go)
  (evil-define-key 'normal prog-mode-map (kbd "C-]") 'dumb-jump-go)
  (setq dumb-jump-selector 'ivy))

(defun setup-ranger ()
  (use-package ranger
    :init
    (ranger-override-dired-mode t)
    (add-to-list 'evil-emacs-state-modes 'ranger-mode)))

(defun setup-popwin ()
  (use-package popwin
    :config
    (popwin-mode)
    (push "*shell command Output*" popwin:special-display-config)
    (push "*Warnings*" popwin:special-display-config)))

(defun setup-python ()
  (use-package python
    :mode ("\\.py\\'" . python-mode)
    :interpreter ("python" . python-mode)
    :config
    (setq python-shell-completion-native-enable nil)
    (setup-elpy)))

(defun setup-rust ()
  (use-package rust-mode
    :mode ("\\.rs\\'" . rust-mode)
    :init
    (use-package flycheck-rust)
    (use-package cargo)
    (use-package racer)
    (add-hook 'rust-mode-hook 'racer-mode)
    (add-hook 'racer-mode-hook 'eldoc-mode)
    (add-hook 'racer-mode-hook 'company-mode)
    (setenv "RUST_SRC_PATH" (concat (getenv "PATH") ":/home/emmett/.multirust/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src/"))
    :config
    (cargo-minor-mode)))

(defun setup-elpy ()
  (use-package elpy
    :init
    (elpy-enable)))

(defun set-global-bindings ()
  (global-set-key (kbd "M-h") 'evil-window-left)
  (global-set-key (kbd "M-j") 'evil-window-down)
  (global-set-key (kbd "M-k") 'evil-window-up)
  (global-set-key (kbd "M-l") 'evil-window-right)
  (global-set-key (kbd "<C-iso-lefttab>") 'evil-next-buffer)
  (global-set-key (kbd "<C-tab>") 'switch-to-prev-buffer))

(defun sane-itize-defaults ()
  (global-auto-revert-mode t)
  (setq auto-revert-verbose nil)
  (defalias 'yes-or-no-p 'y-or-n-p)
  (setq-default fill-column 80)
  (setq recentf-max-saved-items 50)
  (savehist-mode 1)
  (setq history-length 1000)
  (winner-mode 1)
  (global-subword-mode)
  (setq enable-recursive-minibuffers t)
  (setup-parens)
  (add-hook 'prog-mode-hook 'electric-pair-mode)
  (setup-smooth-scrolling))

(defun setup-parens ()
  (use-package highlight-parentheses
    :config
    (add-hook 'prog-mode-hook 'highlight-parentheses-mode)))

(defun setup-smooth-scrolling ()
  (use-package smooth-scrolling
    :init
    (smooth-scrolling-mode)
    (setq smooth-scroll-margin 1)))

(go-go-emacs)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (restclient pyenv-mode monokai-theme counsel flycheck-rust cargo flycheck-irony flycheck-google-cpplint company-irony evil-magit elpy smooth-scrolling yasnippet writeroom-mode use-package smart-mode-line popwin magit linum-relative key-chord helm-projectile helm-circe haskell-mode eyebrowse evil-leader evil-escape evil-commentary dracula-theme company))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
