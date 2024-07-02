(require 'svg)
(setq svg (svg-create "12cm" "8cm" :stroke-width "3mm"))
(setq circle '(6 . 4)) ; circle mid-point
(setq radius 3)        ; same circle
(defun x (point) "get x component of POINT" (car point))
(defun y (point) "get y component of POINT" (cdr point))
(defun cm (length) "format LENGTH as string in centimeters"
       (intern (format "%i%s" length "cm"))) ; without intern string delimiters are printed verbatim into the path d attribute
(setq description (format "Circle: |x² + y²| <= %i" radius))
(svg-circle svg (cm (x circle)) (cm (y circle)) (cm 3)
            :fill-color "blue"
            :stroke "black")
(svg-text svg description
          :x (cm (- (x circle) radius))
          :y (cm (y circle))
          :font-family "Fira Code")
(setq commands
      (list
       (list 'moveto (list (cons (cm (x circle)) (cm (+ (y circle) 50)))))
       (list 'lineto (list (cons (cm (x circle)) (cm (- (y circle) 50)))))))
(svg-path svg commands :stroke-color "black")
(with-temp-file "circle.svg"
    (set-buffer-multibyte nil)
    (svg-print svg))
