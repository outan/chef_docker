# Docker container with chef-solo & berkshelf
FROM ubuntu:14.04
MAINTAINER Paul B. "outannexway@gmail.com"

WORKDIR /root
# Apt update
RUN apt-get -y update

# Install Chef
RUN apt-get -y install curl build-essential libxml2-dev libxslt-dev git wget lsb-release zsh
RUN wget https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/12.04/x86_64/chefdk_0.6.2-1_amd64.deb
RUN dpkg -i chefdk_0.6.2-1_amd64.deb && rm chefdk_0.6.2-1_amd64.deb
RUN echo "gem: --no-ri --no-rdoc" > ~/.gemrc

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

#vim
RUN apt install vim
