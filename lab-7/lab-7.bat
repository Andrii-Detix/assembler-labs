@echo off
setlocal
set OUTFILE=lab-7.exe
ml /c /coff .\lab-7.asm
ml /c /coff .\lab-7-extern.asm
link32 /subsystem:windows /out:%OUTFILE% .\lab-7.obj .\lab-7-extern.obj 
endlocal