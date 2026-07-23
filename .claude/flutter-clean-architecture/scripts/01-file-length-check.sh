#!/usr/bin/env bash
# 01-file-length-check.sh
# Kiểm tra giới hạn số dòng: Widget 200, ViewModel 300, Repository 300, UseCase 100
#
# Usage: bash 01-file-length-check.sh <lib_dir>
# Example: bash 01-file-length-check.sh lib

set -euo pipefail

LIB_DIR="${1:-lib}"
FAIL=0

check_limit() {
  local pattern="$1"
  local limit="$2"
  local label="$3"

  while IFS= read -r -d '' file; do
    lines=$(wc -l < "$file" | tr -d ' ')
    if [ "$lines" -gt "$limit" ]; then
      echo "❌ [$label] $file — $lines dòng (giới hạn $limit)"
      FAIL=1
    fi
  done < <(find "$LIB_DIR" -type f -name "$pattern" -print0 2>/dev/null)
}

echo "== File Length Check =="
check_limit "*_view_model.dart" 300 "ViewModel"
check_limit "*_cubit.dart" 300 "ViewModel(Cubit)"
check_limit "*_bloc.dart" 300 "ViewModel(Bloc)"
check_limit "*_usecase.dart" 100 "UseCase"
check_limit "*_repository.dart" 300 "Repository"

# Widget: mọi file trong presentation/view hoặc presentation/widgets, trừ view_model/usecase/repository đã check ở trên
while IFS= read -r -d '' file; do
  case "$file" in
    *_view_model.dart|*_cubit.dart|*_bloc.dart|*_usecase.dart|*_repository.dart|*.g.dart|*.freezed.dart)
      continue ;;
  esac
  lines=$(wc -l < "$file" | tr -d ' ')
  if [ "$lines" -gt 200 ]; then
    echo "❌ [Widget] $file — $lines dòng (giới hạn 200)"
    FAIL=1
  fi
done < <(find "$LIB_DIR" -path "*/presentation/*" -type f -name "*.dart" -print0 2>/dev/null)

if [ "$FAIL" -eq 0 ]; then
  echo "✅ PASS — tất cả file trong giới hạn"
else
  echo "⚠️  FAIL — có file vượt giới hạn, cần split theo hướng dẫn architecture-mvvm.md"
  exit 1
fi
