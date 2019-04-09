::check for help
@echo off
set HERE=%cd%
echo %HERE%
set help="false"
set /a count=0
FOR %%A IN (%*) DO (
    IF "%%A"=="--help" set help="true"
	IF "%%A"=="--help" set help="true"
	set /a count+=1
)
echo %count%
IF %count% LEQ 2 set help="true"
IF %count% GEQ 4 set help="true"
IF %help%=="true" (
	ECHO "git-latexdiff [old_revision] [latex_file|no extension] [newest_version]"
    ECHO For example:
    ECHO git-latexdiff HEAD~2 main master
	EXIT /B
)

:: Create new working folders
mkdir %TEMP%\cleandiff
mkdir %TEMP%\backup

:: backup current files
copy *.lof %TEMP%\backup\*.lof
copy *.lot %TEMP%\backup\*.lot
copy *.toc %TEMP%\backup\*.lof
copy *.log %TEMP%\backup\*.lof
copy *.dvi %TEMP%\backup\*.lof
copy *.aux %TEMP%\backup\*.lof
copy *.bbl %TEMP%\backup\*.bbl
copy *.blg %TEMP%\backup\*.blg
copy *.brf %TEMP%\backup\*.brf
copy *.out %TEMP%\backup\*.out
copy *.tex %TEMP%\backup\*.tex
copy *.bib %TEMP%\backup\*.bib

::generate BBL HEAD
pdflatex -interaction=batchmode %2
bibtex %2
copy %2.bbl %TEMP%\cleandiff\HEAD.bbl
::flatten HEAD
latexpand %2.tex -o temp_%2.tex
move temp_%2.tex %TEMP%\cleandiff\HEAD.tex

::pull down old
git checkout -f %1

::generate BBL PREV 
pdflatex -interaction=batchmode %2
bibtex %2
copy %2.bbl %TEMP%\cleandiff\PREV.bbl
::flatten PREV
latexpand %2.tex -o temp_%2.tex
move temp_%2.tex %TEMP%\cleandiff\PREV.tex

::go back to master
cd /d %HERE%
git checkout -f %3

::move the cleandiff and run latexdiff
cd /d %TEMP%\cleandiff
latexdiff PREV.tex HEAD.tex > diff.tex
latexdiff PREV.bbl HEAD.bbl --append-textcmd="bibinfo",  > diff.bbl
copy diff.tex %HERE%\diff.tex
copy diff.bbl %HERE%\diff.bbl

::generate pdf at %HERE% because the environment(sty/bst) needed
cd /d %HERE%
pdflatex -interaction=batchmode --output-directory=%TEMP%\cleandiff diff
pdflatex -interaction=batchmode --output-directory=%TEMP%\cleandiff diff


::move pdf back up
cd /d %TEMP%\cleandiff
copy diff.pdf %HERE%\diff.pdf
::cleanup
del /F /Q *.*

::now restore backup
cd /d %TEMP%\backup
copy *.lof %HERE%\*.lof
copy *.lot %HERE%\*.lot
copy *.toc %HERE%\*.lof
copy *.log %HERE%\*.lof
copy *.dvi %HERE%\*.lof
copy *.aux %HERE%\*.lof
copy *.bbl %HERE%\*.bbl
copy *.blg %HERE%\*.blg
copy *.brf %HERE%\*.brf
copy *.out %HERE%\*.out
copy *.tex %HERE%\*.tex
copy *.bib %HERE%\*.bib
::and clean
del /F /Q *.*
cd /d %TEMP%
rmdir cleandiff
rmdir backup
cd /d %HERE%
del diff.tex
del diff.bbl