## texpack did add_to_CTANDir $docPDF $docTEX $pkgSTY $sourceDir/README.txt
## Creates example and put it into src/$packageDir
## Create example zip
## Creates src/example/
function cp_to_dir(){
dst=$1
shift;
while [[ $# -gt 0 ]]
do
  # echo "Copying $1 to CTANDir $CTANDir"
  outHandle "Error in copying $1 to $dst" cp -f "$1" "$dst/"
  # echo "$1";
  shift
done
}
example_files="../examples-for-release";
example_dst=example/
function clean_files_recursive(){
  echo "Cleaning files in `pwd -P`"
  # find -E . -type f -regex '.*\.(bak|log|aux|fdb_latexmk|fls|cut)'
  # find -E . -type d -regex '.*bin$'
  find -E . -type f -regex '.*\.(bak|log|aux|fdb_latexmk|fls|cut)' -delete
  find -E . -type d -regex '.*bin$' -delete
}
function make_example(){
  ## Prepares a copy of examples-for-release/ and
  ## creates src/example/ and src/example.zip for releasing
  pushd . >/dev/null
    cd $sourceDir
    echo "Creating example dir: src/example/"
    if [ -d "$example_dst" ]; then
      echo "Deleting src/example"
      rm -rf "$example_dst"
    fi
    mkdir "$example_dst"
    echo "Moving files to example dir"
    cp -r "$example_files/." "$example_dst"
    echo "`pwd`"
    cd "$example_dst";
    rm "exercisebank.sty"
    ## Remove the development file and replace with production file
    # rm "example.tex"
    # mv "example-production.tex" "example.tex"
    # rm "example-production.pdf"
    ## Remove the exercisebank.sty dummy
    ## Delete the bin directories
    # cd $example_dst;

    clean_files_recursive
    echo "Building example"
    cp $pkgSTY ./
    cp $pkgSTY "$mainDir"
    # if [ -f "$mainDir/tests/$packagename.sty" ]; then
      # rm "$mainDir/tests/$packagename.sty"
    # fi
    # cp $pkgSTY "$mainDir/tests/$packagename.sty"
    # Recursively clean all pdfs
    find -E . -type f -regex '.*\.pdf' -delete
    outHandle "Error in latexmk - example.tex" latexmk -pdf "example.tex" -outdir="./bin" --shell-escape -interaction=nonstopmode -f
    rm "$outfile"
    cp "bin/example.pdf" ./
    rm -rf ./bin
    echo "Example folder structure:"
    tree .
  cd $sourceDir
    outHandle "Error in zipping example" zip example.zip -r example
    add_to_CTANDir example.zip

    if [ $clean = true ];then
      echo "Cleaning up example"
      rm example.zip
    fi
    if [ $clean_exampledir = true ]; then
      rm -rf "$example_dst"
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
  # add_version_vars_to "$CTANDir/README.txt"
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
if [ $build_examples = true ]; then
clean_exampledir=true;
make_example
fi
readme_tree
make_github_readme
finalize_paths

echo "v${version}"
echo "b${build}"
