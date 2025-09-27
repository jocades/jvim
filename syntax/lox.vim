syntax clear

" keywords
syntax keyword loxKeyword var fun class for while return

" identifiers (functions or variable names)
syntax match loxIdent "\v[a-zA-Z_][a-zA-Z0-9_]*" containedin=TOP

" booleans
syntax keyword loxBoolean true false

" constants
syntax keyword loxConstant nil

" functions
syntax keyword loxFunction print

" operators
syntax match loxOperator "\v\*"
syntax match loxOperator "\v\+"
syntax match loxOperator "\v\-"
syntax match loxOperator "\v/"
syntax match loxOperator "\v\="
syntax match loxOperator "\v!"


" conditionals
syntax keyword loxConditional if else and or else

" numbers
syntax match loxNumber "\v\-?\d*(\.\d+)?"

" strings
syntax region loxString start="\v\"" end="\v\""

" comments
syntax match loxComment "//.*$"

" braces
syntax match loxBrace "[{}]"
syntax match loxParen "[()]"
syntax match loxSemi ";"

highlight link loxKeyword Keyword
highlight link loxIdent Identifier
highlight link loxBoolean Boolean
highlight link loxConstant Constant
highlight link loxFunction Function
highlight link loxOperator Operator
highlight link loxConditional Conditional
highlight link loxNumber Number
highlight link loxString String
highlight link loxComment Comment
highlight link loxBrace Delimiter
highlight link loxParen Delimiter
highlight link loxSemicolon Delimiter
