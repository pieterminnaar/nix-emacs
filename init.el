(require 'package)

;; Add melpa to your packages repositories
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/") t)

(load-theme 'tango-dark)

(setq x-select-enable-primary t)
(global-auto-revert-mode 1)
;;(global-auto-complete-mode t)

(iswitchb-mode 1)

(iswitchb-mode 1)
 ;; (defun iswitchb-local-keys ()
 ;;  (mapc (lambda (K)
 ;; (let* ((key (car K)) (fun (cdr K)))
 ;;             (define-key iswitchb-mode-map (edmacro-parse-keys key) fun)))
 ;;           '(("<right>" . iswitchb-next-match)
 ;;             ("<left>"  . iswitchb-prev-match)
 ;;             ("<up>"    . ignore             )
 ;;             ("<down>"  . ignore             ))))

(defun iswitchb-local-keys ()
 (mapc (lambda (K)
   (let* ((key (car K)) (fun (cdr K)))
            (define-key iswitchb-mode-map (edmacro-parse-keys key) fun)))
          '(("C-f"      . iswitchb-next-match)
            ("C-b"      . iswitchb-prev-match)
            ("<right>"  . iswitchb-next-match)
            ("<left>"   . iswitchb-prev-match))))
(add-hook 'iswitchb-define-mode-map-hook 'iswitchb-local-keys)

(global-set-key (kbd "M-z") 'shell)

(setq mouse-drag-copy-region t)

;; prevent emacs from copying files when dragging from explorer
(setq dired-dnd-protocol-alist nil)


(package-initialize)

 (setq python-shell-interpreter "python3")


;; Install use-package if not already installed
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)

(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

;; Enable defer and ensure by default for use-package
;; Keep auto-save/backup files separate from source code:  https://github.com/scalameta/metals/issues/1027
(setq use-package-always-defer t
      use-package-always-ensure t
      backup-directory-alist `((".*" . ,temporary-file-directory))
      auto-save-file-name-transforms `((".*" ,temporary-file-directory t)))

;; Enable scala-mode for highlighting, indentation and motion commands
(use-package scala-mode
  :mode "\\.s\\(cala\\|bt\\)$")

;; Enable sbt mode for executing sbt commands
(use-package sbt-mode
  :commands sbt-start sbt-command
  :config
  ;; WORKAROUND: https://github.com/ensime/emacs-sbt-mode/issues/31
  ;; allows using SPACE when in the minibuffer
  (substitute-key-definition
   'minibuffer-complete-word
   'self-insert-command
   minibuffer-local-completion-map)
   ;; sbt-supershell kills sbt-mode:  https://github.com/hvesalai/emacs-sbt-mode/issues/152
   (setq sbt:program-options '("-Dsbt.supershell=false"))
)

;; Enable nice rendering of diagnostics like compile errors.
(use-package flycheck
  :init (global-flycheck-mode))

(use-package lsp-mode
  ;; Optional - enable lsp-mode automatically in scala files
  :hook  (scala-mode . lsp)
         (lsp-mode . lsp-lens-mode)
  :config (setq lsp-prefer-flymake nil))

;; Enable nice rendering of documentation on hover
(use-package lsp-ui)

;; lsp-mode supports snippets, but in order for them to work you need to use yasnippet
;; If you don't want to use snippets set lsp-enable-snippet to nil in your lsp-mode settings
;;   to avoid odd behavior with snippets and indentation
(use-package yasnippet)

;; Add company-lsp backend for metals
(use-package company-lsp)

;; Use the Debug Adapter Protocol for running tests and debugging
(use-package posframe
  ;; Posframe is a pop-up tool that must be manually installed for dap-mode
  )
 (use-package dap-mode
  :hook
  (lsp-mode . dap-mode)
  (lsp-mode . dap-ui-mode)
  )

;; Use the Tree View Protocol for viewing the project structure and triggering compilation
(use-package lsp-treemacs
  :config
  (lsp-metals-treeview-enable t)
  (setq lsp-metals-treeview-show-when-views-received t)
  )
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (auto-complete lsp-scala lsp-treemacs dap-mode posframe company-lsp lsp-ui lsp-mode yasnippet use-package scala-mode sbt-mode flycheck))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
