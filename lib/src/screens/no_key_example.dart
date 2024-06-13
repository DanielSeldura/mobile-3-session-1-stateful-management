import 'package:flutter/material.dart';

class NoKeyExample extends StatefulWidget {
  /// "no-key-example"
  static const String route = 'no-key-example';

  /// "key-example"
  static const String path = '/no-key-example';

  /// "Key Example"
  static const String name = 'No Key Example';

  const NoKeyExample({super.key});
  @override
  State<NoKeyExample> createState() => _NoKeyExampleState();
}

class _NoKeyExampleState extends State<NoKeyExample> {
  List<Widget> items = [
    const StatefulItem(
      name: "Juan",
    ),
    const StatefulItem(name: "Dos"),
    const StatefulItem(name: "BarelyPass"),
  ];

  void _shuffleItems() {
    setState(() {
      items.shuffle();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('No Keys Example'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _shuffleItems,
            child: const Text('Shuffle Items'),
          ),
          Column(
            children: items,
          ),
        ],
      ),
    );
  }
}

class StatefulItem extends StatefulWidget {
  final String name;
  const StatefulItem({super.key, required this.name});

  @override
  State<StatefulItem> createState() => _StatefulItemState();
}

class _StatefulItemState extends State<StatefulItem> {
  int _value = 0;

  void _increment() {
    setState(() {
      _value++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('[${widget.name}] Item Value: $_value'),
      trailing: ElevatedButton(
        onPressed: _increment,
        child: const Text('Increment'),
      ),
    );
  }
}
