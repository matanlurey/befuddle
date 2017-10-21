// Copyright 2017, Google Inc.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:args/args.dart';
import 'package:befuddle/befuddle.dart';

void main(List<String> args) {
  if (args.isEmpty) {
    stdout.writeln(_parser.usage);
    exitCode = 1;
    return;
  }
  final results = _parser.parse(args);
  final random = results.wasParsed('seed')
      ? new Random(
          int.parse(results['seed'] as String),
        )
      : null;
  String input;
  switch (results['type'] as String) {
    case 'json':
      input = results.rest.first;
      break;
    case 'path':
      input = new File(results.rest.first).readAsStringSync();
      break;
  }
  stdout.writeln(JSON.encode(befuddle(JSON.decode(input), random: random)));
  exitCode = 0;
}

final _parser = new ArgParser()
  ..addOption(
    'seed',
    abbr: 's',
    help: 'Random seed value (NOT SECURE)',
  )
  ..addOption(
    'type',
    abbr: 't',
    allowed: const ['json', 'path'],
    defaultsTo: 'json',
  );
