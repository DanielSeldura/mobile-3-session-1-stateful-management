import 'package:flutter/material.dart';

class StatefulParentAndChild extends StatefulWidget {
  /// "stateful-parent-and-child-parent"
  static const String route = 'stateful-parent-and-child';

  /// "/stateful-parent-and-child"
  static const String path = '/stateful-parent-and-child';

  /// "Stateful Parent"
  static const String name = 'Stateful Parent and Child';

  const StatefulParentAndChild({super.key});

  @override
  State<StatefulParentAndChild> createState() => _StatefulParentAndChildState();
}

class _StatefulParentAndChildState extends State<StatefulParentAndChild> {
  int _parentValue = 0;

  void _incrementParent() {
    setState(() {
      _parentValue++;
    });
  }

  int x = 4, y = 2;
  num newV = 0;
  multiply() {
    num z = (x * y * _parentValue++);
    setState(() {
      newV = z;
    });
    print(newV);
  }

  delayedIncrement() async {
    await Future.delayed(const Duration(seconds: 10));
    print("Async finished");
    if (mounted) {
      setState(() {
        newV = 9999;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stateful Parent and Child'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Parent Value: $newV'),
            StatefulChild(),
            ElevatedButton(
              onPressed: delayedIncrement,
              //_incrementParent,
              child: const Text('Increment Parent'),
            ),
          ],
        ),
      ),
    );
  }
}

class StatefulChild extends StatefulWidget {
  const StatefulChild({super.key});

  @override
  State<StatefulChild> createState() => _StatefulChildState();
}

class _StatefulChildState extends State<StatefulChild> {
  int _childValue = 0;

  void _incrementChild() {
    setState(() {
      _childValue++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Child Value: $_childValue'),
        ElevatedButton(
          onPressed: _incrementChild,
          child: const Text('Increment Child'),
        ),
      ],
    );
  }
}
