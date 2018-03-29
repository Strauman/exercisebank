#!/bin/bash
# Where is the source code?

sourcedir=../src/

docdir=`pwd`
cd ../src/
# pwd
# The file to read and write for latexpand (relative to exbankDir)
expandFileIn=smush.tex
expandFileOut=../docs/exbank.tex
echo "" > $expandFileOut
# First run latexpand to get everything into one file
latexpand --keep-comments $expandFileIn >> $expandFileOut

#Go back and do documentation!
cd $docdir
./docextract.pl $expandFileOut
# latexmk -pdf documentation.tex -outdir=bin
# cp bin/documentation.pdf ./
