#!/usr/bin/env bash

AUTOBENCH_CONFIG='./bin/autobench-config --server github.com --uri /jmervine/autobench --runs 3'

function run_tests {
################################################################################
# Tests go here.
################################################################################

  #
  # autobench-config
  #

  assert_grep "$AUTOBENCH_CONFIG" "Usage" \
    "autobench-config deplay usage without params"

  assert_grep "$AUTOBENCH_CONFIG --help" "Usage" \
    "autobench-config deplay usage with help param"

  assert_grep "$AUTOBENCH_CONFIG --runs 1" "Usage" \
    "autobench-config deplay usage without output param"

  # render only
  mini_result_render=`$AUTOBENCH_CONFIG --output /tmp/test_render.yml -Y -C`

  assert_grep "echo \"$mini_result_render\"" "Render" \
    "autobench-config render results should contain Render"

  refute_grep "echo \"$mini_result_render\"" "Usage" \
    "autobench-config render results should not contain usage"

  refute_grep "echo \"$mini_result_render\"" "YSlow" \
    "autobench-config render results should not contain YSlow"

  refute_grep "echo \"$mini_result_render\"" "Client" \
    "autobench-config render results should not contain Client"

  assert_file "/tmp/test_render.yml" \
    "autobench-config render should have created an a file"

  # yslow only
  mini_result_yslow=`$AUTOBENCH_CONFIG --output /tmp/test_yslow.yml -R -C`

  assert_grep "echo \"$mini_result_yslow\"" "YSlow" \
    "autobench-config yslow results should contain Render"

  refute_grep "echo \"$mini_result_yslow\"" "Usage" \
    "autobench-config yslow results should not contain usage"

  refute_grep "echo \"$mini_result_yslow\"" "Render" \
    "autobench-config yslow results should not contain Render"

  refute_grep "echo \"$mini_result_yslow\"" "Client" \
    "autobench-config yslow results should not contain Client"

  assert_file "/tmp/test_yslow.yml" \
    "autobench-config yslow should have created an a file"

  # client only
  mini_result_client=`$AUTOBENCH_CONFIG --output /tmp/test_client.yml -R -Y`

  assert_grep "echo \"$mini_result_client\"" "Client" \
    "autobench-config client results should contain Client"

  refute_grep "echo \"$mini_result_client\"" "Usage" \
    "autobench-config client results should not contain usage"

  refute_grep "echo \"$mini_result_client\"" "Render" \
    "autobench-config client results should not contain Render"

  refute_grep "echo \"$mini_result_client\"" "YSlow" \
    "autobench-config client results should not contain YSlow"

  assert_file "/tmp/test_client.yml" \
    "autobench-config client should have created an a file"

  # do it all
  assert "$AUTOBENCH_CONFIG --output /tmp/test_all.yml" \
    "autobench-config all results should work"

  assert_file "/tmp/test_all.yml" \
    "autobench-config all should have created an a file"

################################################################################
}

source ./tests/support/functional_helper.sh

# vim: ft=sh:
