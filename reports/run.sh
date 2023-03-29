#! /bin/sh
cd /opt/app-root
echo 'run oc.sh'
sh oc.sh &
echo 'run notebookreport to generate Jupyter Notebook Report'
python notebookreport.py
