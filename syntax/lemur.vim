" Vim lemur syntax file
" Language: Less Annoying Markup Experience documentation format
" Website: https://github.com/nwaniek/vim-lemur
" Maintainer: Nicolai Waniek 
" Latest Revision: 2025-03-10

if exists('b:current_syntax')
	finish
endif

syn case ignore

syn keyword lemurTodo FIXME TODO XXX NOTE

" Headers (Markdown style)
syntax match lemurHeader /^##* .*$/
			\ contains=lemurRefDeclContained

syn match lemurCodeBlockLang 
			\ /\s*\zs\(\w\+\)*/
			\ contained

syn match lemurCodeBlockHeader 
			\ /^::\s*.*/
			\ contains=lemurCodeBlockLang,lemurRefDeclContained
			\ contained

syn region lemurCodeBlock
			\ start=/^::.*$/
 			\ end=/^\ze\S/
			\ contains=lemurCodeBlockHeader
			\ keepend
			\ extend

syn include @lemurCpp syntax/cpp.vim
unlet! b:current_syntax
syn match lemurCodeBlockHeaderCpp
 			\ /^::\s*cpp\>.*/
			\ contains=lemurCodeBlockHeader
			\ containedin=lemureCodeBlockCpp
syn region lemurCodeBlockCpp
 			\ start=/^::\s*cpp\>.*/
 			\ end=/^\ze\S/
 			\ contains=lemurCodeBlockHeaderCpp,@lemurCpp
			\ extend
			\ keepend


syn include @lemurPython syntax/python.vim
unlet! b:current_syntax
syn match lemurCodeBlockHeaderPython
 			\ /^::\s*python\>.*/
			\ contains=lemurCodeBlockHeader
			\ contained
syn region lemurCodeBlockPython
 			\ start=/^::\s*python\>.*/
 			\ end=/^\ze\S/
 			\ contains=lemurCodeBlockHeaderPython,@lemurPython
			\ extend
			\ keepend


syn include @lemurJava syntax/java.vim
unlet! b:current_syntax
syn match lemurCodeBlockHeaderJava
 			\ /^::\s*java\>.*/
			\ contains=lemurCodeBlockHeader
			\ contained
syn region lemurCodeBlockJava
 			\ start=/^::\s*java\>.*/
 			\ end=/^\ze\S/
 			\ contains=lemurCodeBlockHeaderJava,@lemurJava
			\ extend
			\ keepend


syn include @lemurTex syntax/tex.vim
unlet! b:current_syntax
syn match lemurCodeBlockHeaderTex
 			\ /^::\s*tex\>.*/
			\ contains=lemurCodeBlockHeader
			\ contained
syn region lemurCodeBlockTex
 			\ start=/^::\s*tex\>.*/
 			\ end=/^\ze\S/
 			\ contains=lemurCodeBlockHeaderTex,@lemurTex
			\ extend
			\ keepend


syn include @lemurShell syntax/sh.vim
unlet! b:current_syntax
syn match lemurCodeBlockHeaderShell
 			\ /^::\s*sh\>.*/
			\ contains=lemurCodeBlockHeader
			\ contained
syn region lemurCodeBlockShell
 			\ start=/^::\s*sh\>.*/
 			\ end=/^\ze\S/
 			\ contains=lemurCodeBlockHeaderShell,@lemurShell
			\ extend
			\ keepend


" inline math mode with $$...$$
syn region lemurInlineMath start="\\\@<!\$\$" end="\$\$" skip="\\\$" contains=@lemurtex keepend

" bold and italic stuff
syn region lemurBold       
			\ start="\*\*\S\@="   
			\ end="\S\@<=\*\*\|^$"   
			\ skip="\\\*" 

syn region lemurItalic     
			\ start="__\S\@="     
			\ end="\S\@<=__\|^$"     
			\ skip="\\_" 

syn region lemurBoldItalic 
			\ start="\*\*__\S\@=" 
			\ end="\S\@<=__\*\*\|^$" 
			\ skip="\\_\*" 

syn region lemurItalicBold 
			\ start="__\*\*\S\@=" 
			\ end="\S\@<=\*\*__\|^$" 
			\ skip="\\\*_" 

" reference declaration
syn match lemurRefDecl
			\ /\v^\s*\^(\w+):/

