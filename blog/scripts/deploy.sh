#!/bin/bash
sudo scp -r -i /home/travis/build/nish-mdn/test_git_app/blog/mdn-mysql-own.pem -o "StrictHostKeyChecking=no" /home/travis/build/nish-mdn/test_git_app/blog/ ubuntu@18.204.243.94:~/.
ssh -i /home/travis/build/nish-mdn/test_git_app/blog/mdn-mysql-own.pem -o "StrictHostKeyChecking=no" ubuntu@18.204.243.94 "source ~/.bash_profile; cd blog && kill -9 $(cat tmp/pids/server.pid) && rvm use ruby-2.3.1 && bundle install && rails s -b 0.0.0.0 -d"
