#! /bin/sh
cd /opt/app-root
echo 'run oc.sh'
sh oc.sh &
echo 'run reindex_db_job.py'
python reindex_db_job.py
