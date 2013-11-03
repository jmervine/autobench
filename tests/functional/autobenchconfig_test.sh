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
    "deplay usage without params"

  assert_grep "$AUTOBENCH_CONFIG --help" "Usage" \
    "deplay usage with help param"

  assert_grep "$AUTOBENCH_CONFIG --runs 1" "Usage" \
    "deplay usage without output param"

  # render only
  mini_result_render=`$AUTOBENCH_CONFIG --output /tmp/test_render.yml -Y -C`

  assert_grep "echo \"$mini_result_render\"" "Render" \
    "render results contains Render"

  refute_grep "echo \"$mini_result_render\"" "Usage" \
    "render results does not contain usage"

  refute_grep "echo \"$mini_result_render\"" "YSlow" \
    "render results does not contain YSlow"

  refute_grep "echo \"$mini_result_render\"" "Client" \
    "render results does not contain Client"

  assert_file "/tmp/test_render.yml" \
    "render created an a file"

  # yslow only
  mini_result_yslow=`$AUTOBENCH_CONFIG --output /tmp/test_yslow.yml -R -C`

  assert_grep "echo \"$mini_result_yslow\"" "YSlow" \
    "yslow results contains Render"

  refute_grep "echo \"$mini_result_yslow\"" "Usage" \
    "yslow results does not contain usage"

  refute_grep "echo \"$mini_result_yslow\"" "Render" \
    "yslow results does not contain Render"

  refute_grep "echo \"$mini_result_yslow\"" "Client" \
    "yslow results does not contain Client"

  assert_file "/tmp/test_yslow.yml" \
    "yslow created an a file"

  # client only
  mini_result_client=`$AUTOBENCH_CONFIG --output /tmp/test_client.yml -R -Y`

  assert_grep "echo \"$mini_result_client\"" "Client" \
    "client results contains Client"

  refute_grep "echo \"$mini_result_client\"" "Usage" \
    "client results does not contain usage"

  refute_grep "echo \"$mini_result_client\"" "Render" \
    "client results does not contain Render"

  refute_grep "echo \"$mini_result_client\"" "YSlow" \
    "client results does not contain YSlow"

  assert_file "/tmp/test_client.yml" \
    "client created an a file"

  # do it all
  assert "$AUTOBENCH_CONFIG --output /tmp/test_all.yml" \
    "all results work"

  assert_file "/tmp/test_all.yml" \
    "all created an a file"

################################################################################
}

# vim: ft=sh:
