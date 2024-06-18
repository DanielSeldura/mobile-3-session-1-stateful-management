import 'package:flutter/material.dart';

class StatefulParent extends StatefulWidget {
  /// "stateful-parent"
  static const String route = 'stateful-parent';

  /// "/stateful-parent"
  static const String path = '/stateful-parent';

  /// "Stateful Parent"
  static const String name = 'Stateful Parent';

  const StatefulParent({super.key});

  @override
  State<StatefulParent> createState() => _StatefulParentState();
}

class _StatefulParentState extends State<StatefulParent> {
  int _value = 0;

  void _increment() {
    setState(() {
      _value++;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Stateful parent build");
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stateful Parent'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StatelessChild(value: _value),
            ElevatedButton(
              onPressed: _increment,
              child: const Text('Increment'),
            ),
          ],
        ),
      ),
    );
  }
}

class StatelessChild extends StatelessWidget {
  final int value;

  const StatelessChild({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    print('stateless child build');
    return Text('Value: $value');
  }
}
