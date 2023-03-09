#! /bin/sh
cd /opt/app-root
echo 'run oc.sh'
sh oc.sh &
echo 'run reindex_auth_db_job.py'
python reindex_auth_db_job.py
