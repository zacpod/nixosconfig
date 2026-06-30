;;; config.el -*- lexical-binding: t; -*-

(setq user-full-name "Zac Crawforth")

;; A dark theme that won't fight your Noctalia palette too hard.
;; Swap freely — doom-themes ships dozens, M-x load-theme to preview.
(setq doom-theme 'doom-one)

(setq display-line-numbers-type 'relative)

;; org-mode directory — adjust to wherever you want your notes to live
(setq org-directory "~/org/")

;; Go: gofmt on save is handled by +lsp +format, but make sure gopls
;; is actually on PATH. On NixOS this usually means having `go` and
;; `gopls` in your systemPackages or a project-local devshell.
(after! go-mode
  (setq gofmt-command "goimports"))

;; vterm shell — match whatever your actual login shell is
(setq vterm-shell "/run/current-system/sw/bin/bash")
