scriptencoding utf-8

" インデントつけないバッファの名前
let g:indentLine_bufNameExclude = ['_.*']
let g:indentLine_bufTypeExclude = ['terminal']
let g:indentLine_fileTypeExclude = [
\   'defx',
\   'calendar', 
\   'help', 
\   'json',
\   'sql',
\   'r7rs',
\   'scheme',
\]
let g:indentLine_char = '|'

