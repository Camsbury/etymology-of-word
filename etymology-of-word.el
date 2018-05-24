;;; etymology-of-word.el --- Display the etymology of a word in Emacs. -*- lexical-binding: t -*-

(require 'url-parse)
(require 'url-http)
(require 'dash)

;;;###autoload
(defun etymology-of-word (word)
  "Provide etymology of WORD from the Online Etymology Dictionary"
  (interactive (list (read-string "Word: ")))
  (let ((link (concat "https://etymonline.com/word/" (downcase word))))
    (url-retrieve
     link
     (lambda (status)
       (re-search-forward "<object>")
       (setq beg (point))
       (re-search-forward "</object>")
       (setq end (point))
       (->> (buffer-substring beg end)
           (replace-regexp-in-string "<.*?>" "")
           (replace-regexp-in-string "&quot;" "\"")
           (message))))))

;;;###autoload
(defun etymology-of-word-at-point ()
  "Call `etymology-of-word' on the point or marked phrase"
  (interactive)
  (if (region-active-p)
      (etymology-of-word
       (buffer-substring-no-properties
        (region-beginning)
        (region-end)))
    (etymology-of-word (substring-no-properties
                        (thing-at-point 'word)))))

(provide 'etymology-of-word)
