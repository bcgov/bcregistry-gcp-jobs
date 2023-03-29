#! /bin/sh
oc login --server=$OC_SERVER --token=$OC_TOKEN
oc -n $OC_NAMESPACE port-forward  svc/$DB_SVC_NAME 8006:5432
