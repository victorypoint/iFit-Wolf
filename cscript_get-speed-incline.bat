@echo off
@pushd %~dp0
if NOT ["%errorlevel%"]==["0"] pause

cmd.exe /k cscript get-speed-incline.vbs

