scriptencoding utf-8

nnoremap <C-z> <Nop>

" " insert mode で細かく undo できるようにする
" inoremap <Del> <C-g>u<Del>
" inoremap <C-w> <C-g>u<C-w>
" inoremap <C-u> <C-g>u<C-u>

" like emacs
inoremap <C-a> <C-o>_
inoremap <C-e> <End>
inoremap <C-f> <Right>
inoremap <C-b> <Left>

" 選択範囲で . を実行
xnoremap . :normal! .<CR>

" シンボリックリンクの先に移動する
nnoremap cd <Cmd>exec 'lcd ' .. resolve(expand('%:p:h')) \| pwd<CR>

nnoremap <silent><expr> <Space>vs. (&filetype ==# 'lua' ? '<Cmd>luafile %<CR>' : '<Cmd>source %<CR>')

" update は変更があったときのみ保存するコマンド
nnoremap <Space>w <Cmd>update<CR>
nnoremap <Space>W <Cmd>update!<CR>

" function! s:quit(...) abort
"   let l:bang = get(a:, 1, v:false) ? '!' : ''
"   try
"     execute 'quit' .. l:bang
"   catch /\v(E5601|E37)/
"     " Neovimでタブの最後のウィンドウで、float window があると、エラーになるため
"     execute 'tabclose' .. l:bang
"   endtry
" endfunction
" nnoremap <Space>q <Cmd>call <SID>quit()<CR>
" nnoremap <Space>Q <Cmd>call <SID>quit(v:true)<CR>
nnoremap <Space>q <Cmd>quit<CR>
nnoremap <Space>Q <Cmd>quit!<CR>

" window 操作
nnoremap s <Nop>

nnoremap sh <C-w>h
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l

nnoremap sH <C-w>H
nnoremap sJ <C-w>J
nnoremap sK <C-w>K
nnoremap sL <C-w>L

nnoremap sn <Cmd>new<CR>
nnoremap sp <Cmd>split<CR>
nnoremap sv <Cmd>vsplit<CR>

" カレントウィンドウを新規タブで開く
nnoremap st <C-w>T

" 新規タブ
nnoremap so <Cmd>tabedit<CR>

" タブ間の移動
nnoremap gt <Nop>
nnoremap gT <Nop>
nnoremap <C-l> gt
nnoremap <C-h> gT

" 先頭と末尾
nnoremap <Space>h ^
xnoremap <Space>h ^
nnoremap <Space>l $
xnoremap <Space>l $h

" 上下の空白に移動
" https://twitter.com/Linda_pp/status/1108692192837533696
nnoremap <silent> <C-j> <Cmd>keepjumps normal! '}<CR>
nnoremap <silent> <C-k> <Cmd>keepjumps normal! '{<CR>
xnoremap <silent> <C-j> '}
xnoremap <silent> <C-k> '{

" 見た目通りに移動
nnoremap j gj
nnoremap k gk

" 中央にする
nnoremap G Gzz

" カーソル位置から行末までコピー
nnoremap Y y$

" 全行コピー
nnoremap <Space>ay <Cmd>%y<CR>

" 最後にコピーしたテキストを貼り付ける
nnoremap <Space>p "0p
xnoremap <Space>p "0p

" 直前に実行したマクロを実行する
nnoremap Q @@

" ハイライトの消去
nnoremap <Esc><Esc> <Cmd>noh<CR>

" <C-]> で Job mode に移行
tnoremap <Esc> <C-\><C-n>

" コマンドラインで emacs っぽく
cnoremap <C-a> <Home>
cnoremap <C-f> <Right>
cnoremap <C-b> <Left>
cnoremap <C-d> <Del>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" / -> \/ にする
cnoremap <expr> / getcmdtype() ==# '/' ? '\/' : '/'

" :h magic
" markonm/traces.vim のバグ？で、 set incsearch が消えるため
nnoremap / :<C-u>set incsearch<CR>/\v

" クリップボード内の文字列をそのまま検索
nnoremap <Space>/ /\V<C-r>+<CR>

" 全行で置換
nnoremap <Space>s<Space> :<C-u>%s///g<Left><Left>

" カレントバッファを検索
nnoremap <Space>gg :vimgrep // %:p<Left><Left><Left><Left><Left>

" help
xnoremap <A-h> "hy:help <C-r>h<CR>
nnoremap <A-h> :h 
xnoremap K     <Nop>

" クリップボードの貼り付け
inoremap <C-r><C-r> <C-r>+
cnoremap <C-o>      <C-r>+

" tyru さんのマッピング
" https://github.com/tyru/config/blob/master/home/volt/rc/vimrc-only/vimrc.vim#L618
inoremap <C-l><C-l> <C-x><C-l>
inoremap <C-l><C-n> <C-x><C-n>
inoremap <C-l><C-k> <C-x><C-k>
inoremap <C-l><C-t> <C-x><C-t>
inoremap <C-l><C-i> <C-x><C-i>
inoremap <C-l><C-]> <C-x><C-]>
inoremap <C-l><C-f> <C-x><C-f>
inoremap <C-l><C-d> <C-x><C-d>
inoremap <C-l><C-v> <C-x><C-v>
inoremap <C-l><C-u> <C-x><C-u>
inoremap <C-l><C-o> <C-x><C-o>
inoremap <C-l><C-s> <C-x><C-s>
inoremap <C-l><C-p> <C-x><C-p>

