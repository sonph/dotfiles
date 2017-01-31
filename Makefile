DOTFILES="$$HOME/.files"

install-dotfiles:
	echo 'nop'

vim-install: dein-install
	echo 'nop'

dein-install:
	mkdir -p $(DOTFILES)/vim/bundle/repos/github.com/Shougo/dein.vim
	git clone https://github.com/Shougo/dein.vim $(DOTFILES)/bundle/repos/github.com/Shougo/dein.vim
	$(eval VIM=$(shell which nvim 2>&1 > /dev/null && echo 'nvim' || echo 'vim'))
	$(VIM) -c ":call dein#install()"


