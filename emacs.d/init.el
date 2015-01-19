(tool-bar-mode nil)
(setq vc-follow-symlinks t)
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))

(setq my-package-list '(ack cider company ido magit rainbow-delimiters
			))
(mapc 'package-install my-package-list)

(add-hook 'after-init-hook 'my-after-init-hook)
(defun my-after-init-hook ()
  (require 'ack)
  (require 'cider)
  (require 'ido)
  (ido-mode t)
  (rainbow-delimiters-mode t)
  )


(add-hook 'after-init-hook 'global-company-mode)