" plugins.vim を開く
nnoremap <Space>v, <Cmd>call vimrc#drop_or_tabedit(g:plug_script)<CR>
nnoremap <Space>v. <Cmd>execute 'split ' .. g:plug_script<CR>

" new tempfile
nnoremap sf <Cmd>call <SID>new_tmp_file()<CR>
function! s:new_tmp_file() abort
  let l:ft = input('FileType: ', '', 'filetype')
  if l:ft ==# ''
    echo 'Cancel.'
    return
  endif

  " もし空ならそのバッファを使う
  let l:cmd = line('$') ==# 1 && getline(1) && !&modified ? 'e' : 'new'
  exec l:cmd .. ' '.. tempname()
  exec 'setfiletype ' .. l:ft
endfunction

" 再描画
nnoremap <Space>e <Cmd>call <SID>reopen()<CR>
function! s:reopen() abort
  let l:winview = winsaveview()
  e!
  call winrestview(l:winview)
endfunction

" quickfix をトグル
nnoremap <A-q> <Cmd>call <SID>toggle_quickfix()<CR>
function! s:toggle_quickfix() abort
  let l:is_show_qf = v:false
  for l:win in nvim_tabpage_list_wins(0)
    let l:buf = nvim_win_get_buf(l:win)
    if nvim_buf_get_option(l:buf, 'buftype') ==# 'quickfix'
      let l:is_show_qf = v:true
      break
    endif
  endfor

  if l:is_show_qf
    if &buftype ==# 'quickfix'
      exec 'wincmd p'
    endif
    exec 'cclose'
  else
    exec 'botright copen'
  endif
endfunction

