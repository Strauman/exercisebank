# Contributing
## Files
All of the code are distributed within the `src`-folder. Here is an overview. Filenames in parenthesis are not a part of the actual package, but used for "compiling" it down to `handin.sty` and documenting.
# `src/`:
- (`aftercompile.sh`) is just instructions to perform after the `.sty` and the documentation is created.
- `documentingExample.tex` All the documentation is automatically generated from the comments in the code using a custom `perl`-script. This file shows examples on how to document the code so that it shows up in the documentation properly.
- `at.tex` contains definitions of the `\At` and `\Trigger` command
- `envcontrol.tex` contains everything to do with controlling environments except from "outsourcing" stuff with `\At` and `\Trigger`: Namely deciding whether or not a problem, intro and/or solution should displayed (which is done in `setbuilder.tex`)
- `i18n.tex` contains everything to do with translation logic.
- `isin.tex` contains the definition of the `\isin` macro
- `main.tex` is the main file for building during development
- (`packagehead.tex`): All the files are compiled into one `.sty`-file before sent to [CTAN](http://ctan.org). This file contains the top of that `.sty`-file.
- `packages.tex` contains all the external packages used.
- `pplabel.tex`  contains definition of custom labeling and referring of problems.
- `preamble.tex` contains the preamble logic. Mostly including other files.
- `problemstyle.tex`  contains `\At`-commands that are responsible for formatting exercise headers and exercise-related styles.
- `setbuilder.tex` contains the logic of the set making and set building. It also decides whether or not a problem,intro and/or solution should be built
- `squeeze.tex` contains the style for which `\sprite` applies with `\squeeze`. It "squeezes" everything so that more stuff fits on the pages
- (`texpack.tex`) is the file that is built when making all these files into packaging
- (`texpackvars.ini`) contains information that is used when "compiling" the package.
