#!/usr/bin/env node
/**
 * 04-dependency-direction-checker.mjs
 *
 * Kiểm tra dependency rule: Presentation → Domain → Data (không đảo ngược)
 *  - domain/ không được import 'package:flutter/'
 *  - presentation/ không được import trực tiếp '.../data/...'
 *  - domain/ không được import '.../data/...' hoặc '.../presentation/...'
 *  - không cross-feature import: features/A/... không import features/B/...
 *
 * Usage: node 04-dependency-direction-checker.mjs --dir=lib
 */

import { readdirSync, readFileSync, statSync } from 'node:fs';
import { join, extname } from 'node:path';

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

function getFeature(filePath) {
  const match = filePath.match(/features\/([^/]+)\//);
  return match ? match[1] : null;
}

function checkFile(filePath) {
  const content = readFileSync(filePath, 'utf-8');
  const imports = [...content.matchAll(/import\s+['"]([^'"]+)['"]/g)].map((m) => m[1]);
  const ownFeature = getFeature(filePath);

  const isDomain = filePath.includes('/domain/');
  const isPresentation = filePath.includes('/presentation/');

  for (const imp of imports) {
    if (isDomain && imp.startsWith('package:flutter/')) {
      console.log(`❌ [DOMAIN_IMPORTS_FLUTTER] ${filePath} imports "${imp}"`);
      failCount++;
    }

    if (isDomain && (imp.includes('/data/') || imp.includes('/presentation/'))) {
      console.log(`❌ [DOMAIN_DEPENDS_ON_OUTER_LAYER] ${filePath} imports "${imp}"`);
      failCount++;
    }

    if (isPresentation && imp.includes('/data/')) {
      console.log(`❌ [PRESENTATION_IMPORTS_DATA_DIRECTLY] ${filePath} imports "${imp}"`);
      failCount++;
    }

    const impFeature = imp.match(/features\/([^/]+)\//)?.[1];
    if (ownFeature && impFeature && impFeature !== ownFeature) {
      console.log(
        `❌ [CROSS_FEATURE_IMPORT] ${filePath} (feature "${ownFeature}") imports feature "${impFeature}": "${imp}"`
      );
      failCount++;
    }
  }
}

console.log('== Dependency Direction Checker ==');
walk(rootDir, checkFile);

if (failCount === 0) {
  console.log('✅ PASS — dependency direction đúng, không cross-feature import');
  process.exit(0);
} else {
  console.log(`⚠️  FAIL — ${failCount} vi phạm dependency rule`);
  process.exit(1);
}
