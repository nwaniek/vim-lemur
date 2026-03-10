" Vim filetype plugin
" Language: Lemur
" Maintainer: Nicolai Waniek

if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

setlocal comments=fb:*,fb:-,fb:+,n:> commentstring=<!--\ %s\ -->
setlocal formatoptions+=tcqln formatoptions-=r formatoptions-=o
setlocal formatlistpat=^\\s*\\d\\+\\.\\s\\+\\\|^\\s*[-*+]\\s\\+\\\|^\\[^\\ze[^\\]]\\+\\]:\\&^.\\{4\\}

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= "|setl cms< com< fo< flp< et< ts< sts< sw<"
else
  let b:undo_ftplugin = "setl cms< com< fo< flp< et< ts< sts< sw<"
endif

