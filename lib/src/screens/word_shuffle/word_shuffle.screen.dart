import 'package:flutter/material.dart';

class WordShuffleScreen extends StatelessWidget {
  static const String route = "/wordShuffle";
  static const String name = "Word Shuffle";
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
  list.shuffle();

  return list;
}

class WordShuffle extends StatefulWidget {
  const WordShuffle({super.key});

  @override
  State<WordShuffle> createState() => _WordShuffleState();
}

///bug 1 shuffle is overwriting letters DONE
///bug 2, moving letters from row1 entry to row2 entry messes something up??? DONE

class _WordShuffleState extends State<WordShuffle> {
  late String finalWord;
  late List<String> words;
  List<String> submittedWords = [];
  late Map<int, String?> tiles;
  late Map<int, String?> tileDestinations;

  @override
  void initState() {
    super.initState();
    finalWord = 'adventure'.toUpperCase();
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
      "van",
      "vent",
      "venture"
    ].map((e) => e.toUpperCase()).where((e) => e.length >= 4).toList();
    List<String> initialScramble = scramble(finalWord.characters).map((e) => e.toString()).toList();
    print(initialScramble);
    tiles = {for (int i = 0; i < finalWord.characters.length; i++) i: initialScramble.elementAt(i)};
    tileDestinations = {for (int i = 0; i < finalWord.characters.length; i++) i: null};
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [Text("Words: ${submittedWords.length}/${words.length}")],
          ),
          AspectRatio(
            aspectRatio: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                runSpacing: 8,
                spacing: 16,
                children: [for (String word in words) buildValidWord(word, submittedWords.contains(word))],
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
                for (MapEntry<int, String?> tileD in tileDestinations.entries)
                  LayoutBuilder(builder: (context, constraints) {
                    if (tileD.value == null) {
                      return DragTarget<(bool, MapEntry<int, String?>)>(
                        onWillAcceptWithDetails: (details) {
                          return tileD.value == null;
                        },
                        onAcceptWithDetails: (acceptDetails) {
                          if (mounted) {
                            setState(() {
                              if (acceptDetails.data.$1 == true) {
                                tileDestinations[tileD.key] = acceptDetails.data.$2.value;
                                tileDestinations[acceptDetails.data.$2.key] = null;
                              } else {
                                tileDestinations[tileD.key] = acceptDetails.data.$2.value;
                                tiles[acceptDetails.data.$2.key] = null;
                              }
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
                    return Draggable<(bool, MapEntry<int, String?>)>(
                      data: (true, tileD), // (String,int,Text)
                      feedback: Container(
                        constraints: constraints,
                        decoration: BoxDecoration(color: Colors.white, border: Border.all(), borderRadius: BorderRadius.circular(4)),
                        child: Center(child: Text(tileD.value ?? '')),
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
                        child: Center(child: Text(tileD.value ?? '')),
                      ),
                    );
                  }),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [IconButton(onPressed: resetInput, icon: const Icon(Icons.arrow_downward))],
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
                      return DragTarget<(bool, MapEntry<int, String?>)>(
                        onWillAcceptWithDetails: (details) {
                          return tile.value == null;
                        },
                        onAcceptWithDetails: (acceptDetails) {
                          if (mounted) {
                            setState(() {
                              if (acceptDetails.data.$1 == false) {
                                tiles[tile.key] = acceptDetails.data.$2.value;
                                tiles[acceptDetails.data.$2.key] = null;
                              } else {
                                tiles[tile.key] = acceptDetails.data.$2.value;
                                tileDestinations[acceptDetails.data.$2.key] = null;
                              }
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
                    return Draggable<(bool, MapEntry<int, String?>)>(
                      data: (false, tile),
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
                      child: GestureDetector(
                        onTap: () => handleOnTap(tile),
                        child: Container(
                          constraints: constraints,
                          decoration: BoxDecoration(color: Colors.white, border: Border.all(), borderRadius: BorderRadius.circular(4)),
                          child: Center(child: Text(tile.value ?? '')),
                        ),
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
                onPressed: isValidWord() ? handleSubmit : null,
                child: Text(currentWord().isNotEmpty ? currentWord() : "NO WORD"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Row buildValidWord(String word, [bool visible = false]) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (String letter in word.characters)
          Container(
            height: 20,
            width: 20,
            margin: const EdgeInsets.only(right: 2),
            decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(4)),
            child: Center(child: Text(visible ? letter : '')),
          )
      ],
    );
  }

  void handleSubmit() {
    submittedWords.add(currentWord());
    submittedWords = Set<String>.from(submittedWords).toList();
    resetInput();
  }

  void resetInput() {
    for (MapEntry<int, String?> mapEntry in tileDestinations.entries) {
      if (mapEntry.value == null) continue;
      for (MapEntry<int, String?> handEntry in tiles.entries) {
        if (handEntry.value != null) continue;
        tiles[handEntry.key] = mapEntry.value;
        tileDestinations[mapEntry.key] = null;
        break;
      }
    }
    setState(() {});
  }

  handleOnTap(MapEntry<int, String?> tile) {
    if (tile.value == null) return;
    for (MapEntry<int, String?> mapEntry in tileDestinations.entries) {
      if (mapEntry.value != null) continue;
      tileDestinations[mapEntry.key] = tile.value;
      tiles[tile.key] = null;
      break;
    }
    setState(() {});
  }

  String currentWord() => tileDestinations.values.map((e) => e ?? ' ').join("").trim();

  bool isValidWord() {
    List<String> word = tileDestinations.values.map((e) => e ?? ' ').toList();

    /// [" "," ","a","b","c"," ","d"," ",]
    String finalWord = word.join('');

    /// "  abc d "
    finalWord = finalWord.trim();

    /// "abc d"
    if (finalWord.contains(" ")) return false;
    return words.contains(finalWord);
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
