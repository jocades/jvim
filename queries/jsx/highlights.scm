;; extends

((jsx_attribute 
  (property_identifier) @name (#any-of? @name "class" "className")
  (string (string_fragment) @value) (#set! @value conceal "…")))
