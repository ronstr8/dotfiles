
;; Macros for conditional settings
;; (originally from http://www.dotfiles.com/files/6/125_sukria.emacs)

(defmacro GNUEmacs (&rest x)
  (list 'if (string-match "GNU Emacs 20" (version)) (cons 'progn x)))
(defmacro XEmacs (&rest x)
  (list 'if (string-match "XEmacs 21" (version)) (cons 'progn x)))
(defmacro insideX (&rest x)
  (list 'if (eq window-system 'x) (cons 'progn x)))
(defmacro outsideX (&rest x)
  (list 'if (eq window-system 'x) () (cons 'progn x)))

;; Personalization

(setq user-mail-address "straight@adiant.com")

;; Personal Functions

(defun my-recenter ()
  (interactive)
  (font-lock-fontify-buffer)
  (recenter)
)

(defun my-save-home-desktop ()
  (interactive)
  (desktop-save "~/.emacs.d")
  (message "Desktop saved.")
)

(defun switch-to-other-buffer ()
  (interactive)
  (switch-to-buffer (other-buffer))
)

;; Key Bindings

(global-set-key [(control tab)] `switch-to-other-buffer)
(global-set-key [f10] 'my-save-home-desktop)
(global-set-key [f11] 'delete-other-windows)
(global-set-key [f12] '(lambda () (interactive) (kill-buffer (current-buffer))))
(global-set-key "\C-l" 'my-recenter)
(global-set-key [(control next)] 'next-buffer)
(global-set-key [(control prior)] 'previous-buffer)
;; As per http://svn.openfoundry.org/pugs/docs/quickref/unicode, but not working for me :(
;; (global-set-key [?\C-#] 'ucs-insert)

;; Fonts
;; Truetype fonts will only work with experimental emacs-snapshot builds supporting Xft

;(insideX
; (set-default-font "-microsoft-consolas-medium-r-normal-*-12-*-*-*-m-*-iso8859-1")
;)

;; Restore frame size and colors



;(insideX
  (setq default-frame-alist '(
			      (width  . 120)
			      (height . 30)
			      ))
  (set-face-background 'default "Wheat")
  (set-face-foreground 'default "Black")
;)

;(outsideX
;  (set-face-background 'default "Gray")
;  (set-face-foreground 'default "Black")
;)

;; Editing

(setq x-select-enable-clipboard t)
(setq transient-mark-mode 't)
(setq delete-key-deletes-forward t)
(setq next-line-add-newlines nil)
(setq tab-width 4)
(put 'narrow-to-region 'disabled nil)

;; Scrolling and Display

(setq scroll-step 1)
(setq scroll-conservatively 1)
(setq next-screen-context-lines 0)
(setq pop-up-windows nil)
(setq passwd-invert-frame-when-keyboard-grabbed nil)
(setq inhibit-splash-screen t)
(setq frame-title-format (concat invocation-name "@" system-name ": %b %+%+ %f"))

;; Autosave and Backup Options
;; 
;; (setq auto-save-directory "~/.emacs.d/autosave"
;;       auto-save-timeout nil
;;       auto-save-default nil)
;; 
;; (setq save-place-file "~/.emacs.d/emacs-places")
;; 
;; These are a few of my favorite modes

(if (fboundp 'global-font-lock-mode)
    (global-font-lock-mode t)
)
(setq font-lock-mode-maximum-decoration t)

;;;;; (outsideX
;;;;;   (menu-bar-mode nil)  ;; Menubar useless in an Xterm
;;;;; )
;;;;; 
;;;;; ;(load "pc-select")
;;;;; ;(pc-selection-mode)
;;;;; 
;;;;; ;(load "desktop")
;;;;; ;(desktop-load-default)
;;;;; ;(desktop-read "~/.emacs.d")
;;;;; 
;;;;; ;(msb-mode)   ;; Don't like how it hides the buffers in submenus
;;;;; ;(ruler-mode) ;; Ruler up top to keep me under 80 columns, a little noisy
;;;;; 
;;;;; ;; Copied from /usr/share/emacs/23.1.50/lisp/menu-bar.el.gz
;;;;; 	(defun menu-bar-update-buffers-1 (elt)
;;;;; 	 (let* ((buf (car elt))
;;;;; 			(file
;;;;; 			 (and (if (eq buffers-menu-show-directories 'unless-uniquify)
;;;;; 				   (or (not (boundp 'uniquify-buffer-name-style))
;;;;; 					(null uniquify-buffer-name-style))
;;;;; 				   buffers-menu-show-directories)
;;;;; 			  (or (buffer-file-name buf)
;;;;; 			   (buffer-local-value 'list-buffers-directory buf)))))
;;;;; 	  (cons (if buffers-menu-show-status
;;;;; 			 (let ((mod (if (buffer-modified-p buf) "*" ""))
;;;;; 				   (ro (if (buffer-local-value 'buffer-read-only buf) "%" "")))
;;;;; 			  (if file
;;;;; 			   (format "%s  %s%s" file mod ro )
;;;;; 			   (format "%s  %s%s" (cdr elt) mod ro)))
;;;;; 			 (if file
;;;;; 			  (format "%s  --  %s"  (cdr elt) file)
;;;;; 			  (cdr elt)))
;;;;; 	   buf)))
;;;;; ;; Load customizations made from within Emacs
;;;;; 



;; Load custom.el

;(setq custom-file "~/.emacs.d/custom.el")
;(load custom-file)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(backup-directory-alist (quote (("." . "~/.emacs.d/backup/"))))
 '(column-number-mode t)
 '(cua-mode t nil (cua-base))
 '(desktop-save-mode t)
 '(fringe-mode (quote (0)) nil (fringe))
 '(save-interprogram-paste-before-kill t)
 '(save-place t nil (saveplace))
 '(size-indication-mode t)
 '(tool-bar-mode nil)
 '(x-select-enable-clipboard t)
 '(x-select-enable-primary t)
 '(yank-pop-change-selection t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Consolas" :foundry "microsoft" :slant normal :weight normal :height 120 :width normal)))))
