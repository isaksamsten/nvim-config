((module . (expression_statement (string) @rst))
 (#offset! @rst 0 3 0 -3))

; Class docstring
((class_definition
  body: (block . (expression_statement (string) @rst)))
 (#offset! @rst 0 3 0 -3))

; Function/method docstring
((function_definition
  body: (block . (expression_statement (string) @rst)))
 (#offset! @rst 0 3 0 -3))

; Attribute docstring
(((expression_statement (assignment)) . (expression_statement (string) @rst))
 (#offset! @rst 0 3 0 -3))
