#!/bin/bash
echo "ip address from another file $1"
sudo scp -r -i /home/travis/build/nish-mdn/test_git_app/blog/mdn-mysql-own.pem -o "StrictHostKeyChecking=no" /home/travis/build/nish-mdn/test_git_app/blog/ ubuntu@$1:~/.
ssh -i /home/travis/build/nish-mdn/test_git_app/blog/mdn-mysql-own.pem -o "StrictHostKeyChecking=no" ubuntu@$1 /bin/bash < /home/travis/build/nish-mdn/test_git_app/blog/scripts/rails_server_startup.sh
