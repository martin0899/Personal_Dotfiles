" Configuración de Coc.nvim
if has('nvim')
  let g:coc_global_extensions = [
        \ 'coc-snippets',
        \ 'coc-highlight',
        \ 'coc-pairs',
        \ 'coc-explorer',
        \ 'coc-yank',
        \ 'coc-lists',
        \ 'coc-json',
        \ 'coc-tsserver',
        \ 'coc-eslint',
        \ 'coc-prettier',
        \ 'coc-html',
        \ 'coc-html-css-support',
	\ 'coc-tsserver',
	\ ]


 " Configuración de coc.nvim para navegar 

inoremap <expr> <Tab> pumvisible() ? "\<C-y>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Mapeos para comandos Coc
nnoremap <silent><nowait> <space>ca  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent><nowait> <space>ce  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent><nowait> <space>cc  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent><nowait> <space>co  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent><nowait> <space>cs  :<C-u>CocList -I symbols<cr>
" Do default action for next item
nnoremap <silent><nowait> <space>cn  :<C-u>CocNext<CR>
" Do default action for previous item
nnoremap <silent><nowait> <space>cp  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent><nowait> <space>cr  :<C-u>CocListResume<CR>
" Mapeo de tecla para dar formato al código
nmap <silent> <leader>l :call CocAction('formatSelected')<CR>

nmap <silent> <leader>o :call CocAction('format')<CR>

endif


