@set USER=dump
@set PASS=H3uH4d0vVnhw1xB
@set HOST=bernard.mongohq.com
@set PORT=10011
@set NAME=app15505665

@echo Dumping production database to local machine...
@mongodump -u %USER% -p %PASS% -d %NAME% --host %HOST%:%PORT%

@echo Restoring dumped production database to local database...
@monogorestore

@echo Removing local dump...
@rmdir /s /q "%CD%\dump"

@echo All done.
