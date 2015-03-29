#!/bin/sh
TOOLS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
USER='dump'
PASS='H3uH4d0vVnhw1xB'
HOST='bernard.mongohq.com'
PORT=10011
NAME='app15505665'

echo
echo 'Dropping existing database...'
echo
mongo $TOOLS_DIR/pre-dumpsync.js 

echo 'Dumping production database to local machine...'
echo
mongodump -u $USER -p $PASS -d $NAME --host $HOST:$PORT

echo 'Restoring dumped production database to local database...'
echo
mongorestore

echo
echo 'Removing local dump...'
echo
rm -rf dump

echo
echo 'Copying to correct database name...'
echo
mongo $TOOLS_DIR/post-dumpsync.js

echo
echo 'All done.'
