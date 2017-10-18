@echo off
echo tcpdfcrop v0.9.4 (2015-08-06)
setlocal
if /I "%~1"=="/h" (
  set BBOX=HiResBoundingBox
  shift
) else (
  set BBOX=BoundingBox
)
set FROMDIR=%~dp1
set FROM=%~n1
set TODIR=%~dp2
set TO=%~n2
set RANGE=%~3
set TPX=_tcpc
set CROPTEMP=croptemp
if "%FROM%"=="" (
  echo Usage: tcpdfcrop [/h] in.pdf [out.pdf] [page-range] [left-margin] [top-margin] [right-margin] [bottom-margin]
  echo Option /h uses HiResBoundingBox instead of BoundingBox.
)
if not exist "%FROMDIR%%FROM%.pdf" exit /B
if not "%TEMP%"=="" cd "%TEMP%"
copy "%FROMDIR%%FROM%.pdf" "%CROPTEMP%.pdf" 1>nul
if "%TO%"=="" set TO=%FROM%-crop
if "%TODIR%"=="" set TODIR=%FROMDIR%
if "%TODIR%%TO%"=="%FROMDIR%%FROM%" set TO=%FROM%-crop
if exist "%TODIR%%TO%.pdf" del "%TODIR%%TO%.pdf"
if exist "%TODIR%%TO%.pdf" exit /B
extractbb "%CROPTEMP%.pdf"
type "%CROPTEMP%.xbb" | find "%%Pages: " > "%CROPTEMP%-pages.txt"
set /P NUM=<"%CROPTEMP%-pages.txt"
set NUM=%NUM:* =%
type "%CROPTEMP%.xbb" | find "%%PDFVersion: " > "%CROPTEMP%-version.txt"
set /P VERSION=<"%CROPTEMP%-version.txt"
set VERSION=%VERSION:*.=%
del "%CROPTEMP%.xbb" "%CROPTEMP%-pages.txt" "%CROPTEMP%-version.txt"
for /F "tokens=1,2 delims=-" %%m in ("%RANGE%") do (
  set FIRST=%%m
  set LAST=%%n
)
if "%FIRST%"=="" set FIRST=1
if "%FIRST%"=="*" set FIRST=1
if "%LAST%"=="" (
  if "%RANGE%"=="" (
    set LAST=%NUM%
  ) else (
    set LAST=%FIRST%
  )
)
if "%LAST%"=="*" set LAST=%NUM%
set LMARGIN=%~4
set TMARGIN=%~5
set RMARGIN=%~6
set BMARGIN=%~7
if "%LMARGIN%"=="" set LMARGIN=0
if "%TMARGIN%"=="" set TMARGIN=0
if "%RMARGIN%"=="" set RMARGIN=0
if "%BMARGIN%"=="" set BMARGIN=0
echo \pdfoutput=1 >%TPX%n.tex
echo \pdfminorversion=%VERSION% >>%TPX%n.tex
for /L %%i in (%FIRST%,1,%LAST%) do (
  rungs -dBATCH -dNOPAUSE -q -sDEVICE=bbox -dFirstPage=%%i -dLastPage=%%i "%CROPTEMP%.pdf" 2>&1 | find "%%%BBOX%: " >%TPX%%%i.tex
  echo {\catcode37=13 \catcode13=12 \def^^^^25^^^^25#1: #2^^^^M{\gdef\do{\proc[#2]}}\input %TPX%%%i.tex\relax}{}^
  \def\proc[#1 #2 #3 #4]{\pdfhorigin-#1bp \pdfvorigin#2bp \pdfpagewidth=\dimexpr#3bp-#1bp\relax\pdfpageheight\dimexpr#4bp-#2bp\relax}\do^
  \advance\pdfhorigin by %LMARGIN%bp\relax \advance\pdfpagewidth by %LMARGIN%bp\relax \advance\pdfpagewidth by %RMARGIN%bp\relax^
  \advance\pdfvorigin by -%BMARGIN%bp\relax \advance\pdfpageheight by %BMARGIN%bp\relax \advance\pdfpageheight by %TMARGIN%bp\relax^
  \setbox0=\hbox{\pdfximage page %%i mediabox{%CROPTEMP%.pdf}\pdfrefximage\pdflastximage}^
  \ht0=\pdfpageheight \shipout\box0\relax >>%TPX%n.tex
)
echo \end >>%TPX%n.tex
pdftex -no-shell-escape -interaction=batchmode %TPX%n.tex 1>nul
for /L %%i in (%FIRST%,1,%LAST%) do del %TPX%%%i.tex
del %TPX%n.tex %TPX%n.log %CROPTEMP%.pdf
if not exist %TPX%n.pdf exit /B
move "%TPX%n.pdf" "%TODIR%%TO%.pdf" 1>nul
echo ==^> %FIRST%-%LAST% page(s) written on "%TODIR%%TO%.pdf".
