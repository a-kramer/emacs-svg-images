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

(setq svg (svg-create (cm 12) (cm 8) :stroke-width (mm 1)))
(setq circle (cons (cm 6) (cm 4))) ; circle mid-point
(setq radius (cm 3))               ; same circle
(setq description (format "Circle: sqrt(x² + y²) <= %i" radius))
(svg-circle svg (x circle) (y circle) radius
            :fill-color "blue"
            :stroke "black")
(svg-text svg description
          :x (- (x circle) radius)
          :y (y circle)
          :font-family "Fira Code"
          :font-size (pt 14)) ; svg font-size is in px not pt, apparently
(setq commands
      (list
       (list 'moveto (list (cons (x circle) (+ (y circle) radius))))
       (list 'lineto (list (cons (x circle) (- (y circle) radius))))))
(svg-path svg commands :stroke-color "black" :fill-color "blue")
(with-temp-file "circle-px.svg"
    (set-buffer-multibyte nil)
    (svg-print svg))

