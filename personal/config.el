;; Package dependencies
(prelude-require-packages '(
                            forge
                            dired-du
                            counsel-tramp
                            restclient
                            doom-modeline
                            ;; lsp-java
                            multiple-cursors
                            org-bullets
                            ;; docker
                            ;; use-package
                            devdocs
                            ripgrep
                            pandoc-mode
                            all-the-icons
                            all-the-icons-dired
                            dashboard
                            ;; treemacs
                            ;; golden-ratio
                            ng2-mode
                            ))
;; Appearance
;; (setq prelude-minimalistic-ui t)
;; (golden-ratio-mode 1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(global-nlinum-mode -1)
(require 'doom-modeline)
(doom-modeline-mode 1)
(setq doom-modeline-height 20)
(add-hook 'dired-mode-hook 'all-the-icons-dired-mode)
(add-hook 'dired-mode-hook
          (lambda () (dired-hide-details-mode +1)))
;; Dashboard
(require 'dashboard)
(dashboard-setup-startup-hook)
;; (setq dashboard-set-heading-icons t)
;; (setq dashboard-set-file-icons t)
(setq dashboard-items '((recents  . 5)
                        (bookmarks . 5)
                        (projects . 5)
                        ))

;; Font
(cond
 ((find-font (font-spec :name "Firacode"))
  (set-frame-font "Firacode-10"))
 ((find-font (font-spec :name "Hack"))
  (set-frame-font "Hack-11"))
 ((find-font (font-spec :name "inconsolata"))
  (set-frame-font "inconsolata-13"))
 ((find-font (font-spec :name "Noto Sans"))
  (set-frame-font "Noto Sans-12"))
 ((find-font (font-spec :name "DejaVu Sans Mono"))
  (set-frame-font "DejaVu Sans Mono-12")))

(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

;; Defaults
(global-subword-mode 1)
(dired-async-mode t)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
(setq password-cache-expiry nil)
(setq prelude-guru nil)
(setq dired-du-size-format t)
(setq-default sentence-end-double-space nil)
(setq doc-view-continuous t)
(add-to-list 'write-file-functions 'delete-trailing-whitespace)
(require 'forge)
(add-to-list 'forge-alist '("gitlab.eurofunk.com" "gitlab.eurofunk.com/api/v4" "gitlab.eurofunk.com" forge-gitlab-repository))
(remove-hook 'before-save-hook 'tide-format-before-save)

;; Defuns and keymap
(defun comment-or-uncomment-line-or-region ()
  "Comments or uncomments the current line or region."
  (interactive)
  (if (region-active-p)
      (comment-or-uncomment-region (region-beginning) (region-end))
    (comment-or-uncomment-region (line-beginning-position) (line-end-position))
    ))

(defun dired-get-size ()
  (interactive)
  (let ((files (dired-get-marked-files)))
    (with-temp-buffer
      (apply 'call-process "/usr/bin/du" nil t nil "-sch" files)
      (message "Size of all marked files: %s"
               (progn
                 (re-search-backward "\\(^[0-9.,]+[A-Za-z]+\\).*total$")
                 (match-string 1))))))

;; Global keys
(global-set-key (kbd "M-SPC") 'cycle-spacing)
(global-set-key (kbd "C-c c") 'comment-or-uncomment-line-or-region)
(require 'multiple-cursors)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
;; Dired keys
(define-key dired-mode-map (kbd "q") 'kill-this-buffer)
(define-key dired-mode-map "a" 'dired-up-directory)
(define-key dired-mode-map (kbd "?") 'dired-get-size)

;; (require 'lsp-java)
;; (add-hook 'java-mode-hook #'lsp)

;; (setq js-indent-level 2)
;; (setq typescript-indent-level 2)
;; (setq tide-completion-enable-autoimport-suggestions t)
;; (setq tide-format-options
;; '(:insertSpaceAfterFunctionKeywordForAnonymousFunctions t :placeOpenBraceOnNewLineForFunctions nil :indentSize 2 :tabSize 2))

(add-hook 'typescript-mode-hook
          (lambda ()
            (define-key typescript-mode-map (kbd "M-RET") 'tide-fix)
            (define-key typescript-mode-map (kbd "M-'") 'tide-documentation-at-point)
            (define-key typescript-mode-map (kbd "M-7") 'tide-references)
            ;; (define-key typescript-mode-map (kbd "M-f7") 'tide-references)
            (setq typescript-indent-level 2)
            ;; (require 'web-mode)
            ;; (add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))
            ;; (add-hook 'web-mode-hook
            ;;           (lambda ()
            ;;             (when (string-equal "html" (file-name-extension buffer-file-name))
            ;;               (setup-tide-mode))))
            ;; enable typescript-tslint checker
            ;; (flycheck-add-mode 'typescript-tslint 'web-mode)
            ;; (setq tide-fo)
            (setq tide-format-options '(:insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces 0))
            ))
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))
(add-hook 'web-mode-hook
          (lambda ()
            (when (string-equal "html" (file-name-extension buffer-file-name))
              (setup-tide-mode))))
;; enable typescript-tslint checker
(flycheck-add-mode 'typescript-tslint 'web-mode)

(projectile-register-project-type 'npm '("package.json")
                                  :project-file "package.json"
                                  :compile "cd ~/projects/ems/ && chmod +x gradlew && ./gradlew clean && ./gradlewassemble"
                                  :test "npm run ng test --watch=true"
                                  :run "npm run serve:local"
                                  :test-suffix ".spec")

(add-to-list 'forge-alist '("git.internal.cloudflight.io" "git.internal.cloudflight.io/api/v4" "git.internal.cloudflight.io" forge-gitlab-repository))

;; (add-to-list 'forge-alist '("gitlab.eurofunk.com" "gitlab.eurofunk.com/api/v4" "gitlab.eurofunk.com" forge-gitlab-repository))