nnoremap [q <Cmd>cprev<CR>
nnoremap ]q <Cmd>cnext<CR>
" 先頭
nnoremap [[ <Cmd>cfirst<CR>

" toggle option
function! s:toggle_option(key, opt) abort
  exec printf('nnoremap %s <Cmd>setlocal %s!<CR> \| <Cmd>set %s?<CR>', a:key, a:opt, a:opt)
endfunction
call s:toggle_option('<F2>', 'wrap')
call s:toggle_option('<F3>', 'readonly')

function! s:ripgrep(text) abort
  " let l:regex = input("Grep string> ")
  " " let l:input = input(printf("Grep string> "))
  " if empty(l:regex)
  "   call nvim_echo([['Calcel.', 'WarningMsg']], v:false, [])
  "   return
  " endif

  let l:cwd = input("cwd> ", getcwd(), 'dir')
  if !isdirectory(l:cwd)
    call nvim_echo([[printf('Not exists "%s"', l:cwd), 'WarningMsg']], v:false, [])
    return
  endif

  let l:save_cwd = getcwd()
  try
    noautocmd execute 'lcd ' .. l:cwd
    " ! をつけると、最初のマッチにジャンプしなくなる
    execute printf("silent grep! '%s'", a:text)
  catch /.*/
    noautocmd execute 'lcd ' .. l:save_cwd
  endtry
endfunction

command! -nargs=1 Rg call <SID>ripgrep(<q-args>)
nnoremap <Space>fg :<C-u>Rg 


" nnoremap <Space>d. <Cmd>call vimrc#drop_or_tabedit('~/dict')<CR>

" カレントバッファのパスを入力
cnoremap <C-x> <C-r>%

nnoremap x "_x

" 便利
onoremap ( t(
onoremap ) t)
onoremap [ t[
onoremap ] t]
onoremap { t{
onoremap } t}
onoremap " t"
onoremap ' t'
onoremap ` t`

nnoremap <Space>dt <Cmd>windo diffthis<CR>
nnoremap <Space>do <Cmd>windo diffoff<CR>

nnoremap ; g;zz

nnoremap sq <Cmd>tabo<CR>

nnoremap sc <Cmd>tabclose<CR>
" nnoremap sl <Cmd>only<CR>

" let s:float_tmp = {}
" let s:float_tmp.buf = v:null
" let s:float_tmp.win = v:null
" 
" " function! s:glow_width() abort
" "   " 横幅を広げる
" "   let l:len = len(line('.'))
" "   echo l:len
" "   let l:width = nvim_win_get_config(s:float_tmp.win).width
" "   if l:len > l:width
" "     call nvim_win_set_config(s:float_tmp.win, {
" "     \ 'width': l:len - l:width
" "     \})
" "   endif
" " endfunction
" 
" function! s:hide_tiknot() abort
"   call nvim_win_hide(s:float_tmp.win)
" endfunction
" 
" function! s:open_tiknot() abort
"   " カーソルの近くに使い捨てのフローティングウィンドウを表示する
"   if s:float_tmp.buf ==# v:null
"     let s:float_tmp.buf = nvim_create_buf(v:false, v:true)
"   endif
" 
"   " cursor って使えないの？
"   let s:float_tmp.win = nvim_open_win(s:float_tmp.buf, v:true, {
"  \ 'relative': 'cursor',
"  \ 'width': 40,
"  \ 'height': 15,
"  \ 'col': 10,
"  \ 'row': 3,
"  \ 'focusable': v:true,
"  \ 'style': 'minimal',
"  \ 'border': 'shadow',
"  \})
" 
"   setlocal winhl=Normal:TikNotNormal,EndOfBuffer:TikNotNormal
" 
"   setlocal cursorline
"   setlocal number
" 
"   nnoremap <buffer> q  <Cmd>call <SID>hide_tiknot()<CR>
"   nnoremap <buffer> si <Cmd>call <SID>hide_tiknot()<CR>
" 
"   augroup TikNot
"     autocmd!
"     autocmd WinLeave <buffer> call <SID>hide_tiknot()
"   augroup END
" endfunction
" nnoremap si <Cmd>call <SID>open_tiknot()<CR>

" 現在の位置に対応する ) にジャンプ
noremap <Space>a) ])
noremap <Space>a] ]]
noremap <Space>a} ]}

" noremap m) ])
" noremap m} ]}
"
" vnoremap m] i]o``
" vnoremap m( i)``
" vnoremap m{ i}``
" vnoremap m[ i]``
"
" nnoremap dm] vi]o``d
" nnoremap dm( vi)``d
" nnoremap dm{ vi}``d
" nnoremap dm[ vi]``d
"
" nnoremap cm] vi]o``c
" nnoremap cm( vi)``c
" nnoremap cm{ vi}``c
" nnoremap cm[ vi]``c


" 選択場所を新しいタブで開く
nnoremap <silent> <Space>at  <Cmd>tabnew<Cr>]p:call deletebufline('%', 1, 1)<Cr>
vnoremap <silent> <Space>at y<Cmd>tabnew<Cr>]p:call deletebufline('%', 1, 1)<Cr>
