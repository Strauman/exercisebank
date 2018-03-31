## Create quickstart
cd $sourceDir
rm quickstart.zip
zip quickstart.zip example.tex $outfile -r ../exercises
zip example.zip example.tex -r ../exercises
zip exbankCTAN.zip ../manual.pdf README.txt $outfile -r ../exercises
mv exbankCTAN.zip ../

mv quickstart.zip ../
rm $outfile.bak
rm ../example.tex
rm ../$outfile
cp example.tex ../
cp $outfile ../
cp $outfile /Users/Andreas/Documents/uit/fag/TA/FYS-1002/Oppgaver\ FYS-1002/$outfile
