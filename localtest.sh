#!/bin/sh
if [[ ! -z "$(docker images -q strauman/travis-latexbuild 2> /dev/null)" ]]; then
  docker pull strauman/travis-latexbuild;
fi
docker run --mount src="`pwd`/tests",target=/src,type=bind \
           --mount src="`pwd`/src",target=/src/src,type=bind \
           --mount src="/Users/Andreas/Documents/uit/fag/reporter/travis-latexbuild/execute_tests.sh",target="/usr/bin/tsts",type=bind texbuild:initial tsts
