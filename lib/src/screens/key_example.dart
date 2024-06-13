import 'package:flutter/material.dart';

class KeyExample extends StatefulWidget {
  /// "key-example"
  static const String route = 'key-example';

  /// "key-example"
  static const String path = '/key-example';

  /// "Key Example"
  static const String name = 'Key Example';
  const KeyExample({super.key});

  @override
  State<KeyExample> createState() => _KeyExampleState();
}

class _KeyExampleState extends State<KeyExample> {
  List<Widget> items = [
    StatefulItem(key: UniqueKey()),
    StatefulItem(key: UniqueKey()),
    StatefulItem(key: UniqueKey()),
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
        title: const Text('Keys Example'),
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
  const StatefulItem({super.key});

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
      title: Text('${widget.key.toString()} Item Value: $_value'),
      trailing: ElevatedButton(
        onPressed: _increment,
        child: const Text('Increment'),
      ),
    );
  }
}
