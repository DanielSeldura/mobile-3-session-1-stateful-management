import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:state_change_demo/src/screens/key_example.dart';
import 'package:state_change_demo/src/screens/no_key_example.dart';
import 'package:state_change_demo/src/screens/simple_counter.screen.dart';
import 'package:state_change_demo/src/screens/simple_counter_with_initial_value.screen.dart';
import 'package:state_change_demo/src/screens/stfulP_stfulP.dart';
import 'package:state_change_demo/src/screens/stfulP_stlssC.dart';

import '../routing/router.dart';

class IndexScreen extends StatelessWidget {
  /// "/"
  static const String route = '/';

  /// "Index Screen"
  static const String name = 'Index Screen';

  const IndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(IndexScreen.name),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ListTile(
                  onTap: () {
                    GlobalRouter.I.router.push(SimpleCounterScreen.path);

                    /// /simple-counter
                  },
                  title: const Text(SimpleCounterScreen.name),
                  trailing: const Icon(Icons.chevron_right),
                ),
                ListTile(
                  onTap: () {
                    GoRouter.of(context)
                        .push(SimpleCounterScreenWithInitialValue.path);
                  },
                  title: const Text(SimpleCounterScreenWithInitialValue.name),
                  trailing: const Icon(Icons.chevron_right),
                ),
                ListTile(
                  onTap: () {
                    GoRouter.of(context).push(StatefulParent.path);
                  },
                  title: const Text(StatefulParent.name),
                  trailing: const Icon(Icons.chevron_right),
                ),
                ListTile(
                  onTap: () {
                    GoRouter.of(context).push(StatefulParentAndChild.path);
                  },
                  title: const Text(StatefulParentAndChild.name),
                  trailing: const Icon(Icons.chevron_right),
                ),
                ListTile(
                  onTap: () {
                    GoRouter.of(context).push(KeyExample.path);
                  },
                  title: const Text(KeyExample.name),
                  trailing: const Icon(Icons.chevron_right),
                ),
                ListTile(
                  onTap: () {
                    GoRouter.of(context).push(NoKeyExample.path);
                  },
                  title: const Text(NoKeyExample.name),
                  trailing: const Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
