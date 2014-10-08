#!/bin/sh

export RAILS_ENV=development


#sudo varnishd -a localhost:6081 -f varnish-default.vcl -T localhost:6082

{
cd rails-app
#redis-server > /tmp/redis.log &
#sleep 1
VVERBOSE=true QUEUE=* bundle exec rake environment resque:work > /tmp/resque.log &
rails s > /tmp/rails.log &
cd -
}

{
cd map-api
node app.js development : tiler > /tmp/tiler.log 2>&1 &
cd -
}

{
cd sql-api
node app.js development : sqlapi > /tmp/sqlapi.log 2>&1 &
cd -
}
