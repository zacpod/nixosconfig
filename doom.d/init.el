;;; init.el -*- lexical-binding: t; -*-

(doom! :input

       :completion
       (corfu +orderless)
       (vertico +icons)

       :ui
       doom
       doom-dashboard
       doom-quit
       (emoji +unicode)
       hl-todo
       indent-guides
       ligatures
       modeline
       nav-flash
       ophints
       (popup +defaults)
       tabs
       treemacs
       unicode
       vc-gutter
       vi-tilde-fringe
       window-select
       workspaces

       :editor
       (evil +everywhere)
       file-templates
       fold
       (format +onsave)
       multiple-cursors
       snippets

       :emacs
       dired
       electric
       (ibuffer +icons)
       undo
       vc

       :term
       vterm

       :checkers
       syntax
       (spell +flyspell)

       :tools
       (eval +overlay)
       lookup
       (lsp +peek)
       magit
       (pdf)
       (terraform)

       :os
       (:if IS-LINUX tty)

       :lang
       emacs-lisp
       (go +lsp)
       (cc +lsp)            ; C / C++
       (sh +lsp)             ; bash, your homelab scripts
       (json)
       (yaml)
       (markdown +grip)
       (org +pretty +roam2)
       (web)                 ; for any JS/TS work

       :config
       (default +bindings +smartparens))
