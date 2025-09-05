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
			\ /\s*\zs[0-9A-Za-z_+\#-]\+/
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

" dynamic generation of code blocks for other languages
if !exists('g:lemur_syntax_code_list')
    let g:lemur_syntax_code_list = {
        \ 'cpp':     ['cpp', 'c++'],
		\ 'cs':      ['csharp', 'c#', 'cs'],
		\ 'css':     ['css'],
		\ 'erlang':  ['erlang'],
		\ 'haskell': ['haskell', 'hs'],
        \ 'java':    ['java'],
		\ 'make':    ['make', 'Makefile'],
        \ 'python':  ['python'],
        \ 'sh':      ['sh'],
		\ 'tex':     ['latex', 'tex'],
        \ }
endif

for s:filetype in keys(g:lemur_syntax_code_list)
	" build the alias pattern
	let s:alias_pattern = '\%('.join(g:lemur_syntax_code_list[s:filetype], '\|').'\)'

	" include corresponding syntax file
	exe 'syn include @lemur'.s:filetype.' syntax/'.s:filetype.'.vim'
	unlet! b:current_syntax

	" build the header for this language
	exe 'syn match lemurCodeBlockHeader'.s:filetype 
				\. ' /^::\s*'.s:alias_pattern.'\%(\s\|$\).*/'
				\. ' contains=lemurCodeBlockHeader'
				\. ' containedin=lemurCodeBlock'.s:filetype

	" build the code-block region for this
	exe 'syn region lemurCodeBlock'.s:filetype
				\. ' start=/^::\s*'.s:alias_pattern.'\%(\s\|$\).*/'
				\. ' end=/^\ze\S/'
				\. ' contains=lemurCodeBlockHeader'.s:filetype.',@lemur'.s:filetype
				\. ' extend'
				\. ' keepend'
endfor


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
