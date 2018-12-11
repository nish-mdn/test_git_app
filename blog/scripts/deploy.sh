#!/bin/bash
sudo scp -r -i /home/travis/build/nish-mdn/test_git_app/blog/mdn-mysql-own.pem -o "StrictHostKeyChecking=no" /home/travis/build/nish-mdn/test_git_app/blog/ ubuntu@18.207.183.128:~/.
ssh -i /home/travis/build/nish-mdn/test_git_app/blog/mdn-mysql-own.pem -o "StrictHostKeyChecking=no" ubuntu@18.214.36.199 "source ~/.bash_profile; cd blog && rvm use ruby-2.3.1 && bundle install && rails s -p3000 -d"
