#!/bin/sh

export RAILS_ENV=development

dev=`psql -Atc "select username from users where username = 'dev'" carto_db_development`
test $? -gt 0 && exit 1
if test -z "$dev"; then
  echo "No 'dev' user exists, creating one"
  cd rails-app/script/
  ./create_dev_user dev dev dev ${USER}@localhost
  cd -
fi

grep -q dev\.localhost\.lan /etc/hosts
if test $? -gt 0; then
  echo "Adding 'dev.localhost.lan' to /etc/hosts"
  sudo sed -i~ 's/\(^127.0.0.1.*\)/\1 dev.localhost.lan/' /etc/hosts
  #sudo cp /etc/hosts /etc/hosts~
fi

#sudo varnishd -a localhost:6081 -f varnish-default.vcl -T localhost:6082

mkdir -p pids
mkdir -p logs


{
cd rails-app

pid=`cat ../pids/resque.pid 2> /dev/null`
if test -n "$pid" && ps "$pid" > /dev/null; then
  echo "Resque is already running with pid $pid, will not start another"
else
  VVERBOSE=true QUEUE=* bundle exec rake environment resque:work > ../logs/resque.log &
  pid=$!
  echo "${pid}" > ../pids/resque.pid 2>&1
fi

pid=`cat ../pids/rails.pid 2> /dev/null`
if test -n "$pid" && ps "$pid" > /dev/null; then
  echo "Rails is already running as pid $pid, will not start another"
else
  rails s > ../logs/rails.log &
  pid=$!
  echo "${pid}" > ../pids/rails.pid 2>&1
fi

cd - > /dev/null
}

{
cd map-api

pid=`cat ../pids/mapapi.pid 2> /dev/null`
if test -n "$pid" && ps "$pid" > /dev/null; then
  echo "MAP-API is already running as pid $pid, will not start another"
else
	rm -rf logs
  ln -s ../logs logs
  node app.js development : tiler > logs/mapapi.log 2>&1 &
  pid=$!
  echo "${pid}" > ../pids/mapapi.pid
fi

cd - > /dev/null
}

{
cd sql-api
pid=`cat ../pids/sqlapi.pid 2> /dev/null`
if test -n "$pid" && ps "$pid" > /dev/null; then
  echo "SQL-API is already running as pid $pid, will not start another"
else
	rm -rf logs
  ln -s ../logs logs
  node app.js development : sqlapi > logs/sqlapi.log 2>&1 &
  pid=$!
  echo "${pid}" > ../pids/sqlapi.pid
fi

cd - > /dev/null
}

sleep 1
echo
echo "Service should be ready in a moment on http://dev.localhost.lan:3000/dashboard"
echo
