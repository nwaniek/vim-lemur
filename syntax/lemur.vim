" Vim lemure syntax file
" Language: Less Annoying Markup Experience documentation format
" Website:
" Maintainer: Nicolai Waniek 
" Latest Revision: 2025-03-07

if exists('b:current_syntax')
	finish
endif

syn case ignore

syn keyword lemureTodo FIXME TODO XXX NOTE

" Headers (Markdown style)
syntax match lemureHeader /^##* .*$/
			\ contains=lemureRefDeclInHeader

" lemure (code block) directive (:: [language])
syn match lemureCodeBlockHeader 
			\ /^::\s*\(\k\+\)\?$/

" Define a general region for the code block
syn region lemureCodeBlock 
			\ contained 
			\ matchgroup=lemureCodeBlockHeader 
			\ fold
			\ start=/^::\s*\(\k\+\)\?$/
      		\ end=/^\ze\S/
      		\ contains=@NoSpell

" Define supported languages
" TODO: bibtex support
if !exists('g:lemure_syntax_code_list')
    let g:lemure_syntax_code_list = {
        \ 'cpp':    ['cpp', 'c++'],
        \ 'python': ['python'],
        \ 'java':   ['java'],
        \ 'sh':     ['sh'],
		\ 'tex':    ['latex', 'tex'],
        \ }
endif

" Dynamically load syntax highlighting for each language
for s:filetype in keys(g:lemure_syntax_code_list)
    unlet! b:current_syntax
    let s:alias_pattern = ''
				\.'\%(' 
				\.join(g:lemure_syntax_code_list[s:filetype], '\|') 
				\. '\)'

    exe 'syn include @lemure'.s:filetype.' syntax/'.s:filetype.'.vim'
    exe 'syn region lemureCodeBlock'.s:filetype
                \.' matchgroup=lemureCodeBlockHeader fold'
                \.' start="^::\s\+'.s:alias_pattern.'\_s*\n\ze\z(\s\+\)"'
                \.' skip="^$"'
				\.' end="^\z1\@!"'
                \.' contains=@NoSpell,@lemure'.s:filetype

    exe 'syn cluster lemureCodeDirectives add=lemureCodeBlock'.s:filetype
endfor

" inline math mode with $$...$$
syn region lemureInlineMath start="\\\@<!\$\$" end="\$\$" skip="\\\$" contains=@lemuretex keepend

" bold and italic stuff
syn region lemureBold       
			\ start="\*\*\S\@="   
			\ end="\S\@<=\*\*\|^$"   
			\ skip="\\\*" 

syn region lemureItalic     
			\ start="__\S\@="     
			\ end="\S\@<=__\|^$"     
			\ skip="\\_" 

syn region lemureBoldItalic 
			\ start="\*\*__\S\@=" 
			\ end="\S\@<=__\*\*\|^$" 
			\ skip="\\_\*" 

syn region lemureItalicBold 
			\ start="__\*\*\S\@=" 
			\ end="\S\@<=\*\*__\|^$" 
			\ skip="\\\*_" 

" reference declaration
syn match lemureRefDecl
			\ /\v^\s*\^(\w+):/

syn match lemureRefDeclInHeader 
			\ /\v\^(\w+)\s*$/
			\ contained

" inline de-referencing
syn match lemureInlineRefs 
			\ /\v(^|[[:space:]+])\@(\((\w+%(\s*,\s*\w+)*)\)|\w+)/

" link blocks and their contents
syn match lemureLinkBlock
			\ /\v\[[^\]]*\](\@\(.*\)|\@[^[:space:]]+|\(.*\))/
			\ contains=lemureLinkText,lemureLinkRefs,lemureLinkURL,lemureLinkImg

syn match lemureLinkText  
			\ /\v\[[^\]]*\]/                   
			\ contained

syn match lemureLinkRefs  
			\ /\v\@(\([^)]+\)|[^[:space:]]+)/  
			\ contained

" syn match lemureURL
" 			\ /https\?:\/\/\(\w\+\(:\w\+\)\?@\)\?\([A-Za-z][-_0-9A-Za-z]*\.\)\{1,}\(\w\{2,}\.\?\)\{1,}\(:[0-9]\{1,5}\)\?\S*/
" 			\ contained

syn match lemureLinkURL   
			\ /(https\?:\/\/\(\w\+\(:\w\+\)\?@\)\?\([A-Za-z][-_0-9A-Za-z]*\.\)\{1,}\(\w\{2,}\.\?\)\{1,}\(:[0-9]\{1,5}\)\?\S*)/
			\ contained

syn match lemureLinkImg
			\ /(img::\(.*\))/
			\ contained

syntax match lemureEmail    
			\ /\v<\w+\@\w+\.\w+>/

syntax match lemureShortURL 
			\ /<https\?:\/\/\(\w\+\(:\w\+\)\?@\)\?\([A-Za-z][-_0-9A-Za-z]*\.\)\{1,}\(\w\{2,}\.\?\)\{1,}\(:[0-9]\{1,5}\)\?\S*>/


highlight Bold       term=bold         cterm=bold         gui=bold
highlight Italic     term=italic       cterm=italic       gui=italic
highlight BoldItalic term=italic,bold  cterm=italic,bold  gui=italic,bold

hi def link lemureTodo              Todo
hi def link lemureHeader            Title
hi def link lemureItalic            Italic
hi def link lemureBold              Bold
hi def link lemureBoldItalic        BoldItalic
hi def link lemureItalicBold        BoldItalic
hi def link lemureCodeBlockHeader   PreProc
hi def link lemureInlineMath        Statement


hi def link lemureLinkBlock					Statement
hi def link lemureLinkText					Statement
hi def link lemureLinkRefs					Function
hi def link lemureLinkURL					Function
hi def link lemureLinkImg					Function

hi def link lemureInlineRefs				Function

hi def link lemureEmail						String
hi def link lemureLink						String
hi def link lemureShortURL					String

hi def link lemureRefDecl			Identifier
hi def link lemureRefDeclInHeader	Identifier


" Highlight !table and its reference
" syn match lemureTable /^[:space:]*!table[:space:]*\(\w+\)\(^\w*\)\?/ contains=lemureTableKeyword,lemureTableRef
" hi def link lemureTableKeyword PreProc
" hi def link lemureTableRef     Identifier
" hi def link lemureTable        Todo

syn match lemureTable /^!table\s\+\S\+\(\s\+\^table_\S\+\)\?/ contains=lemureTableKeyword,lemureTableRef
hi def link lemureTableKeyword Keyword
hi def link lemureTableRef     Identifier

" Match the !cols line and highlight different components
syn match lemureTableCols /^!cols\s\+.*$/ contains=lemureTableColsKeyword,lemureTableSeparator,lemureTableAlign
syn match lemureTableColsKeyword /^!cols/ contained
syn match lemureTableSeparator /[|,]/ contained
syn match lemureTableAlign /\[\zs[lrctb]\+\ze\]/ contained

" Highlight groups
hi def link lemureTableColsKeyword Keyword
hi def link lemureTableSeparator Operator
hi def link lemureTableAlign Special
 
" Match table rows (indented lines after !cols)
syn region lemureTableRow start=/^\s\{1,}/ end=/$/ contains=lemureTableSeparator
hi def link lemureTableRow Normal
