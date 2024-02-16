if exists('g:vim_pandoc_syntax_exists')
  augroup pandoc_syntax
    au! BufNewFile,BufFilePre,BufRead *.md set filetype=markdown.pandoc
  augroup END
endif
