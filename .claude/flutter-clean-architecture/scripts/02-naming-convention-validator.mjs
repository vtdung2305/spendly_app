#!/usr/bin/env node
/**
 * 02-naming-convention-validator.mjs
 *
 * Kiểm tra naming convention:
 *  - File: snake_case.dart
 *  - Class Widget: PascalCase
 *  - ViewModel: suffix "ViewModel"
 *  - UseCase: suffix "UseCase"
 *  - Repository interface: prefix "I"
 *  - Repository impl: suffix "Repository" (không prefix I)
 *
 * Usage: node 02-naming-convention-validator.mjs --dir=lib
 */

import { readdirSync, readFileSync, statSync } from 'node:fs';
import { join, extname, basename } from 'node:path';

const args = Object.fromEntries(
  process.argv.slice(2).map((arg) => {
    const [key, value] = arg.replace(/^--/, '').split('=');
    return [key, value ?? true];
  })
);

const rootDir = args.dir || 'lib';
let failCount = 0;

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

const SNAKE_CASE_RE = /^[a-z0-9]+(_[a-z0-9]+)*\.dart$/;

function checkFileName(filePath) {
  const name = basename(filePath);
  if (name.endsWith('.g.dart') || name.endsWith('.freezed.dart')) return;
  if (!SNAKE_CASE_RE.test(name)) {
    console.log(`❌ [File naming] ${filePath} — không phải snake_case.dart`);
    failCount++;
  }
}

function checkClassNaming(filePath) {
  const content = readFileSync(filePath, 'utf-8');
  const classMatches = [...content.matchAll(/class\s+(\w+)/g)].map((m) => m[1]);

  for (const className of classMatches) {
    if (!/^[A-Z][A-Za-z0-9]*$/.test(className)) {
      console.log(`❌ [Class naming] ${filePath} — "${className}" không phải PascalCase`);
      failCount++;
      continue;
    }

    if (filePath.includes('/viewmodel/') || filePath.includes('_view_model.dart')) {
      if (!/ViewModel$/.test(className) && !/Cubit$/.test(className) && !/Bloc$/.test(className)) {
        console.log(
          `⚠️  [ViewModel naming] ${filePath} — "${className}" nên có suffix ViewModel/Cubit/Bloc`
        );
      }
    }

    if (filePath.includes('/usecases/') || filePath.includes('_usecase.dart')) {
      if (!/UseCase$/.test(className)) {
        console.log(`❌ [UseCase naming] ${filePath} — "${className}" thiếu suffix "UseCase"`);
        failCount++;
      }
    }

    if (filePath.includes('/repositories/')) {
      const isInterface = content.includes(`abstract class ${className}`);
      if (isInterface && !/^I[A-Z]/.test(className)) {
        console.log(
          `❌ [Repository interface naming] ${filePath} — "${className}" thiếu prefix "I"`
        );
        failCount++;
      }
      if (!isInterface && !/Repository$/.test(className)) {
        console.log(
          `❌ [Repository impl naming] ${filePath} — "${className}" thiếu suffix "Repository"`
        );
        failCount++;
      }
    }
  }
}

console.log('== Naming Convention Validator ==');
walk(rootDir, (filePath) => {
  checkFileName(filePath);
  checkClassNaming(filePath);
});

if (failCount === 0) {
  console.log('✅ PASS — naming convention hợp lệ');
  process.exit(0);
} else {
  console.log(`⚠️  FAIL — ${failCount} vi phạm naming convention`);
  process.exit(1);
}
