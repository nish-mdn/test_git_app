#!/bin/bash
rvm use ruby-2.3.1 && bundle install
ruby /home/travis/build/nish-mdn/test_git_app/blog/scripts/aws_instance_creation.rb
