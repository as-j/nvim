FROM ubuntu:22.04

# Install latest Neovim
RUN apt update && apt install -y software-properties-common
RUN add-apt-repository ppa:neovim-ppa/unstable
RUN apt-get update && apt install -y neovim

RUN apt install -y git curl gnupg

# Python dependencies
RUN apt install -y python3-dev python3-pip
RUN pip3 install pynvim

# Node dependencies + neovim
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
RUN apt install -y nodejs npm unzip python3-venv ripgrep fd-find locales exuberant-ctags clangd
# Set the locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
RUN locale-gen en_US.UTF-8
RUN update-locale LANG=en_US.UTF-8

# Install nvim
RUN update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60
RUN update-alternatives --config vi
RUN update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
RUN update-alternatives --config vim
RUN update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60
RUN update-alternatives --config editor

RUN git clone --depth 1 https://github.com/as-j/nvim.git ~/.config/nvim
RUN git config --global --add safe.directory /zoox/driving-emu-com-stale
RUN git config --global --add safe.directory /zoox/driving

# This works since the config files for vim auto install packer and then auto run packer.sync
RUN nvim -u ~/.config/nvim/lua/plugins.lua -c 'autocmd User PackerComplete quitall'
RUN nvim -c 'MasonInstall --force buildifier cbfmt clangd clang-format codelldb cpplint cpptools pyright python-lsp-server' -c 'quitall'
# My configuration
#RUN git clone --depth 1 \
#    https://github.com/stsewd/dotfiles $HOME/dotfiles

#RUN mkdir $HOME/.config/ && \
#    ln -s $HOME/dotfiles/config/nvim $HOME/.config/nvim

WORKDIR /zoox
CMD sleep infinity

# Build with
# docker build -t neovim .
# List containers
# docker image ls
# Run this Dockerfile with
# $ docker run -it -v /home/astanleyjones/zoox:/zoox -v $HOME/.config:/root/.config -v $HOME:$HOME <image>
# $ nvim
