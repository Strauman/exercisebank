# Exercisebank [![Gitter](https://badges.gitter.im/exercisebank/community.svg)](https://gitter.im/exercisebank/community?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)  [![Build Status](https://travis-ci.org/Strauman/exercisebank.svg?branch=develop)](https://travis-ci.org/Strauman/exercisebank)

Develop build status: [![Build Status](https://travis-ci.org/Strauman/exercisebank.svg?branch=develop)](https://travis-ci.org/Strauman/exercisebank)

Check out the bleeding edge version in the [releases](https://github.com/Strauman/exercisebank/releases) section. Any testing help is appreciated!

# Updated documentation
The latest release is stored in this zip: [exercisebank.zip](https://github.com/Strauman/exerciseBank/raw/master/exercisebank.zip)
You can download the latest documentation here: [release/exercisebank.pdf](https://github.com/Strauman/exercisebank/blob/master/release/exercisebank-doc.pdf).
This is the documentation for version 0.3.0, and might not be the same as for the one on CTAN. If you're using the CTAN version (if you didn't get the package from this repo) then use the [CTAN](https://ctan.org/pkg/exercisebank) [documentation](http://mirrors.ctan.org/macros/latex/contrib/exercisebank/exercisebank-doc.pdf)

# Versions
Download latest(/github)-version here: [exercisebank.zip](https://github.com/Strauman/exerciseBank/blob/master/exercisebank.zip)
GitHub at version: 0.3.0 (2019/03/18) build 137

CTAN at version: v0.3.0 (2019/03/18) build 137

*It might take up to 24 hours from CTAN version is uploaded until you can download it, and then even a few more days until it is updated at TeXLive and MiKTeX*

A build has no major changes in the core code (could be changes in documentation, or cosmetic changes in the code). Every time a minor version (that is the middle version number) changes, an upload is made to CTAN. If the patch version change (the last version number) is significant, it will also be uploaded to CTAN. The build number (ideally) never resets.

# Contributing
## Files
Check out [`documentation-doc.tex`](https://github.com/Strauman/exerciseBank/blob/master/documentation-doc.tex) for instructions on how to document the code. All the documentation is automatically generated from the comments in the code using a custom `perl`-script. This file shows examples on how to document the code so that it shows up in the documentation properly.
All of the code are distributed within the `src`-folder. Here is an overview. The `src/packaging/` directory only contains info for building the package, but used for "compiling" it down to `exercisebank.sty` and documenting.
### `src/`:
- [`at.tex`](https://github.com/Strauman/exerciseBank/blob/master/src/at.tex) contains definitions of the `\At` and `\Trigger` commands
- [`envcontrol.tex`](https://github.com/Strauman/exerciseBank/blob/master/src/envcontrol.tex) contains everything to do with controlling environments except from "outsourcing" stuff with `\At` and `\Trigger`: Namely deciding whether or not a problem, intro and/or solution should displayed (which is done in `setbuilder.tex`)
- [`exercisebank.tex`](https://github.com/Strauman/exerciseBank/blob/master/src/exercisebank.tex) is the "main" file. It does most of the including of other files.
- [`exercisecommands.tex`](https://github.com/Strauman/exerciseBank/blob/master/src/exercisecommands.tex) contains the definition for `\DeclareExerciseCommand`, which are commands that can be used in the `\makeset` when including problems. Like e.g. `\phead`.
- [`helpers.tex`](https://github.com/Strauman/exerciseBank/blob/master/src/helpers.tex) contains helping "functions". For example the definition of the `\strif`, `\exb@isin` and `\exb@intersetion@any` macro
- [`hidetags.tex`](https://github.com/Strauman/exerciseBank/blob/master/src/hidetags.tex) contains the code for `\HideTags` and `\ShowAllTags` commands.
- [`i18n.tex`](https://github.com/Strauman/exerciseBank/blob/master/src/i18n.tex) contains everything to do with translation logic (`\translateExBank`).
- [`ifs.tex`](https://github.com/Strauman/exerciseBank/blob/master/src/ifs.tex) contains definitions and default value for every `\if`-statement.
- [`lengths.tex`](https://github.com/Strauman/exerciseBank/blob/master/src/lengths.tex) contains definitions and default values of the `\newlength` defined, and modified, by exercisebank.
- [`main.tex`](https://github.com/Strauman/exerciseBank/blob/master/src/main.tex) is the main file for building during development.
- [`packageoptions.tex`](https://github.com/Strauman/exerciseBank/blob/master/src/packageoptions.tex) contains all the macros that are intended for user configuration
- [`packages.tex`](https://github.com/Strauman/exerciseBank/blob/master/src/packages.tex) contains all the external packages used.
- [`pathcontrol.tex`](https://github.com/Strauman/exerciseBank/blob/master/src/pathcontrol.tex) contains the logic that makes figures available within scope of exercise folder.
- [`pointsystem.tex`](https://github.com/Strauman/exerciseBank/blob/master/src/pointsystem.tex) contains the logic and definition of the point system.
- [`pplabel.tex`](https://github.com/Strauman/exerciseBank/blob/master/src/pplabel.tex)  contains definition of custom labeling and referring of problems.
- [`problemoptions.tex`](https://github.com/Strauman/exerciseBank/blob/master/src/problemoptions.tex) contains definition of the `\nextproblem`-command and it's options.
- [`problemstyle.tex`](https://github.com/Strauman/exerciseBank/blob/master/src/problemstyle.tex)  contains `\At`-commands that are responsible for formatting exercise headers and exercise-related styles.
- [`setbuilder.tex`](https://github.com/Strauman/exerciseBank/blob/master/src/setbuilder.tex) contains the logic of the set making and set building. It also decides whether or not a problem,intro and/or solution should be built
- [`spaceignore.tex`](https://github.com/Strauman/exerciseBank/blob/master/src/spaceignore.tex) contains the code for ignoring newline spaces in the code. Not active yet though.
- [`squeeze.tex`](https://github.com/Strauman/exerciseBank/blob/master/src/squeeze.tex) contains the style for which `\sprite` applies with `\squeeze`. It "squeezes" everything so that more stuff fits on the pages
- (`exbankpack.tex`) is the file that is built when making all these files into packaging
#### `src/packaging`
- `aftercompile.sh` is just instructions to perform after the `.sty` and the documentation is created.
- `packagehead.tex`: All the files are compiled into one `.sty`-file before sent to [CTAN](http://ctan.org). This file contains the top of that `.sty`-file.
- `README.txt` README file for CTAN.
- `texpackvars.ini` contains information that is used when "compiling" the package.
### `docs/`
Docs are generated automatically. See [`documentation-doc.tex`](https://github.com/Strauman/exerciseBank/blob/master/documentation-doc.tex) for info on how to do documentation.
### `tests/`
Writing tests is also very highly appreciated:
The `tests/` directory contains multiple things.

See how the [tests/sanitycheck/main.tex](https://github.com/Strauman/exercisebank/tree/develop/tests/sanitycheck/main.tex) is made, and you can make similar structures.
Exercises are located in [tests/exercises](https://github.com/Strauman/exercisebank/tree/develop/tests/exercises). You can read more on how the tests would work [here](https://github.com/Strauman/travis-latexbuild). The best would be if you could clone this git, change stuff and make pull requests to this github with your tests.  (Then the tests would actually be run!).

Also: If you have docker installed and are on OS X or Linux, you can use `./runtests.sh` to run the tests locally on your computer.
