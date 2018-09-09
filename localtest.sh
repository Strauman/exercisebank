#!/bin/sh
docker run --mount src="`pwd`/tests",target=/src,type=bind --mount src="/Users/Andreas/Documents/uit/fag/reporter/travis-latexbuild/execute_tests.sh",target="/usr/bin/tsts",type=bind texbuild:initial tsts
