;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
;;
;; Author       : Berkcan Ucan <hello@alca.dev> (alcadramin)
;; Gitlab       : @alcadramin
;; Github       : @alcadramin
;;
;; Licensed under the MIT License (MIT).
;;;

;; Personal info
(setq user-full-name "Berkcan Uçan"
      user-mail-address "hello@alca.dev")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;      CUSTOMIZATION
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq doom-theme 'doom-tokyo-night)

;; Set Font
(setq doom-font
      (font-spec :family "Victor Mono" :size 14 :weight 'bold)
      doom-variable-pitch-font (font-spec :family "Victor Mono" :size 14)
      doom-big-font (font-spec :family "Victor Mono" :size 16))

(after! doom-themes
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t))

;; Make comments etc. italic
(custom-set-faces!
  '(font-lock-comment-face :slant italic)
  '(font-lock-keyword-face :slant italic))

(setq display-line-numbers-type t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;      AUTO-COMPLETE (Company)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Format on save.
(setq +format-on-save-enabled-modes
      '(not emacs-lisp-mode
            sql-mode
            tex-mode
            latex-mode))

(setq company-idle-delay 0)
(setq company-show-quick-access t)

;; TabNine - Proprietary AI autocompletion plugin
(use-package company-tabnine
  :ensure t)
(add-to-list 'company-backends #'company-tabnine)
(add-to-list 'company-backends #'company-tide)

(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  (company-mode +1))
(setq company-tooltip-align-annotations t)

(eval-after-load 'rjsx-mode
  '(progn
     (define-key rjsx-mode-map "<" nil)))

(add-hook 'js2-mode-hook #'setup-tide-mode)
(setq lsp-file-watch-threshold 10000)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;      KEYBINDINGS
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Line keybindings
(setq display-line-numbers-type t)
(map! :leader
      :desc "Comment or uncomment lines" "TAB TAB" #'comment-line
      (:prefix ("t" . "toggle")
       :desc "Toggle line numbers" "l" #'doom/toggle-line-numbers
       :desc "Toggle line highlight in frame" "h" #'hl-line-mode
       :desc "Toggle line highlight globally" "H" #'global-hl-line-mode
       :desc "Toggle truncate lines" "t" #'toggle-truncate-lines))

;; Set "[SPC] + [d] -> [t]" to enable treemacs-mode
(map! :leader
      (:prefix ("d". "Treemacs")
       :desc "Treemacs mode" "t" 'treemacs))

;; Set "[SPC] + [-] -> [a]" to edit agenda file
(map! :leader
      (:prefix ("-" . "open file")
       :desc "Edit agenda file" "a" #'(lambda () (interactive) (find-file "~/Documents/Org/agenda.org"))))

;; Set "[SPC] + [v] -> [v]" to launch vterm
(map! :leader
     (:prefix ("v". "vterm")
     :desc "Launch vterm" "v" 'vterm))

;; "[CTRL] + [#]" select next occurance
(define-key global-map (kbd "C-#") 'mc/mark-next-like-this-word)

;; "[CTRL] + [']" select all occurances
(define-key global-map (kbd "C-'") 'mc/mark-all-words-like-this)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;      MISC CONFIG (Disabling most of it for now, it's getting bloat :P)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Enable beacon
(beacon-mode 1)
(setq beacon-color '"#ff9e64")

;; Enable rainbow mode
(add-hook 'css-mode-hook #'rainbow-mode)

;; Org mode stuff
(setq org-directory "~/Org/")

;; PDF Minor Mode
(use-package pdf-view
  :hook (pdf-tools-enabled . pdf-view-midnight-minor-mode)
  :hook (pdf-tools-enabled . hide-mode-line-mode)
  :config
  (setq pdf-view-midnight-colors '("#eff0eb" . "#282a36")))

;; Centaur Tabs
;(setq centaur-tabs-set-bar 'over
;      centaur-tabs-set-icons t
;      centaur-tabs-gray-out-icons 'buffer
;      centaur-tabs-height 24
;      centaur-tabs-set-modified-marker t
;      centaur-tabs-style "bar"
;      centaur-tabs-modified-marker "•")
;(map! :leader
;      :desc "Toggle tabs globally" "t c" #'centaur-tabs-mode
;      :desc "Toggle tabs local display" "t C" #'centaur-tabs-local-mode)
;(evil-define-key 'normal centaur-tabs-mode-map (kbd "g <right>") 'centaur-tabs-forward        ; default Doom binding is 'g t'
;                                               (kbd "g <left>")  'centaur-tabs-backward       ; default Doom binding is 'g T'
;                                               (kbd "g <down>")  'centaur-tabs-forward-group
;                                               (kbd "g <up>")    'centaur-tabs-backward-group)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;      DASHBOARD
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq initial-buffer-choice (lambda () (get-buffer-create "*dashboard*")))

(use-package dashboard
  :init        
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  (setq dashboard-banner-logo-title "Doom Emacs")
  (setq dashboard-image-banner-max-height 400)
  (setq dashboard-startup-banner (file-truename "~/.doom.d/images/akame2.png"))
  (setq dashboard-center-content t) ;; set to 't' for centered content
  (setq dashboard-items '((recents . 5)
                          (projects . 5)
                          (bookmarks . 5)
                          (agenda . 5 )))
  :config
  (dashboard-setup-startup-hook)
  (dashboard-modify-heading-icons '((recents . "file-text")
                                (bookmarks . "book"))))

(setq doom-fallback-buffer "*dashboard*")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;      DIRED
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(map! :leader
      (:prefix ("d" . "dired") ;; Map dired to "SPC + d -> d"
       :desc "Open dired" "d" #'dired
       :desc "Dired jump to current" "j" #'dired-jump)
      (:after dired
       (:map dired-mode-map
        :desc "Peep-dired image previews" "d p" #'peep-dired
        :desc "Dired view file" "d v" #'dired-view-file)))

(evil-define-key 'normal dired-mode-map
  (kbd "M-RET") 'dired-display-file
  (kbd "h") 'dired-up-directory
  (kbd "l") 'dired-open-file ; use dired-find-file instead of dired-open.
  (kbd "m") 'dired-mark
  (kbd "t") 'dired-toggle-marks
  (kbd "u") 'dired-unmark
  (kbd "C") 'dired-do-copy
  (kbd "D") 'dired-do-delete
  (kbd "J") 'dired-goto-file
  (kbd "M") 'dired-chmod
  (kbd "O") 'dired-chown
  (kbd "P") 'dired-do-print
  (kbd "R") 'dired-rename
  (kbd "T") 'dired-do-touch
  (kbd "Y") 'dired-copy-filenamecopy-filename-as-kill
  (kbd "+") 'dired-create-directory
  (kbd "-") 'dired-up-directory
  (kbd "% l") 'dired-downcase
  (kbd "% u") 'dired-upcase
  (kbd "; d") 'epa-dired-do-decrypt
  (kbd "; e") 'epa-dired-do-encrypt)
(evil-define-key 'normal peep-dired-mode-map
  (kbd "j") 'peep-dired-next-file
  (kbd "k") 'peep-dired-prev-file)
(add-hook 'peep-dired-hook 'evil-normalize-keymaps)
(add-hook 'dired-mode-hook 'all-the-icons-dired-mode)
(setq dired-open-extensions '(("gif" . "feh")
                              ("jpg" . "feh")
                              ("png" . "feh")
                              ("mkv" . "mpv")
                              ("mp4" . "mpv")))
