#!/bin/bash
cd /opt/app-root
. ./.env
if [ -n "$VAULT" ] && ! echo "$VAULT" | grep -q '^gcp-'; then
    echo 'run oc.sh'
    sh oc.sh &
fi
echo 'run notebookreport to generate Jupyter Notebook Report'
python notebookreport.py
