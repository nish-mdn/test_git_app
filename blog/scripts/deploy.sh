#!/bin/bash
sudo scp -r -i /home/travis/build/nish-mdn/test_git_app/blog/mdn-mysql-own.pem -o "StrictHostKeyChecking=no" /home/travis/build/nish-mdn/test_git_app/blog/ ubuntu@18.232.146.23:~/.
ssh -i /home/travis/build/nish-mdn/test_git_app/blog/mdn-mysql-own.pem -o "StrictHostKeyChecking=no" ubuntu@18.232.146.23 "source ~/.bash_profile; cd blog && rvm use ruby-2.3.1 && bundle install && rails s -b 0.0.0.0 -d"
