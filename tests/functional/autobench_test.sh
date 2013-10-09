#!/usr/bin/env bash

AUTOBENCH='./bin/autobench --runs 3'

function run_tests {
################################################################################
# Tests go here.
################################################################################

  #
  # autobench
  #

  assert_grep "$AUTOBENCH" "Usage" \
    "autobench should deplay usage without params"

  assert_grep "$AUTOBENCH --help" "Usage" \
    "autobench should deplay usage with help param"

  assert_grep "$AUTOBENCH --server localhost" "Usage" \
    "autobench should deplay usage without config param"

  # render only
  mini_result_render=`$AUTOBENCH --config ./config/test_mini.yml -Y -C`

  assert_grep "echo \"$mini_result_render\"" "Render" \
    "autobench render results should contain Render"

  refute_grep "echo \"$mini_result_render\"" "Usage" \
    "autobench render results should not contain usage"

  refute_grep "echo \"$mini_result_render\"" "YSlow" \
    "autobench render results should not contain YSlow"

  refute_grep "echo \"$mini_result_render\"" "Client" \
    "autobench render results should not contain Client"

  # yslow only
  mini_result_yslow=`$AUTOBENCH --config ./config/test_mini.yml -R -C`

  assert_grep "echo \"$mini_result_yslow\"" "YSlow" \
    "autobench yslow results should contain Render"

  refute_grep "echo \"$mini_result_yslow\"" "Usage" \
    "autobench yslow results should not contain usage"

  refute_grep "echo \"$mini_result_yslow\"" "Render" \
    "autobench yslow results should not contain Render"

  refute_grep "echo \"$mini_result_yslow\"" "Client" \
    "autobench yslow results should not contain Client"

  # client only
  mini_result_client=`$AUTOBENCH --config ./config/test_mini.yml -R -Y`

  assert_grep "echo \"$mini_result_client\"" "Client" \
    "autobench client results should contain Client"

  refute_grep "echo \"$mini_result_client\"" "Usage" \
    "autobench client results should not contain usage"

  refute_grep "echo \"$mini_result_client\"" "Render" \
    "autobench client results should not contain Render"

  refute_grep "echo \"$mini_result_client\"" "YSlow" \
    "autobench client results should not contain YSlow"


  # misc tests
  assert "$AUTOBENCH --config ./config/test_mini.yml --runs 1" \
    "should work with only 1 run"

################################################################################
}

source ./tests/support/CLIunit.sh

# vim: ft=sh:
