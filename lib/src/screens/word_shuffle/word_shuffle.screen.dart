import 'dart:math';

import 'package:flutter/material.dart';
import 'package:state_change_demo/src/controllers/auth_controller.dart';
import 'package:state_change_demo/src/dialogs/waiting_dialog.dart';

class WordShuffleScreen extends StatelessWidget {
  const WordShuffleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Home"),
        ),
        body: const WordShuffle());
  }
}

List<T> scramble<T>(Iterable<T> items) {
  List<T> list = items.toList();
  Random random = Random();
  for (int i = list.length - 1; i > 0; i--) {
    int j = random.nextInt(i + 1);
    T temp = list[i];
    list[i] = list[j];
    list[j] = temp;
  }
  return list;
}

class WordShuffle extends StatefulWidget {
  const WordShuffle({super.key});

  @override
  State<WordShuffle> createState() => _WordShuffleState();
}

class _WordShuffleState extends State<WordShuffle> {
  late String finalWord;
  late List<String> words;
  late Map<int, String?> tiles;
  late Map<int, String?> tileDestinations;

  @override
  void initState() {
    super.initState();
    finalWord = 'adventure';
    words = [
      "advent",
      "adventure",
      "anted",
      "avenue",
      "date",
      "dare",
      "dart",
      "den",
      "duet",
      "due",
      "dune",
      "eat",
      "ear",
      "end",
      "era",
      "event",
      "neat",
      "nature",
      "rate",
      "rave",
      "read",
      "rent",
      "tread",
      "trade",
      "treat",
      "trend",
      "true",
      "rue",
      "urn",
      "vent",
      "venture"
    ];
    tiles = {for (int i = 0; i < finalWord.characters.length; i++) i: scramble(finalWord.characters).elementAt(i)};
    tileDestinations = {for (int i = 0; i < finalWord.characters.length; i++) i: null};
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [Text("Words: 0/${words.length}")],
          ),
          AspectRatio(
            aspectRatio: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                runSpacing: 8,
                spacing: 16,
                children: [
                  for (String word in words)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (String letter in word.characters)
                          Container(
                            height: 20,
                            width: 20,
                            margin: const EdgeInsets.only(right: 2),
                            decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(4)),
                            child: Center(child: Text(letter.toUpperCase())),
                          )
                      ],
                    )
                ],
              ),
            ),
          ),
          Flexible(
            child: GridView.count(
              padding: EdgeInsets.zero,
              crossAxisCount: finalWord.characters.length,
              childAspectRatio: 1,
              crossAxisSpacing: 4,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                for (MapEntry<int, String?> tile in tileDestinations.entries)
                  LayoutBuilder(builder: (context, constraints) {
                    if (tile.value == null) {
                      return DragTarget<MapEntry<int, String?>>(
                        onWillAcceptWithDetails: (details) {
                          return tile.value == null;
                        },
                        onAcceptWithDetails: (acceptDetails) {
                          if (mounted) {
                            setState(() {
                              tileDestinations[tile.key] = acceptDetails.data.value;
                              tiles[acceptDetails.data.key] = null;
                            });
                          }
                        },
                        builder: (BuildContext context, List<Object?> candidateData, List<dynamic> rejectedData) {
                          return Container(
                            constraints: constraints,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.7),
                                ),
                                color: Colors.grey.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(4)),
                          );
                        },
                      );
                    }
                    return Draggable<MapEntry<int, String?>>(
                      data: tile,
                      feedback: Container(
                        constraints: constraints,
                        decoration: BoxDecoration(color: Colors.white, border: Border.all(), borderRadius: BorderRadius.circular(4)),
                        child: Center(child: Text(tile.value ?? '')),
                      ),
                      childWhenDragging: Container(
                        constraints: constraints,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.7),
                            ),
                            color: Colors.grey.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(4)),
                      ),
                      child: Container(
                        constraints: constraints,
                        decoration: BoxDecoration(color: Colors.white, border: Border.all(), borderRadius: BorderRadius.circular(4)),
                        child: Center(child: Text(tile.value ?? '')),
                      ),
                    );
                  }),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [IconButton(onPressed: shuffleTiles, icon: const Icon(Icons.shuffle))],
          ),
          Flexible(
            child: GridView.count(
              padding: EdgeInsets.zero,
              crossAxisCount: finalWord.characters.length,
              childAspectRatio: 1,
              crossAxisSpacing: 4,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                for (MapEntry<int, String?> tile in tiles.entries)
                  LayoutBuilder(builder: (context, constraints) {
                    if (tile.value == null) {
                      return DragTarget<MapEntry<int, String?>>(
                        onWillAcceptWithDetails: (details) {
                          return tile.value == null;
                        },
                        onAcceptWithDetails: (acceptDetails) {
                          if (mounted) {
                            setState(() {
                              tiles[tile.key] = acceptDetails.data.value;
                              tileDestinations[acceptDetails.data.key] = null;
                            });
                          }
                        },
                        builder: (BuildContext context, List<Object?> candidateData, List<dynamic> rejectedData) {
                          return Container(
                            constraints: constraints,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.7),
                                ),
                                color: Colors.grey.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(4)),
                          );
                        },
                      );
                    }
                    return Draggable<MapEntry<int, String?>>(
                      data: tile,
                      feedback: Container(
                        constraints: constraints,
                        decoration: BoxDecoration(color: Colors.white, border: Border.all(), borderRadius: BorderRadius.circular(4)),
                        child: Center(child: Text(tile.value ?? '')),
                      ),
                      childWhenDragging: Container(
                        constraints: constraints,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.7),
                            ),
                            color: Colors.grey.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(4)),
                      ),
                      child: Container(
                        constraints: constraints,
                        decoration: BoxDecoration(color: Colors.white, border: Border.all(), borderRadius: BorderRadius.circular(4)),
                        child: Center(child: Text(tile.value ?? '')),
                      ),
                    );
                  }),
              ],
            ),
          ),
          SafeArea(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  WaitingDialog.show(context, future: AuthController.I.logout());
                },
                child: const Text("Sign out"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void shuffleTiles() {
    List<String?> currentHand = tiles.values.toList();
    print(currentHand);
    currentHand = scramble(currentHand);
    currentHand.sort((a, b) {
      if (a == null && b != null) return 1;
      if (a != null && b == null) return -1;
      return 0;
    });
    print(currentHand);
    for (int i = 0; i < currentHand.length; i++) {
      tiles[i] = currentHand[i];
    }
    print(tiles);
    setState(() {});
  }
}
