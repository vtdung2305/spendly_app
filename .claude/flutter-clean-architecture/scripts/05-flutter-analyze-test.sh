#!/usr/bin/env bash
# 05-flutter-analyze-test.sh
# Wrapper chạy `flutter analyze` + `flutter test`, report pass/fail rõ ràng.
#
# Usage: bash 05-flutter-analyze-test.sh [--coverage]

set -uo pipefail

COVERAGE_FLAG=""
if [[ "${1:-}" == "--coverage" ]]; then
  COVERAGE_FLAG="--coverage"
fi

echo "== flutter analyze =="
flutter analyze
ANALYZE_EXIT=$?

echo ""
echo "== flutter test =="
flutter test $COVERAGE_FLAG
TEST_EXIT=$?

echo ""
echo "== Summary =="
if [ $ANALYZE_EXIT -eq 0 ]; then
  echo "✅ flutter analyze: PASS"
else
  echo "❌ flutter analyze: FAIL"
fi

if [ $TEST_EXIT -eq 0 ]; then
  echo "✅ flutter test: PASS"
else
  echo "❌ flutter test: FAIL"
fi

if [ -n "$COVERAGE_FLAG" ] && [ -f coverage/lcov.info ]; then
  echo ""
  echo "Coverage report: coverage/lcov.info (dùng genhtml để xem HTML nếu cần)"
fi

if [ $ANALYZE_EXIT -ne 0 ] || [ $TEST_EXIT -ne 0 ]; then
  exit 1
fi
