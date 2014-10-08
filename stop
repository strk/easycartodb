#!/bin/sh

dirname=`dirname $0`

cd ${dirname}/pids
for pidfile in `ls *.pid 2> /dev/null`; do
  service=`basename ${pidfile} .pid`
  pid=`cat ${pidfile}`
  echo "Killing ${service} (pid ${pid})"
  kill $pid
  rm -f $pidfile
done
