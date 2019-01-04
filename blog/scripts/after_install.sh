#!/bin/bash
sudo chown -R ubuntu:ubuntu /home/ubuntu/blog
sudo chmod 777 /home/ubuntu/blog/scripts/rails_server_startup.sh
sudo su ubuntu -c "/home/ubuntu/blog/scripts/rails_server_startup.sh"