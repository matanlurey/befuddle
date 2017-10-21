# befuddle

<p align="center">
  Obfuscate JSON.
  <br>
  <a href="https://travis-ci.org/matanlurey/befuddle">
    <img src="https://travis-ci.org/matanlurey/befuddle.svg?branch=master" alt="Build Status" />
  </a>
  <a href="https://pub.dartlang.org/packages/befuddle">
    <img src="https://img.shields.io/pub/v/befuddle.svg" alt="Pub Package Version" />
  </a>
  <a href="https://www.dartdocs.org/documentation/befuddle/latest">
    <img src="https://img.shields.io/badge/dartdocs-latest-blue.svg" alt="Latest Dartdocs" />
  </a>
</p>

Disclaimer: This is not an official Google or Dart project.

## Usage

Befuddle is a simple application and library that is meant to replace
representative sets of JSON data (i.e. from a real backend server) with another
like-set of data. Befuddle does the following by default:

* Replaces numbers with similar (random) numbers.
* Replaces booleans with a random `true` or `false` value.
* Replaces strings with similar (random) strings.
* Replaces arrays with similar lists, with elements replaced recursively.

For maps (objects), values are replaced recursively similar to the rules above.

However, for keys (properties), it is guaranteed that the randomly generated
string is _stable_ for the entire document:

```bash
$ befuddle '[{"name": "A"}, {"name": "B"}, {"name": "C"}]'
> [{"0wUc":"u"},{"0wUc":"y"},{"0wUc":"o"}]
```

This means you could tweak an existing reader/parser to look for `0wUc` instead
of `name`, for example.

In future versions of befuddle, it may be possible to emit a symbol map to help
with tooling.

### From Pub

If you're a Dart user, you can install `befuddle` globally:

```bash
$ pub global activate befuddle
$ befuddle '[{"name": "A"}, {"name": "B"}]'
```

Or add it to your pubspec:

```yaml
dependencies:
  befuddle: ^0.1.0
```

... and use it programatically:

```dart
import 'package:befuddle/befuddle.dart';

void main(List<String> args) {
  print(befuddle(args.first));
}
```
