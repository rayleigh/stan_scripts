#!/bin/bash

while read fct; do
  sed -i "" -e "s/add_unary(\"$fct\")/add_unary_vectorized(\"$fct\")/" \
  src/stan/lang/function_signatures.h 
  cp src/test/test-models/good/function-signatures/math/matrix/exp.stan \
  src/test/test-models/good/function-signatures/math/matrix/$fct.stan
  sed -i "" -e "s/exp/$fct/" \
  src/test/test-models/good/function-signatures/math/matrix/$fct.stan
  make src/test/test-models/good/function-signatures/math/matrix/$fct.hpp-test
done < vectorize_function.txt 
