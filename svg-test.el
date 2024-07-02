(require 'svg)
(defun x (point) "get x component of POINT" (car point))
(defun y (point) "get y component of POINT" (cdr point))
;; without intern string delimiters are printed verbatim into the path d attribute
(defun cm (length) "format LENGTH as string in centimeters"
       (intern (format "%i%s" length "cm")))
(defun mm (length) "format LENGTH as string in millimeters"
       (intern (format "%i%s" length "mm")))

(setq svg (svg-create (cm 12) (cm 8) :stroke-width (mm 1)))
(setq circle '(6 . 4)) ; circle mid-point
(setq radius 3)        ; same circle
(setq description (format "Circle: |x² + y²| <= %i" radius))
(svg-circle svg (cm (x circle)) (cm (y circle)) (cm radius)
            :fill-color "blue"
            :stroke "black")
(svg-text svg description
          :x (cm (- (x circle) radius))
          :y (cm (y circle))
          :font-family "Fira Code")
(setq commands
      (list
       (list 'moveto (list (cons (cm (x circle)) (cm (+ (y circle) radius)))))
       (list 'lineto (list (cons (cm (x circle)) (cm (- (y circle) radius)))))))
(svg-path svg commands :stroke-color "black" :fill-color "blue")
(with-temp-file "circle.svg"
    (set-buffer-multibyte nil)
    (svg-print svg))
