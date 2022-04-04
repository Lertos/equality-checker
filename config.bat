@echo off

REM ----------------------------
REM IIS Setup
REM ----------------------------

REM Whether white space is ignored when comparing
set ignoreWhiteSpace=true

REM Folder Prefixes - Have as many as you want. These will all be checked against each other
REM Provide the different folder path UPTO the part of the path that's equal
set iisPaths=C:\Users\SomeUser\Desktop\devpath
set iisPaths=%iisPaths%;C:\Users\SomeUser\Desktop\quapath
set iisPaths=%iisPaths%;C:\Users\SomeUser\Desktop\prdpath

REM ----------------------------
REM SQL Setup
REM ----------------------------

REM Whether white space is ignored when comparing
set ignoreWhiteSpaceSQL=true

set username=test
set password=test123

REM SQL Servers - Have as many as you want. These will all be checked against each other
REM example: "sqlServers[0]=ServerDEV"
set sqlServers[0]=ServerDEV
set sqlServers[1]=ServerQUA
set sqlServers[2]=ServerPRD