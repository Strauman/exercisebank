#!/bin/bash
infile="smush.tex"
outfile="exbank.sty"
cat packagehead.tex > $outfile
latexpand --keep-comments $infile >> $outfile


# Remove all blank lines
sed -i.bak -E '/./!d' $outfile
# Remove all makeatletter and makeatothers (not needed for .sty)
perl -i -pe 's/(\\makeatletter|\\makeatother)//g' $outfile
# Remove all indentation
sed -i -E 's/^[[:blank:]]*//' $outfile
# Remove all newlines
# perl -0777 -i.bak -pe 's/\n/ /g' $outfile
# Remove all spaces before commands
perl -i -pe 's/(\\[a-z]+|\})\s+(\\[a-z]+)/\1\2/g' $outfile
# Remove all spaces at beginning of groups
perl -i -pe 's/\{\s+/\{/g' $outfile
# Remove all spaces at end of groups
perl -i -pe 's/\s+\}/\}/g' $outfile
# Add comment to top
cp $outfile tmpOut
echo "%% Source and documentation at https://github.com/Strauman/Handin-LaTeX" > $outfile
cat tmpOut >> $outfile
## Generate dependencylist from packages
# perl -pe '/^\\usepackage\{([^\{]+)\}/\1/' packages.tex

## Create quickstart
rm quickstart.zip
zip quickstart.zip example.tex $outfile -r ../exercises
# perl -pe 's/^(?!\\usepackage).*//; s/^\\usepackage(?:\[[^\]]+\])?\{([^\{]+)\}/\1/;s/^\n//g' packages.tex > dependencies.txt
# perl -i -pe 's/\n/,/g' dependencies.txt

mv quickstart.zip ../
rm $outfile.bak
rm ../example.tex
rm ../$outfile
cp example.tex ../
cp $outfile ../
cp $outfile /Users/Andreas/Documents/uit/fag/TA/FYS-1002/Oppgaver\ FYS-1002/$outfile
