DOTFILES=$(HOME)/.files

install-dotfiles:
	echo 'nop'

vim-install: dein-install
	echo 'nop'

dein-install:
	$(eval VIM_DIR=$(DOTFILES)/home/vim)
	$(eval VIM_DEIN_REPOS_DIR=$(VIM_DIR)/bundle/repos)
	mkdir -p $(VIM_DEIN_REPOS_DIR)/github.com/Shougo/dein.vim
	git clone https://github.com/Shougo/dein.vim $(VIM_DEIN_REPOS_DIR)/github.com/Shougo/dein.vim
	$(eval VIM=$(shell which nvim 2>&1 > /dev/null && echo 'nvim' || echo 'vim'))
	$(VIM) -c ":call dein#install()"


