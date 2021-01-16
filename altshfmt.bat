@echo off
setlocal
set ALTSHFMT_WINCWD=%CD%
set WSLENV=ALTSHFMT_WINCWD/pu:%WSLENV%
cd "%~dp0"
bash altshfmt %*
