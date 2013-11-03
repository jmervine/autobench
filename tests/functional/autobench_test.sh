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
    "deplay usage without params"

  assert_grep "$AUTOBENCH --help" "Usage" \
    "deplay usage with help param"

  assert_grep "$AUTOBENCH --server localhost" "Usage" \
    "deplay usage without config param"

  # render only
  mini_result_render=`$AUTOBENCH --config ./config/test_mini.yml -Y -C`

  assert_grep "echo \"$mini_result_render\"" "Render" \
    "render results contains Render"

  refute_grep "echo \"$mini_result_render\"" "Usage" \
    "render results does not contain usage"

  refute_grep "echo \"$mini_result_render\"" "YSlow" \
    "render results does not contain YSlow"

  refute_grep "echo \"$mini_result_render\"" "Client" \
    "render results does not contain Client"

  # yslow only
  mini_result_yslow=`$AUTOBENCH --config ./config/test_mini.yml -R -C`

  assert_grep "echo \"$mini_result_yslow\"" "YSlow" \
    "yslow results contains Render"

  refute_grep "echo \"$mini_result_yslow\"" "Usage" \
    "yslow results does not contain usage"

  refute_grep "echo \"$mini_result_yslow\"" "Render" \
    "yslow results does not contain Render"

  refute_grep "echo \"$mini_result_yslow\"" "Client" \
    "yslow results does not contain Client"

  # client only
  mini_result_client=`$AUTOBENCH --config ./config/test_mini.yml -R -Y`

  assert_grep "echo \"$mini_result_client\"" "Client" \
    "client results contains Client"

  refute_grep "echo \"$mini_result_client\"" "Usage" \
    "client results does not contain usage"

  refute_grep "echo \"$mini_result_client\"" "Render" \
    "client results does not contain Render"

  refute_grep "echo \"$mini_result_client\"" "YSlow" \
    "client results does not contain YSlow"


  # misc tests
  assert "$AUTOBENCH --config ./config/test_mini.yml --runs 1" \
    "works with only 1 run"

################################################################################
}

# vim: ft=sh:
