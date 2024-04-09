function! NearestMethodOrFunction() abort
  return get(b:, 'vista_nearest_method_or_function', '')
endfunction

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

  set statusline+=%{NearestMethodOrFunction()}

  " By default vista.vim never run if you don't call it explicitly.
  "
  " If you want to show the nearest function in your statusline automatically,
  " you can add the following line to your vimrc
  autocmd VimEnter * call vista#RunForNearestMethodOrFunction()

  set rtp+=~/.cache/vimfiles/repos/github.com/kevinhwang91/promise-async
  set rtp+=~/.cache/vimfiles/repos/github.com/kevinhwang91/nvim-ufo
  lua << EOF
    vim.o.foldcolumn = '1' -- '0' is not bad
    vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true

    vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
    vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)

    require('ufo').setup()

    -- This code executes on server in case of remote UI open
    -- and let us to keep server runing even when we close the nvim
    vim.keymap.set('n', '<leader>q', function()
      for _, ui in pairs(vim.api.nvim_list_uis()) do
        if ui.chan and not ui.stdout_tty then
          vim.fn.chanclose(ui.chan)
        end
      end
    end, { noremap = true })
EOF
endf

func! configure#after() abort
  let g:flygrep_executable='rg'
  let g:flygrep_arguments='--column --line-number --no-heading --color=always --smart-case --hidden --glob "!.git/*"'
endf
