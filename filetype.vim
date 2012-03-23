" User filetype definitions
if exists("did_load_filetypes")
  finish
endif

augroup filetypedetect | au!
    au BufNewFile,BufRead *.applescript           setfiletype applescript
    au BufNewFile,BufRead *.json                  setfiletype javascript
    au BufNewFile,BufRead *.md                    setfiletype markdown
    au BufNewFile,BufRead *.scala                 setfiletype scala
    au BufNewFile,BufRead *.zsh-theme             setfiletype zsh
    au BufNewFile,BufRead *.adium                 setfiletype adium
    au BufNewFile,BufRead *.colloquy              setfiletype colloquy
    au BufNewFile,BufRead *pentadactylrc*,*.penta setfiletype pentadactyl
    au BufNewFile,BufRead *vimperatorrc*,*.vimp   setfiletype vimperator
    au BufNewFile,BufRead *.plt,*.gnuplot         setfiletype gnuplot
    au BufNewFile,BufRead *.pp                    setfiletype puppet
    au BufNewFile,BufRead svn-commit.*            setfiletype svn
    au BufNewFile,BufRead *.yaml,*.yml            so ~/.vim/syntax/yaml.vim
augroup END
" See .vim/after/scripts.vim for filetype detection based on file contents and
" default filetype.
