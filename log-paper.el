;;; In this version of the file, we write all values in rounded
;;; pixels.  The cm function now converts the input length from cm to
;;; px. The DPI value will make the picture the intended size
;;; only on screens that have this DPI, otherwise the final size will
;;; be different. The viewBox doesn't matter anymore.
(require 'svg)
(defun x (point) "get x component of POINT" (car point))
(defun y (point) "get y component of POINT" (cdr point))
(setq dpi 96) ; this is the value that Inkscape uses, SVG doesn't store this
(setq ppi 72) ; points per inch
(defun cm (length) "convert a LENGTH given in centimeters to pixels using a DPI value"
       (round (/ (* length dpi) 2.54)))
(defun mm (length) "convert a LENGTH given in millimeters to pixels"
       (round (/ (* length dpi) 25.4)))
(defun pt (size) "convert a SIZE given in points to pixels (using DPI and PPI)"
       (round (/ (* size dpi) ppi)))
(setq a4w (mm 210)) ;; 794
(setq a4h (mm 297)) ;; 1123
(setq margin (mm 4));; 15
(setq w (- a4w margin margin)) ;; 764
(setq h (- a4h margin margin)) ;; 1093
(setq left margin)
(setq right (- a4w margin))
(setq top margin)
(setq bottom (- a4h margin))
(defun last-elt (lst) "return the last element of a list" (car (last lst)))
(defun interpolate (v m a) "scale number to be between margin and width or height, a"
       (+ (* a (/ (float x) m)) margin))
(defalias 'seq 'number-sequence)

(setq minor-1 (append (seq 1 3 0.1) (seq 4 10 1) (seq 10 30 1)  (seq 40 100 10)))
(setq minor-5 (append (seq 1 10 0.5) (seq 10 100 5)))
(setq major-1 (append '(1) (seq 10 100 10)))

;; create the svg
(setq svg (svg-create a4w a4h :stroke-width 1))

(defun log-scale (l a) "create a series of log-scale values scaled to page-size"
       (mapcar (lambda (x) (interpolate x (log (last-elt l)) a))
               (mapcar 'log l)))

(defun v-line (x color thickness) "draw a vertical line within bounds" (svg-polyline svg (list (cons (round x) top) (cons (round x) bottom)) :stroke-color color :stroke-width thickness))
(defun h-line (y color thickness) "draw a horizontal line within bounds" (svg-polyline svg (list (cons left (round y)) (cons right (round y))) :stroke-color color :stroke-width thickness))

(setq Lx-1 (log-scale minor-1 w))
(setq Lx-5 (log-scale minor-5 w))
(setq Mx-1 (log-scale major-1 w))
(setq Ly-1 (log-scale minor-1 h))
(setq Ly-5 (log-scale minor-5 h))
(setq My-1 (log-scale major-1 h))
;; vertical lines
(dolist (x Lx-1) (v-line x "gray" 1)) ;; help-lines
(dolist (x Lx-5) (v-line x "black" 2)) ;; help-lines
(dolist (x Mx-1) (v-line x "red" 3))
;; horizontal lines
(dolist (y Ly-1) (h-line y "gray" 1)) ;; help-lines
(dolist (y Ly-5) (h-line y "black" 2)) ;; help-lines
(dolist (y My-1) (h-line y "red" 3))

(svg-rectangle svg margin margin w h :fill-color "none" :stroke-width 3 :stroke-color "red")

(with-temp-file "log-paper.svg"
    (set-buffer-multibyte nil)
    (insert "<!-- all numbers in px (not pt) -->")
    (svg-print svg)
    (break-xml))

