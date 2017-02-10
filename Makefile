# Assuming user is running `make` from the dotfiles directory.
DOTFILES_DIR=$(shell pwd)

install-dotfiles:
	echo 'nop'

mac-neovim-install:
	brew update
	brew install neovim/neovim/neovim
	which pip3 2>&1 > /dev/null || brew install python3
	pip3 install neovim

python-pipenv-install:
	@# https://github.com/kennethreitz/pipenv
	pip install pipenv

mac-diff-so-fancy-install:
	@# https://github.com/so-fancy/diff-so-fancy
	@# Alternatively, npm install -g diff-so-fancy
	brew update && brew install diff-so-fancy

mac-zsh-install:
	@# https://github.com/herrbischoff/awesome-osx-command-line
	brew install zsh && \
	sudo sh -c 'echo $(brew --prefix)/bin/zsh >> /etc/shells' && \
	chsh -s $(brew --prefix)/bin/zsh

vim-install: dein-install
	echo 'nop'

dein-install:
	$(eval VIM_DIR=$(DOTFILES_DIR)/home/vim)
	$(eval VIM_DEIN_REPOS_DIR=$(VIM_DIR)/bundle/repos)
	mkdir -p $(VIM_DEIN_REPOS_DIR)/github.com/Shougo/dein.vim
	git clone https://github.com/Shougo/dein.vim $(VIM_DEIN_REPOS_DIR)/github.com/Shougo/dein.vim
	$(eval VIM=$(shell which nvim 2>&1 > /dev/null && echo 'nvim' || echo 'vim'))
	$(VIM) -c ":call dein#install()"


