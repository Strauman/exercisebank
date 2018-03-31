## Create quickstart
cd $sourceDir
rm quickstart.zip
zip quickstart.zip example.tex $outfile -r ../exercises
zip example.zip example.tex -r ../exercises

rm -rf exercisebank
mkdir exercisebank

cp ../docs/manual.pdf exercisebank/exercisebank.pdf
cp ../docs/manual.tex exercisebank/exercisebank.tex

cp exbankCTAN.zip exercisebank/
cp example.zip exercisebank/
cp README.txt exercisebank/
cp $outfile exercisebank/


zip exbankCTAN.zip -r exercisebank/
mv exbankCTAN.zip ../

mv quickstart.zip ../
rm $outfile.bak
rm ../example.tex
rm ../$outfile
cp example.tex ../
cp $outfile ../
cp $outfile /Users/Andreas/Documents/uit/fag/TA/FYS-1002/Oppgaver\ FYS-1002/$outfile
