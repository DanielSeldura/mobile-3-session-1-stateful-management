import 'package:flutter/material.dart';

class SimpleCounterScreenWithInitialValue extends StatefulWidget {
  /// "simple-counter"
  static const String route = 'simple-counter';

  /// "simple-counter"
  static const String path = '/simple-counter';

  /// "Simple Counter Screen"
  static const String name = 'Simple Counter Screen (with initial Value)';

  final int initialValue;
  const SimpleCounterScreenWithInitialValue(
      {super.key, required this.initialValue});
  // const SimpleCounterScreenWithInitialValue({super.key,  this.initialValue = 0});

  @override
  State<SimpleCounterScreenWithInitialValue> createState() =>
      _SimpleCounterScreenWithInitialValueState();
}

class _SimpleCounterScreenWithInitialValueState
    extends State<SimpleCounterScreenWithInitialValue> {

  ///initially, this value is uninitialized
  late int _counter;

  @override
  void initState() {
    super.initState();
    ///this is where we get the data from the constructor
    _counter = widget.initialValue;
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(SimpleCounterScreenWithInitialValue.name),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
