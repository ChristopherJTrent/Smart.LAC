#!/usr/bin/bash

eval "$(luarocks path --bin)"

rm ./luacov.report.html
rm ./luacov.stats.out

lua "$PWD/tests.lua" -o junit --name "test_results.xml"

luacov