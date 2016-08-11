(require 'package)
(add-to-list 'package-archives
                          '("melpa" . "https://melpa.org/packages/") t)

(defun prettify ()
  ;; Improve the look of emacs

  ;; Shrink font
  (set-face-attribute 'default nil :height 100)
  ;; Smart line breaking
  (global-visual-line-mode)
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1))

(prettify)
