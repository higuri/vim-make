"=============================================================================
" File: Make.vim
" Author: Victor Shih <victor.shih@gmail.com>
" Last Change: 5/18/2014
" Version: 0.01
" WebPage: http://blog.vicshih.com/2011/03/fast-make-for-vim.html
" Description: Modestly enhanced `make` for Vim.
"

if exists("g:Make_loaded")
    finish
endif

function! Make(args)
	" Compile arguments.
	let l:args = strlen(a:args) ? ' ' . a:args : ''

	" Find the closest directory to the current file
	" with a {GNUmakefile, [Mm]akefile}.
	let l:makefile_dir = s:find_makefile_dir()

	" Move to that directory and execute standard ':make'.
	let l:_makeprg = &l:makeprg
	let &l:makeprg = 'make'
	execute 'lcd' l:makefile_dir
	execute 'make' l:args
	execute 'lcd -'
	let &l:makeprg = l:_makeprg
endfunction


function s:find_makefile_dir()
	let l:dir = expand('%:p:h')

	while 1
		" Ensure we have only one '/'.
		if !empty(glob(substitute(l:dir, '/$', '', '') . '/{GNUm,[Mm]}akefile'))
			return l:dir
		else
			let l:parent = fnamemodify(l:dir, ':h')
			if l:parent ==# l:dir
				" We reached the root but didn't find a Makefile.
				return '.'
			endif

			let l:dir = l:parent
		endif
	endwhile
endfunction


" Register command.
command! -nargs=? Make call Make("<args>")

let g:Make_loaded = 1
