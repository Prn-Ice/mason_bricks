// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:{{#snakeCase}}{{project_name}}{{/snakeCase}}/features/counter/counter.dart';
import 'package:{{#snakeCase}}{{project_name}}{{/snakeCase}}/gen/locale_keys.g.dart';

// ignore_for_file: prefer-single-widget-per-file
@RoutePage<void>()
class CounterPage extends ConsumerWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text(LocaleKeys.counter_appBarTitle).tr()),
      body: const Center(child: CounterText()),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              ref.read(CounterCubit.provider.bloc).increment();
            },
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            onPressed: () {
              ref.read(CounterCubit.provider.bloc).decrement();
            },
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}

class CounterText extends ConsumerWidget {
  const CounterText({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final count = ref.watch(CounterCubit.provider);

    return Text('$count', style: theme.textTheme.displayLarge);
  }
}
