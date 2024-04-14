func! configure#before() abort
  set wrap
  command! -nargs=1 Duplicate execute 'write ' . expand('%:h') . '/' . <q-args> | execute 'edit ' . expand('%:h') . '/' . <q-args>

  let g:local_history_path = $HOME . '/.local-history'
  let g:local_history_new_change_delay = 60
  let g:local_history_max_changes = 20
  let g:local_history_exclude = [ '**/node_modules/**', '*.txt', '**/vendor/**' ]

  let g:github_dashboard = { 'username': 'donhardman', 'password': $GITHUB_TOKEN }
  let g:gista#client#default_username = 'donhardman'

	let g:coc_config_home = $HOME . '/.SpaceVim.d'

  set statusline+=%{NearestMethodOrFunction()}

  set rtp+=~/.cache/vimfiles/repos/github.com/kevinhwang91/promise-async
  set rtp+=~/.cache/vimfiles/repos/github.com/kevinhwang91/nvim-ufo
  set rtp+=~/.cache/vimfiles/repos/github.com/brenoprata10/nvim-highlight-colors
	set rtp+=~/.cache/vimfiles/repos/github.com/nvim-lua/plenary.nvim
	set rtp+=~/.cache/vimfiles/repos/github.com/nvim-pack/nvim-spectre
  lua << EOF
		vim.o.foldcolumn = '1' -- '0' is not bad
		vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
		vim.o.foldlevelstart = 99
		vim.o.foldenable = true

		vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
		vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)

		require('ufo').setup()

		-- Ensure termguicolors is enabled if not already
		vim.opt.termguicolors = true

		require('nvim-highlight-colors').setup({})
		-- This code executes on server in case of remote UI open
		-- and let us to keep server runing even when we close the nvim
		vim.keymap.set('n', '<leader>q', function()
			for _, ui in pairs(vim.api.nvim_list_uis()) do
				if ui.chan and not ui.stdout_tty then
					vim.fn.chanclose(ui.chan)
				end
			end
		end, { noremap = true })

		require('spectre').setup({
			default = {
				replace = {
					cmd = "oxi"
				}
			},
			is_insert_mode = true
		})
EOF
endf

func! configure#after() abort	
	inoremap <C-x> <C-o>x
  inoremap <C-a> <C-o>^
  inoremap <C-e> <C-o>$
  inoremap <C-u> <C-o>d^
	inoremap <C-k> <C-o>d$
  inoremap <M-b> <C-o>B
  inoremap <M-f> <C-o>w
  inoremap <C-CR> <C-o>o
  inoremap <C-z> <C-o>u
  inoremap <S-Tab> <C-d>
	nnoremap <esc> :noh<return><esc>
	nnoremap <space>s/ :Spectre<CR>
	set showtabline=0
	set fixendofline

  if has("gui_running")
    " Settings for MacVim and Inconsolata font
    let g:CtrlSpaceSymbols = { "File": "◯", "CTab": "▣", "Tabs": "▢" }
  endif

  runtime! syntax/rec.vim
  autocmd BufNewFile,BufRead *.rec,*.rep set filetype=rec
endf

