#!/bin/bash

# https://ci.apache.org/projects/asterixdb/ansible.html

echo "Note on students it might take a while.."
pip install ansible boto boto3 || { echo "Error while installing"; exit 1; }
ansible --version || { echo "Ansible is not runnable"; exit 1; }
