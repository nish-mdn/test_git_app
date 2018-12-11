#!/bin/bash
sudo scp -i mdn-mysql-own.pem -o "StrictHostKeyChecking=no" ~/blog/* ubuntu@18.207.183.128:~/.