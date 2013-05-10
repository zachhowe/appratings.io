#!/bin/sh

USER='Bx1whnVv0d4Hu3H'
PASS='192T3X5T9172h8I'
HOST='alex.mongohq.com'
PORT=10023
NAME='app15505665'

echo 'Dumping production database to local machine...'
echo
mongodump -u $USER -p $PASS -d $NAME --host $HOST:$PORT

echo 'Restoring dumped production database to local database...'
echo
mongorestore

echo
echo 'Removing local dump...'
echo
rm -rf $PWD/dump

echo
echo 'All done.'
