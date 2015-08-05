# Docker container with chef-solo & berkshelf
FROM ubuntu:14.04
MAINTAINER outan "outannexway@gmail.com"

WORKDIR /root
# Apt update
RUN apt-get -y update

# Install Chef
RUN apt-get -y install curl build-essential libxml2-dev libxslt-dev git wget lsb-release zsh
RUN wget https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/12.04/x86_64/chefdk_0.6.2-1_amd64.deb
RUN dpkg -i chefdk_0.6.2-1_amd64.deb && rm chefdk_0.6.2-1_amd64.deb
RUN echo "gem: --no-ri --no-rdoc" > ~/.gemrc

# Install Berkshelf with chef's own ruby
# And install gecode from binaries (compilation fails when installed by the gem)
RUN echo "deb http://apt.opscode.com/ `lsb_release -cs`-0.10 main" | tee /etc/apt/sources.list.d/opscode.list
RUN mkdir -p /etc/apt/trusted.gpg.d
RUN gpg --keyserver keys.gnupg.net --recv-keys 83EF826A
RUN gpg --export packages@opscode.com | tee /etc/apt/trusted.gpg.d/opscode-keyring.gpg > /dev/null
RUN apt-get -y update
RUN apt-get install -y opscode-keyring # permanent upgradeable keyring
RUN apt-get upgrade -y
RUN apt-get install -y libgecode-dev
RUN USE_SYSTEM_GECODE=1 /opt/chef/embedded/bin/gem install berkshelf

#ssh public key
RUN mkdir .ssh
ADD id_rsa.pub .ssh/id_rsa.pub

# Cleanup
RUN apt-get autoremove
RUN apt-get clean

RUN chsh -s /bin/zsh

# dotfiles
RUN git clone https://github.com/outan/dotfiles.git
RUN dotfiles/symlink.sh

# Install vim
RUN apt -y install vim

# Install tree
RUN apt -y install tree

# Install ag
RUN apt -y install silversearcher-ag

# Install unzip to extract zip file
RUN apt -y install unzip
