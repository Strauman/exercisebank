## Create quickstart
cd $sourceDir
# rm quickstart.zip
# zip quickstart.zip example.tex $outfile -r ../exercises


# Create CTAN zip
rm -rf exercisebank
mkdir exercisebank

zip example.zip example.tex -r ../exercises

cp ../docs/exercisebank-doc.pdf exercisebank/
cp ../docs/exercisebank-doc.tex exercisebank/
cp example.zip exercisebank/
cp README.txt exercisebank/
cp $tmpDir/$outfile exercisebank/

zip exbankCTAN.zip -r exercisebank/
mv exbankCTAN.zip ../
# rm -rf exercisebank/

rm ../example.tex
cp example.tex ../

rm ../$outfile
cp $outfile ../

cp $outfile /Users/Andreas/Documents/uit/fag/TA/FYS-1002/Oppgaver\ FYS-1002/$outfile
