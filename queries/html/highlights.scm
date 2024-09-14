;; extends

((attribute 
  (attribute_name) @name (#eq? @name "class")
  (quoted_attribute_value (attribute_value) @value) (#set! @value conceal "…"))) 
