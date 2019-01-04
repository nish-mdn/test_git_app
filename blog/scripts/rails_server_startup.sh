#!/bin/bash
source ~/.bash_profile;
kill -9 $(lsof -i tcp:3000 -t)
echo 'Benchmarking $(pwd)...'
cd /home/ubuntu/blog/ && rvm use ruby-2.3.1 && bundle install && rails s -b 0.0.0.0 -d