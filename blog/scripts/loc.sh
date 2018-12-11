#!/bin/bash
cd blog
rvm use ruby-2.3.1
bundle install
rails s -p3000 -d
exit 0
