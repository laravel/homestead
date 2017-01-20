@echo off

set cwd=%cd%
set homesteadVagrant=%~dp0
set homesteadVagrant=%homesteadVagrant:~0,-5%

cd /d %homesteadVagrant% && vagrant %*

cd /d %cwd%

set cwd=
set homesteadVagrant=