#!/bin/bash
echo "going to list file"
comd="ls -la $TRAVIS_BUILD_DIR"
eval "$comd"
sudo scp -i mdn-mysql-own.pem -o "StrictHostKeyChecking=no" "$TRAVIS_BUILD_DIR/blog" ubuntu@18.207.183.128:~/.