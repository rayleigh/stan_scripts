#!/bin/bash

while read fun; do
  fun_file="./stan/math/prim/mat/fun/temp/$fun.hpp";
  fun_test_file="./test/unit/math/mix/mat/vectorize/temp/${fun}_test.cpp";
  cp  ./test/unit/math/prim/mat/vectorize/foo_fun.hpp $fun_file;
  cp ./test/unit/math/mix/mat/vectorize/foo_test.cpp $fun_test_file;
  sed -i '' -e "s/foo/$fun/" $fun_file $fun_test_file;
  #Fix headers for vectorize file
  sed -i '' -e "s/FOO_FUN/$(echo $fun | tr '[:lower:]' '[:upper:]';)/" $fun_file;
  sed -i '' -e "s/TEST_UNIT/STAN/" $fun_file;
  sed -i '' -e "s/VECTORIZE_/FUN_/" $fun_file;
  sed -i '' -e "/.*check.*/d" $fun_file;
  sed -i '' -e "s/exp/$fun/" $fun_file;
  #Fix includes for test file
  sed -i '' -e "s/test\/unit\(.*\)vectorize\(\/${fun}\)_fun/stan\1fun\2/" $fun_test_file;
done <function_list.txt
