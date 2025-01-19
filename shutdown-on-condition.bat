@echo off

:START
ping 127.0.0.1 -n 120
if exist shutdown.txt (
    shutdown /s /t 300
    goto :END
) else (
    goto :START
)
:END