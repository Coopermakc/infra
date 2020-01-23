#!/bin/bash


sudo apt-add-repository -y ppa:rael-gc/rvm
sudo apt-get update
sudo apt-get install rvm

source ~/.rvm/scripts/rvm
rvm requirements
rvm install 2.4.1

rvm use 2.4.1 --default
gem install bundler -V --no-ri --no-rdoc

echo ruby -v
echo bundle -v
