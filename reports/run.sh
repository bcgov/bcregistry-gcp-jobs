#! /bin/bash
cd /opt/app-root
. ./.env
if [ ! -z $VAULT ]; then
    echo 'run oc.sh'
    sh oc.sh &
fi
echo 'run notebookreport to generate Jupyter Notebook Report'
python notebookreport.py
