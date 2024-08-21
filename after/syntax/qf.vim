" after/syntax/qf.vim

" Extend syntax to include additional keywords.
syntax match qfLineNr   "[^|]*"   contained contains=qfError,qfWarning,qfNote,qfInfo
syntax match qfError    "error"   contained
syntax match qfWarning  "warning" contained
syntax match qfNote     "note"    contained
syntax match qfInfo     "info"    contained
" syntax match nonUnicodeSymbol "^[^\x80-\xFF].*"
syntax match qfPipe     "|\|"
syntax region asciiLine start="^[\x00-\x7F].*" end="$" contains=NONE

" Link new syntax to DiagnosticSign highlight groups.
highlight! default link qfPipe      NonText
highlight! default link qfError     DiagnosticSignError
highlight! default link qfWarning   DiagnosticSignWarn
highlight! default link qfNote	    DiagnosticSignHint
highlight! default link qfInfo	    DiagnosticSignInfo
highlight! default link asciiLine Comment
