// Copyright (c) 2018, Juan Mellado. All rights reserved. Use of this source
// is governed by a MIT-style license that can be found in the LICENSE file.

import 'dart:async' show Future;

import '../logger.dart';
import 'command.dart';

/// Base class for implementing command runners.
// ignore: one_member_abstracts
abstract class CommandRunner {
  /// Runs a [command] that returns an object of type [T].
  Future<T?> run<T extends Object>(Command<T> command);
}

/// Base class for implementing a set of commands.
///
/// Extend from this class for implementing custom sets of commands, like
/// the commands exposed by the API of a module.
///
/// ```dart
/// class HelloModule extends ModuleBase {
///
///  HelloModule(Client client) : super(client);
///
///  Future<String> hello(String name) => run<String>(<Object>[r'HELLO', name]);
/// }
///
/// ...
///
/// final module = HelloModule(client);
///
/// final message = await module.hello('World!');
///
/// print(message);
/// ```
abstract class ModuleBase {
  final CommandRunner _runner;

  /// Creates a [ModuleBase] instance.
  ///
  /// Commands will be runned with the given [CommandRunner].
  ModuleBase(this._runner);

  /// Runs a Redis command [line], with an optional [mapper] for
  /// processing of the results.
  Future<T?> run<T extends Object>(Iterable<Object?> line,
      {Mapper<T>? mapper}) async {
    final command = Command<T>(line, mapper: mapper);

    return await execute<T>(command);
  }

  Future<T> runNonNull<T extends Object>(Iterable<Object?> line,
      {Mapper<T>? mapper}) async {
    final command = Command<T>(line, mapper: mapper);

    return (await run(line, mapper: mapper))!;
  }

  /// Executes a [command].
  Future<T?> execute<T extends Object>(Command<T> command) {
    log.finer(() => 'Running command: $command.');

    return _runner.run(command);
  }
}
