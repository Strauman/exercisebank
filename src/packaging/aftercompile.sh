## texpack did add_to_CTANDir $docPDF $docTEX $pkgSTY $sourceDir/README.txt
## Creates example and put it into src/$packageDir
## Create example zip
## Creates src/example/
function cp_to_dir(){
dir=$1
shift;
while [[ $# -gt 0 ]]
do
  # echo "Copying $1 to CTANDir $CTANDir"
  outHandle "Error in copying $1 to $dir" cp -f "$1" "$dir/"
  # echo "$1";
  shift
done
}
function make_example(){
  # Creates src/example/ and src/example.zip
  pushd . >/dev/null
  cd $sourceDir
    echo "Creating example dir: src/example/"
    exampleDir=example
    if [ -d "$exampleDir" ]; then
      rm -rf "$exampleDir"
    fi
    echo "Moving files to example dir"
    mkdir "$exampleDir"
    cp_to_dir $exampleDir example.tex
    cp -r ../exercises/ "$exampleDir/exercises"

  cd $exampleDir
    echo "Building example"
    cp $pkgSTY ./
    cp $pkgSTY "$mainDir"
    outHandle "Error in latexmk - example.tex" latexmk -pdf "example.tex" -outdir="./bin" --shell-escape -interaction=nonstopmode -f
    rm "$outfile"
    cp "bin/example.pdf" ./
    rm -rf ./bin
  cd $sourceDir
    outHandle "Error in zipping example" zip example.zip -r example
    add_to_CTANDir example.zip

    if [ $clean = true ];then
      echo "Cleaning up example"
      rm example.zip
      rm -rf "$exampleDir"
    fi

  popd > /dev/null
}
function make_github_readme(){
  rm "$mainDir/README.md.bak"
  mv "$mainDir/README.md" "$mainDir/README.md.bak"
  cp -f "$sourceDir/$packageSettingsDir/README.template.md" "$mainDir/README.md"
  add_version_vars_to "$mainDir/README.md"
}
function readme_tree(){
  pushd . > /dev/null
  cd "$CTANDir"
  file_structure=`zip_tree "example"`
  pattern="s/\#FILES/$file_structure/"
  perl -p -e "$pattern or next;" -i "$CTANDir/README.txt"
  popd > /dev/null
}
function finalize_paths(){
  cd "$mainDir"
  rm -rf "$mainDir/$CTANDirBase"
  mv "$CTANDir" "$mainDir"
  rm "$packagename.zip"
  outHandle "Error in zipping exercisebank.zip" zip "$packagename.zip" -r "./$CTANDirBase"
  if [ -d "release" ]; then
    rm -rf "release"
  fi
  mv -f "$CTANDirBase" "release"
}

cd $sourceDir
rm -rf "$mainDir/$packagename/"
make_example
readme_tree
make_github_readme
finalize_paths

echo "v${version}"
echo "b${build}"
