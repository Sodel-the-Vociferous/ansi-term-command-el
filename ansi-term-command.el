;;; ansi-term-command.el --- Run commands with args in ansi-term buffers

;;; Author: Daniel Ralston <Wubbulous@gmail.com>
;;; Version: 0.1.1
;;; Url: https://github.com/Sodel-the-Vociferous/inline-crypt-el
;;; Keywords: terminal, eshell

;;; Commentary:

;;; See the README!

;;; License:

;; Copyright (C) 2013, Daniel Ralston <Wubbulous@gmail.com>

;; This file is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License Version 2 as
;; published by the Free Software Foundation.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this file.  If not, see <http://www.gnu.org/licenses/>.

;; This file is not part of GNU Emacs.


;;; Code:

;;;###autoload
(defun ansi-term-command-setup-atc-alias ()
  (interactive)
  (defalias 'atc 'ansi-term-command))

;;;###autoload
(defun ansi-term-command (program &rest switches)
  "Start a terminal-emulator in a new buffer."

  ;; This seems wasteful, just to get the program name. But I'm lazy,
  ;; and there's no argument to limit the number of chunks to split
  ;; into, so, geronimo!
  (interactive (split-string-and-unquote
                (read-from-minibuffer "Run command: "
                                      (or explicit-shell-file-name
                                          (getenv "ESHELL")
                                          (getenv "SHELL")
                                          "/bin/sh"))))

  (let* ((switches-str (mapconcat (lambda (x) (format "%s" x))
                                  switches " "))
         (new-buffer-name (generate-new-buffer-name
                           (concat "*term:" program "*")))
         (term-ansi-buffer-name
          (if (string-empty-p switches-str)
              (term-ansi-make-term new-buffer-name program)
            (term-ansi-make-term new-buffer-name program nil switches-str))))
    (set-buffer term-ansi-buffer-name)
    (term-mode)
    (term-char-mode)

    ;; Historical baggage: keep both C-x and C-c as escape chars. Add
    ;; a term-mode hook if you want to change it.
    (let (term-escape-char)
      (term-set-escape-char ?\C-x))

    (switch-to-buffer term-ansi-buffer-name)))

(provide 'ansi-term-command)

;;; ansi-term-command.el ends here
