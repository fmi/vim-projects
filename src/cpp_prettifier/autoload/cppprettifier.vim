function! cppprettifier#Prettify()
	call cppprettifier#SeparateStatements()
	call cppprettifier#BreakLinesAfterOpeningCurlyBracket()
	call cppprettifier#BreakLinesBeforeClosingCurlyBracket()
	call cppprettifier#Indent()
	call cppprettifier#RemoveTooMuchEmptyLines()
endfunction


function! cppprettifier#SeparateStatements()
	let regex = '\(.\{-1,};\)\(\(.\{-1,};\)\+\)'
	exe 'normal! gg'
	let lnum = 1
	while lnum <= line('$')
		while getline('.') =~ regex
			exe 'substitute/' .. regex .. '/\1\r\2'
			let lnum = lnum + 1
		endwhile
		exe 'normal! j'
		let lnum = lnum + 1
	endwhile
endfunction


function! cppprettifier#BreakLinesAfterOpeningCurlyBracket()
	let regex = '\(.\{-1,}{\)\(.\+\)'
	exe 'normal! gg'
	let lnum = 1
	while lnum <= line('$')
		while getline('.') =~ regex
			exe 'substitute/' .. regex .. '/\1\r\2'
			let lnum = lnum + 1
		endwhile
		exe 'normal! j'
		let lnum = lnum + 1
	endwhile
endfunction


function! cppprettifier#BreakLinesBeforeClosingCurlyBracket()
	let regex = '\([^[:blank:]]\+\)\(}.*\)'
	exe 'normal! gg'
	let lnum = 1
	while lnum <= line('$')
		while getline('.') =~ regex
			exe 'substitute/' .. regex .. '/\1\r\2'
			let lnum = lnum + 1
		endwhile
		exe 'normal! j'
		let lnum = lnum + 1
	endwhile
endfunction


function! cppprettifier#RemoveTooMuchEmptyLines()
	exe 'normal! gg'
	let lnum = 1
	while lnum <= line('$')
		while trim(getline('.')) == "" && trim(getline(line('.') + 1)) == ""
			exe 'normal! "_dd'
		endwhile
		exe 'normal! j'
		let lnum = lnum + 1
	endwhile
endfunction


function! cppprettifier#Indent()
	exe 'normal! gg'
	let regex2 = '^\s\+\(.*\)'
	let obr = 0
	let lnum = 1
	while lnum <= line('$')
		if getline('.') =~ regex2
			exe 'substitute/' .. regex2 .. '/\1'
		endif

		let tabsins = 0
		let tmp = 0
		if getline('.')[0] == '}'
			let tmp = 1
		endif
		while tabsins < obr - tmp
			exe 'normal! I	'
			let tabsins = tabsins + 1
		endwhile

		let spos = stridx(getline('.'), "{", 0) + 1
		while spos > 0
			let spos = stridx(getline('.'), "{", spos) + 1
			let obr = obr + 1
		endwhile
		let spos = stridx(getline('.'), "}", 0) + 1
		while spos > 0
			let spos = stridx(getline('.'), "}", spos) + 1
			let obr = obr - 1
		endwhile

		exe 'normal! j'
		let lnum = lnum + 1
	endwhile
endfunction

