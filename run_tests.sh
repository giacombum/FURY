#!/bin/bash

all_passed () {
  local array="$1[@]"
  local ok=1
  for element in "${!array}"; do
    if [ "$element" == 'F' ]; then
      ok=0
      break
    fi
  done
  echo $ok
}

declare -a tests_executed

echo "Run all tests"
# non intentionally failing tests
echo
echo "Run non intentionally failing tests"
for e in $( find ./exe/ -type f -executable -print | grep -v failure); do
  is_passed=`$e | grep -i "Are all tests passed? " | awk '{print $5}'`
  echo "  run test $e, is passed? $is_passed"
  tests_executed=("${tests_executed[@]}" "$is_passed")
  if [ "$is_passed" == 'F' ]; then
    echo
    echo "Test failed"
    $e
  fi
done
passed=$(all_passed tests_executed)
echo "Number of tests executed ${#tests_executed[@]}"
if [ $passed -eq 1 ]; then
  echo "All non intentionally failing tests passed"
else
  echo "Some non intentionally failing tests failed"
  exit 1
fi
# intentionally failing tests
echo
echo "Run intentionally failing tests"
for e in $( find ./exe/ -type f -executable -print | grep failure); do
  is_passed=`$e 2>/dev/null | grep -i "Are all tests passed? " | awk '{print $5}'`
  if [ "$is_passed" == 'F' ]; then
    is_passed='T';
  else
    is_passed='F';
  fi
  echo "  run test $e, is passed? $is_passed"
  tests_executed=("${tests_executed[@]}" "$is_passed")
  if [ "$is_passed" == 'F' ]; then
    echo
    echo "Test failed"
    $e
  fi
done
passed=$(all_passed tests_executed)
echo "Number of tests executed ${#tests_executed[@]}"
if [ $passed -eq 1 ]; then
  echo "All intentionally failing tests passed"
else
  echo "Some intentionally failing tests failed"
  exit 1
fi
exit 0
