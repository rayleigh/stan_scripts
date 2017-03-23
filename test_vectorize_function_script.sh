#!/bin/bash

while read fct; do
  echo $fct
  make src/test/test-models/good/function-signatures/math/matrix/$fct.hpp-test
done < vectorize_function.txt 
