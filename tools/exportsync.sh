#!/bin/sh

TMP_DATA=$PWD/tmp/data

if [ ! -d $TMP_DATA ]; then
	mkdir -p $TMP_DATA
fi

USER='dump'
PASS='H3uH4d0vVnhw1xB'
HOST='bernard.mongohq.com'
PORT=10011
NAME='app15505665'

COLLETIONS=( apps ratings )

echo 'Exporting production database to local machine...'
echo 

for i in "${COLLETIONS[@]}"
do
	mongoexport -u $USER -p $PASS -d $NAME --host $HOST:$PORT --collection $i >  $TMP_DATA/$i.json
done

echo 'Importing local data to local database...'
echo 

for i in "${COLLETIONS[@]}"
do
	mongoimport --db appratings --collection $i < $TMP_DATA/$i.json
done

echo
echo 'Removing local dump...'
echo
rm -rf $TMP_DATA

echo 'All done.'
