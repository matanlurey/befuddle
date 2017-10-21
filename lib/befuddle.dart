// Copyright 2017, Google Inc.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:math';

import 'package:collection/collection.dart';

/// Obfuscate [json], and return a new copy of the provided data.
///
/// For example, `{'key': 'value'}` could be re-written as:
/// ```json
/// {
///   'abV': 'o9rm2'
/// }
/// ```
///
/// The size of the JSON is retained, but the exact values are changed. This
/// allows taking confidential data sets and making "copies" of them with
/// pseudo-random data replacing the real data - using the new fake data for
/// performance benchmarks and more.
///
/// You may optionally define a custom [random] implementation. By default a
/// cryptographically secure one ([Random.secure]) is created if not provided.
T befuddle<T>(T json, {Random random}) {
  assert(_isPrimitive(json), '"json" ($json) must be a JSON primitive.');
  try {
    json = JSON.decode(JSON.encode(json)) as T;
  } on FormatException catch (e) {
    throw new FormatException('Not valid JSON: $e.', e.source, e.offset);
  }
  final rewriter = new _Rewriter(random ?? new Random.secure());
  return rewriter.replaceAny(json) as T;
}

class _Rewriter {
  final Random _random;
  final _symbols = <String, String>{};

  _Rewriter(this._random);

  dynamic replaceAny(dynamic any, [bool key = false]) {
    if (any is String) {
      return key ? replaceStringKey(any) : replaceStringValue(any);
    }
    if (any is int) {
      return _random.nextInt(any);
    }
    if (any is double) {
      return double.parse(
        _random
            .nextDouble()
            .toStringAsPrecision(any.toString().split('.').last.length),
      );
    }
    if (any is bool) {
      return _random.nextBool();
    }
    if (any is Map) {
      return replaceMap(any);
    }
    if (any is List) {
      return replaceList(any);
    }
    if (any == null) {
      return null;
    }
    throw new ArgumentError.value(any, 'any');
  }

  List replaceList(List input) => input.map<dynamic>(replaceAny).toList();

  Map replaceMap(Map input) => mapMap<dynamic, dynamic, dynamic, dynamic>(input,
      key: (dynamic k, dynamic _) => replaceAny(k, true),
      value: (dynamic _, dynamic v) => replaceAny(v));

  String replaceStringKey(String input) {
    return _symbols.putIfAbsent(input, () => replaceStringValue(input));
  }

  String replaceStringValue(String input) {
    const chars = ''
        r'abcdefghijlmnopqrstuvwyxz'
        r'ABCDEFGHIJLMONPQRSTUVWYXZ'
        r'12345678900'
        r'$_';
    final buffer = new StringBuffer();
    final length = input.length;
    for (var i = 0; i < length; i++) {
      // TODO: Allow a custom table/encoding of characters.
      // TODO: Can we be smarter about data? i.e. if alpha-numeric, keep it.
      buffer.writeCharCode(chars.codeUnitAt(_random.nextInt(chars.length)));
    }
    return buffer.toString();
  }
}

bool _isPrimitive(Object value) =>
    value is Map ||
    value is List ||
    value is String ||
    value is num ||
    value is bool ||
    value == null;
