#!/bin/bash

# https://ci.apache.org/projects/asterixdb/ansible.html

pip install ansible boto boto3

ansible --version || { echo "Ansible is not installed"; exit 1; }
