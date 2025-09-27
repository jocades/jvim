" keywords
syntax keyword pacoKeyword var fun class for while return if else and or do then end loop in break continue

" numbers
syntax match pacoNumber "\v\d+"

" strings
syntax region pacoString start=/"/ end=/"/ contains=NONE keepend

" function declarations
syntax match pacoFuncDecl "\vfun\s+\zs[a-zA-Z_][a-zA-Z0-9_]*"

" variables
syntax match pacoVariable "\v[a-zA-Z_][a-zA-Z0-9_]*"

" booleans
syntax keyword pacoBoolean true false

" constants
syntax keyword pacoConstant nil

" functions
syntax keyword pacoFunction print echo

" operators
syntax match pacoOperator "[+\-*/=<>]"

" comments
syntax match pacoComment "\v//.*$"

" braces
syntax match pacoBrace "[{}]"
syntax match pacoParen "[()]"
syntax match pacoBracket "[\[\]]"
syntax match pacoSemi ";"
syntax match pacoComma ","

highlight link pacoKeyword Keyword
highlight link pacoComment Comment
highlight link pacoNumber Number
highlight link pacoString String
highlight link pacoFuncDecl Function
highlight link pacoVariable Variable
highlight link pacoBoolean Boolean
highlight link pacoConstant Constant
highlight link pacoFunction Function
highlight link pacoOperator Operator
highlight link pacoBrace Delimiter
highlight link pacoParen Delimiter
highlight link pacoBracket Delimiter
highlight link pacoSemi Delimiter
highlight link pacoComma Delimiter
