scriptencoding utf-8

if empty(globpath(&rtp, 'autoload/coc.vim'))
    finish
endif

" 移動 (go)
nmap <silent> gd <Plug>(coc-definition)
" nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" エラー個所に移動
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" " カレント行のコードアクションを実行
" nmap <space>ac  <Plug>(coc-codeaction)

" " カレント行の問題を修正
" nmap <space>qf  <Plug>(coc-fix-current)

nnoremap <Space>bl :<C-u>call CocAction('format')<CR>

" カーソル下の単語をハイライトする
autocmd CursorHold * silent call CocActionAsync('highlight')