syn match lemurRefDeclContained 
			\ /\v\^(\w+)\s*$/
			\ contained

" inline de-referencing
syn match lemurInlineRefs 
			\ /\v(^|[[:space:]+])\@(\((\w+%(\s*,\s*\w+)*)\)|\w+)/

" link blocks and their contents
syn match lemurLinkBlock
			\ /\v\[[^\]]*\](\@\(.*\)|\@[^[:space:]]+|\(.*\))/
			\ contains=lemurLinkText,lemurLinkRefs,lemurLinkURL,lemurLinkImg

syn match lemurLinkText  
			\ /\v\[[^\]]*\]/                   
			\ contained

syn match lemurLinkRefs  
			\ /\v\@(\([^)]+\)|[^[:space:]]+)/  
			\ contained

" syn match lemurURL
" 			\ /https\?:\/\/\(\w\+\(:\w\+\)\?@\)\?\([A-Za-z][-_0-9A-Za-z]*\.\)\{1,}\(\w\{2,}\.\?\)\{1,}\(:[0-9]\{1,5}\)\?\S*/
" 			\ contained

syn match lemurLinkURL   
			\ /(https\?:\/\/\(\w\+\(:\w\+\)\?@\)\?\([A-Za-z][-_0-9A-Za-z]*\.\)\{1,}\(\w\{2,}\.\?\)\{1,}\(:[0-9]\{1,5}\)\?\S*)/
			\ contained

syn match lemurLinkImg
			\ /(img::\(.*\))/
			\ contained

syntax match lemurEmail    
			\ /\v<\w+\@\w+\.\w+>/

syntax match lemurShortURL 
			\ /<https\?:\/\/\(\w\+\(:\w\+\)\?@\)\?\([A-Za-z][-_0-9A-Za-z]*\.\)\{1,}\(\w\{2,}\.\?\)\{1,}\(:[0-9]\{1,5}\)\?\S*>/


highlight Bold       term=bold         cterm=bold         gui=bold
highlight Italic     term=italic       cterm=italic       gui=italic
highlight BoldItalic term=italic,bold  cterm=italic,bold  gui=italic,bold

hi def link lemurTodo              Todo
hi def link lemurHeader            Title
hi def link lemurItalic            Italic
hi def link lemurBold              Bold
hi def link lemurBoldItalic        BoldItalic
hi def link lemurItalicBold        BoldItalic
hi def link lemurInlineMath        Statement


hi def link lemurCodeBlockLang     Statement
hi def link lemurCodeBlockHeader   PreProc
hi def link lemurCodeBlock         Statement

hi def link lemurLinkBlock         Statement
hi def link lemurLinkText          Statement
hi def link lemurLinkRefs          Function
hi def link lemurLinkURL           Function
hi def link lemurLinkImg           Function

hi def link lemurInlineRefs        Function

hi def link lemurEmail             String
hi def link lemurLink              String
hi def link lemurShortURL          String

hi def link lemurRefDecl           Identifier
hi def link lemurRefDeclContained  Identifier


" Highlight !table and its reference
" syn match lemurTable /^[:space:]*!table[:space:]*\(\w+\)\(^\w*\)\?/ contains=lemurTableKeyword,lemurTableRef
" hi def link lemurTableKeyword PreProc
" hi def link lemurTableRef     Identifier
" hi def link lemurTable        Todo

syn match lemurTable /^!table\s\+\S\+\(\s\+\^table_\S\+\)\?/ contains=lemurTableKeyword,lemurTableRef
hi def link lemurTableKeyword Keyword
hi def link lemurTableRef     Identifier

" Match the !cols line and highlight different components
syn match lemurTableCols /^!cols\s\+.*$/ contains=lemurTableColsKeyword,lemurTableSeparator,lemurTableAlign
syn match lemurTableColsKeyword /^!cols/ contained
syn match lemurTableSeparator /[|,]/ contained
syn match lemurTableAlign /\[\zs[lrctb]\+\ze\]/ contained

" Highlight groups
hi def link lemurTableColsKeyword Keyword
hi def link lemurTableSeparator Operator
hi def link lemurTableAlign Special
 
" Match table rows (indented lines after !cols)
" syn region lemurTableRow start=/^\s\{1,}/ end=/$/ contains=lemurTableSeparator
" hi def link lemurTableRow Normal
