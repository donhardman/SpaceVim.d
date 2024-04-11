" Syntax highlighting for .rec files
if exists("b:current_syntax")
  finish
endif

syn keyword recKeyword block input output
syn match recDivider /^–––\+$/
syn region recString start=+%{+ end=+}+

hi def link recKeyword Keyword
hi def link recDivider Comment
hi def link recString String

let b:current_syntax = "rec"
