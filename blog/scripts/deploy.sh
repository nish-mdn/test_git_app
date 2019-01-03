#!/bin/bash
sudo scp -r -i /home/travis/build/nish-mdn/test_git_app/blog/mdn-mysql-own.pem -o "StrictHostKeyChecking=no" /home/travis/build/nish-mdn/test_git_app/blog/ ubuntu@34.206.72.10:~/.
ssh -i /home/travis/build/nish-mdn/test_git_app/blog/mdn-mysql-own.pem -o "StrictHostKeyChecking=no" ubuntu@34.206.72.10 /bin/bash < /home/travis/build/nish-mdn/test_git_app/blog/scripts/rails_server_startup.sh

