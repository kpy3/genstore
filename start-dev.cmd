@ECHO OFF

SETLOCAL

CHCP 1251 >NUL

SET SCRIPT_HOME=%~dp0
SET ERL_LIBS=deps
SET ERL_OPTS=+A 10 +P 134217727 -smp auto

start "Running genstore in development mode..." ^
"%ERLANG_HOME%"\bin\erl %ERL_OPTS% -pa %SCRIPT_HOME%\ebin -boot start_sasl -config config\dev.config -s genstore

TITLE Console

ENDLOCAL
