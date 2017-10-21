// Copyright 2017, Google Inc.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math';

import 'package:befuddle/befuddle.dart' as lib;
import 'package:test/test.dart';

void main() {
  Random random;

  // Overwritten 'befuddle' that uses a seeded 'Random'.
  T befuddle<T>(T input) => lib.befuddle(input, random: random);

  setUp(() => random = new Random(0));

  test('should obfuscate a String', () {
    expect(befuddle('foobar'), 'Ff6A2z');
  });

  test('should obsfucate an int', () {
    expect(befuddle(1234), 261);
  });

  test('should obsfucate a double', () {
    expect(befuddle(0.15), 0.83);
  });

  test('should obsfucate a bool', () {
    expect(befuddle(false), false);
    expect(befuddle(false), false);
    expect(befuddle(false), true);
  });

  test('should obsfucate a List', () {
    expect(
      befuddle([1, 2, 3, 4]),
      [0, 1, 1, 3],
    );
  });

  test('should obsfucate a Mao', () {
    expect(
      befuddle({'a': 1, 'b': 2, 'c': 3}),
      {'F': 0, '6': 1, '2': 0},
    );
  });

  test('should obsfucate a Map and retain name stability', () {
    expect(
      befuddle([
        {
          'id': 101,
          'name': 'Important Client 1',
          'email': 'secret1@company.org',
        },
        {
          'id': 102,
          'name': 'Important Client 2',
          'email': 'secret2@company.org',
        },
        {
          'id': 103,
          'name': 'Important Client 3',
          'email': 'secret3@company.org',
        }
      ]),
      [
        {
          'Ff': 83,
          'A2zx': r'9ys2Gv2wED4UyHug0n',
          'U6ZO2': r'Aa4A0s0Jy_vQqX7HIQ$'
        },
        {
          'Ff': 10,
          'A2zx': r'hYdOJJfu8WWBX$ygd2',
          'U6ZO2': r'v5YJW$PZEsU30AJ5A9t'
        },
        {
          'Ff': 39,
          'A2zx': r'nPYMCPJ5vZrl01doqS',
          'U6ZO2': r'shcajmTE7qC8Yjh_ESn'
        }
      ],
    );
  });
}
