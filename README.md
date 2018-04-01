# Contributing
## TODO list
- [ ] Prefix internal macros with `exbank@`. E.g. switch all instances of `\isTrue` with `\exbank@isTrue`.
## Files
All of the code are distributed within the `src`-folder. Here is an overview. Filenames in parenthesis are not a part of the actual package, but used for "compiling" it down to `handin.sty` and documenting.
### `src/`:
- (`aftercompile.sh`) is just instructions to perform after the `.sty` and the documentation is created.
- [`documentingExample.tex`](https://github.com/Strauman/exerciseBank/blob/master/src/documentingExample.tex) All the documentation is automatically generated from the comments in the code using a custom `perl`-script. This file shows examples on how to document the code so that it shows up in the documentation properly.
- [`at.tex`](https://github.com/Strauman/exerciseBank/blob/master/src/at.tex) contains definitions of the `\At` and `\Trigger` command
- [`envcontrol.tex`](https://github.com/Strauman/exerciseBank/blob/master/src/envcontrol.tex) contains everything to do with controlling environments except from "outsourcing" stuff with `\At` and `\Trigger`: Namely deciding whether or not a problem, intro and/or solution should displayed (which is done in `setbuilder.tex`)
- [`i18n.tex`](https://github.com/Strauman/exerciseBank/blob/master/src/i18n.tex) contains everything to do with translation logic.
- [`isin.tex`](https://github.com/Strauman/exerciseBank/blob/master/src/isin.tex) contains the definition of the `\isin` macro
- [`main.tex`](https://github.com/Strauman/exerciseBank/blob/master/src/main.tex) is the main file for building during development
- (`packagehead.tex`): All the files are compiled into one `.sty`-file before sent to [CTAN](http://ctan.org). This file contains the top of that `.sty`-file.
- [`packages.tex`](https://github.com/Strauman/exerciseBank/blob/master/src/packages.tex) contains all the external packages used.
- [`pplabel.tex`](https://github.com/Strauman/exerciseBank/blob/master/src/pplabel.tex)  contains definition of custom labeling and referring of problems.
- [`preamble.tex`](https://github.com/Strauman/exerciseBank/blob/master/src/preamble.tex) contains the preamble logic. Mostly including other files.
- [`problemstyle.tex`](https://github.com/Strauman/exerciseBank/blob/master/src/problemstyle.tex)  contains `\At`-commands that are responsible for formatting exercise headers and exercise-related styles.
- [`setbuilder.tex`](https://github.com/Strauman/exerciseBank/blob/master/src/setbuilder.tex) contains the logic of the set making and set building. It also decides whether or not a problem,intro and/or solution should be built
- [`squeeze.tex`](https://github.com/Strauman/exerciseBank/blob/master/src/squeeze.tex) contains the style for which `\sprite` applies with `\squeeze`. It "squeezes" everything so that more stuff fits on the pages
- (`texpack.tex`) is the file that is built when making all these files into packaging
- (`texpackvars.ini`) contains information that is used when "compiling" the package.
### `docs/`
Docs are generated automatically. Just ignore it if you contribute. See `src/documentingExample.tex` for info on how to do documentation.
