#!/bin/bash
echo "going to list file"
comd="locate mdn-mysql-own.pem"
eval "$comd"
sudo scp -i mdn-mysql-own.pem -o "StrictHostKeyChecking=no" /home/travis/build/nish-mdn/test_git_app/blog/* ubuntu@18.207.183.128:~/.