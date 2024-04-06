func! configure#before() abort
  set wrap
  nnoremap <leader>s :RG<CR>
  nnoremap <leader>' ""yls<c-r>={'"': "'", "'": '"'}[@"]<cr><esc>
  
  if executable("rg")
    set grepprg=rg\ --vimgrep\ --column\ --line-number\ --no-heading\ --smart-case\ --hidden
    set grepformat=%f:%l:%c:%m
  endif

  command! -nargs=1 Duplicate execute 'write ' . expand('%:h') . '/' . <q-args> | execute 'edit ' . expand('%:h') . '/' . <q-args>

  let g:local_history_max_changes = 20
  let g:local_history_exclude = [ '**/node_modules/**', '*.txt', '**/vendor/**' ]

  let g:github_dashboard = { 'username': 'donhardman', 'password': $GITHUB_TOKEN }
  let g:gista#client#default_username = 'donhardman'

  lua << EOF
  opts = requires("codesnap.nvim")
  opts.watermark = "muvon.io"
EOF
endf

func! configure#after() abort
  let g:flygrep_executable='rg'
  let g:flygrep_arguments='--column --line-number --no-heading --color=always --smart-case --hidden --glob "!.git/*"'
endf
