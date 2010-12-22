" User filetype definitions
if exists("did_load_filetypes")
  finish
endif

augroup filetypedetect
	au! BufNewFile,BufRead *.applescript   setfiletype applescript
	au! BufNewFile,BufRead *.plt,*.gnuplot setfiletype gnuplot
	au! BufNewFile,BufRead *.pp setfiletype puppet
	au! BufNewFile,BufRead svn-commit.* setfiletype svn " handle svn commits
	au! BufNewFile,BufRead *.yaml,*.yml so ~/.vim/syntax/yaml.vim
augroup END
" See .vim/after/scripts.vim for filetype detection based on file contents and
" default filetype.
