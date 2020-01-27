#!/bin/bash
set -e

source ~/.profile
git clone https://github.com/Artemmkin/reddit.git
cd reddit
sudo bundle install

sudo mv /tmp/puma.service /etc/systemd/system/puma.service
sudo bundle exec puma -d
sudo systemctl start puma
sudo systemctl enable puma
