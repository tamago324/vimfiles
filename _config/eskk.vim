scriptencoding utf-8

if empty(globpath(&rtp, 'autoload/eskk.vim'))
    finish
endif

if has('vim_starting')
    let g:eskk#dictionary = {'path': '~/.skk-jisyo', 'sorted': 0, 'encoding': 'utf-8'}
    let g:eskk#large_dictionary = {'path': '~/.eskk/SKK-JISYO.L', 'sorted': 1, 'encoding': 'euc-jp'}
endif

let g:eskk#debug = 1

" let g:eskk#no_default_mappings = 1
" let g:eskk#egg_like_newline = 1
let g:eskk#enable_completion = 1
let g:eskk#show_annotation = 1
let g:eskk#rom_input_style = 'msime'