#!/usr/bin/env node
/**
 * 03-forbidden-pattern-scanner.mjs
 *
 * Quét forbidden patterns theo quy tắc trong SKILL.md:
 *  - import package:provider / get / getx
 *  - setState(...) trong file có business logic (heuristic: file có gọi API/UseCase)
 *  - global mutable variable (top-level "var"/non-final non-const)
 *  - hardcode Color(0x...) / màu hex trong widget (ngoài core/theme/)
 *  - hardcode EdgeInsets.all(<number>) thay vì AppSpacing.*
 *  - gọi http/Dio trực tiếp trong presentation/
 *
 * Usage: node 03-forbidden-pattern-scanner.mjs --dir=lib [--json=report.json]
 */

import { readdirSync, readFileSync, statSync, writeFileSync } from 'node:fs';
import { join, extname } from 'node:path';

const args = Object.fromEntries(
  process.argv.slice(2).map((arg) => {
    const [key, value] = arg.replace(/^--/, '').split('=');
    return [key, value ?? true];
  })
);

const rootDir = args.dir || 'lib';
const violations = [];

function walk(dir, callback) {
  let entries;
  try {
    entries = readdirSync(dir);
  } catch {
    return;
  }
  for (const entry of entries) {
    const fullPath = join(dir, entry);
    const stat = statSync(fullPath);
    if (stat.isDirectory()) {
      walk(fullPath, callback);
    } else if (extname(entry) === '.dart') {
      callback(fullPath);
    }
  }
}

function record(file, rule, line, snippet) {
  violations.push({ file, rule, line, snippet: snippet.trim() });
}

function scanFile(filePath) {
  const content = readFileSync(filePath, 'utf-8');
  const lines = content.split('\n');
  const isTheme = filePath.includes('/core/theme/');
  const isPresentation = filePath.includes('/presentation/');
  const isData = filePath.includes('/data/');

  lines.forEach((line, idx) => {
    const lineNo = idx + 1;

    if (/import\s+['"]package:provider\//.test(line)) {
      record(filePath, 'FORBIDDEN_PACKAGE_PROVIDER', lineNo, line);
    }
    if (/import\s+['"]package:get\//.test(line) || /import\s+['"]package:get_it\/get_it/.test(line) === false && /import\s+['"]package:getx\//.test(line)) {
      record(filePath, 'FORBIDDEN_PACKAGE_GETX', lineNo, line);
    }

    if (/^\s*var\s+\w+\s*=/.test(line) && /^(?!.*(final|const)).*$/.test(line) && !line.trim().startsWith('//')) {
      // top-level mutable var heuristic — chỉ cảnh báo nếu ở scope global (không thụt đầu dòng nhiều)
      const indent = line.match(/^(\s*)/)[1].length;
      if (indent === 0) {
        record(filePath, 'POSSIBLE_GLOBAL_MUTABLE_VAR', lineNo, line);
      }
    }

    if (!isTheme && /Color\(0x[0-9A-Fa-f]{6,8}\)/.test(line)) {
      record(filePath, 'HARDCODE_COLOR', lineNo, line);
    }

    if (!isTheme && /EdgeInsets\.(all|symmetric|only)\([^)]*\d+(\.\d+)?[^A-Za-z]/.test(line) && !/AppSpacing/.test(line)) {
      record(filePath, 'HARDCODE_SPACING', lineNo, line);
    }

    if (isPresentation && /setState\s*\(/.test(line)) {
      record(filePath, 'SETSTATE_IN_PRESENTATION_CHECK_MANUALLY', lineNo, line);
    }

    if (isPresentation && !isData && (/Dio\(\)/.test(line) || /http\.(get|post|put|delete)\(/.test(line))) {
      record(filePath, 'DIRECT_API_CALL_IN_PRESENTATION', lineNo, line);
    }
  });
}

console.log('== Forbidden Pattern Scanner ==');
walk(rootDir, scanFile);

if (violations.length === 0) {
  console.log('✅ PASS — không phát hiện forbidden pattern');
} else {
  for (const v of violations) {
    const severity = v.rule === 'SETSTATE_IN_PRESENTATION_CHECK_MANUALLY' ? '⚠️ ' : '❌';
    console.log(`${severity} [${v.rule}] ${v.file}:${v.line} — ${v.snippet}`);
  }
  console.log(`\n⚠️  FAIL — ${violations.length} vi phạm cần xử lý`);
}

if (args.json) {
  writeFileSync(args.json, JSON.stringify({ violations }, null, 2));
  console.log(`\nBáo cáo chi tiết: ${args.json}`);
}

process.exit(violations.some((v) => v.rule !== 'SETSTATE_IN_PRESENTATION_CHECK_MANUALLY') ? 1 : 0);
