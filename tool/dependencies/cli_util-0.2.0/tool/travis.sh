#!/bin/bash

# Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
# for details. All rights reserved. Use of this source code is governed by a
# BSD-style license that can be found in the LICENSE file.

# Fast fail the script on failures.   
set -e

# Verify that the libraries are error free.
dartanalyzer --fatal-warnings \
  lib/cli_util.dart \
  test/cli_util_test.dart

# Run the tests.
dart test/cli_util_test.dart

# Ensure we can run.
dart example/main.dart

# Install dart_coveralls; gather and send coverage data.
if [ "$COVERALLS_TOKEN" ]; then
  pub global activate dart_coveralls
  pub global run dart_coveralls report \
    --token $COVERALLS_TOKEN \
    --retry 2 \
    --exclude-test-files \
    test/cli_util_test.dart
fi
