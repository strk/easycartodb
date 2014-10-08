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


# TODO: check that the app was not started already
{
cd rails-app
#redis-server > /tmp/redis.log &
#sleep 1
VVERBOSE=true QUEUE=* bundle exec rake environment resque:work > /tmp/resque.log &
rails s > /tmp/rails.log &
cd -
}

# TODO: check that the app was not started already
{
cd map-api
node app.js development : tiler > /tmp/tiler.log 2>&1 &
cd -
}

# TODO: check that the app was not started already
{
cd sql-api
node app.js development : sqlapi > /tmp/sqlapi.log 2>&1 &
cd -
}

echo "Service should be ready in a moment on http://dev.localhost.lan:3000"
