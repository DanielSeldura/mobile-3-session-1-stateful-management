import 'package:flutter/material.dart';
import 'package:state_change_demo/src/screens/word_shuffle/word_shuffle.screen.dart';

class HomeScreen extends StatelessWidget {
  static const String route = '/home';
  static const String path = "/home";
  static const String name = "Home Screen";

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const WordShuffleScreen();
    // return Scaffold(
    //   appBar: AppBar(
    //     centerTitle: true,
    //     title: const Text("Home"),
    //   ),
    //   // bottomNavigationBar: SafeArea(
    //   //   child: Container(
    //   //     margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    //   //     height: 52,
    //   //     child: ElevatedButton(
    //   //       onPressed: () {
    //   //         WaitingDialog.show(context, future: AuthController.I.logout());
    //   //       },
    //   //       child: const Text("Sign out"),
    //   //     ),
    //   //   ),
    //   // ),
    //   body: const SafeArea(
    //     child: UserProfileScreen()
    //   ),
    // );
  }
}

class ProgrammaticallyScrollToIndexedItem extends StatefulWidget {
  const ProgrammaticallyScrollToIndexedItem({super.key});

  @override
  State<ProgrammaticallyScrollToIndexedItem> createState() => _ProgrammaticallyScrollToIndexedItemState();
}

class _ProgrammaticallyScrollToIndexedItemState extends State<ProgrammaticallyScrollToIndexedItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: const Text("Scroll to "),
          onTap: () {
            Scrollable.ensureVisible(const GlobalObjectKey(9).currentContext!, duration: const Duration(milliseconds: 250));
          },
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (int i = 1; i < 200; i++)
                  Container(
                    key: GlobalObjectKey(i),
                    padding: const EdgeInsets.all(24),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: i % 2 == 0 ? Colors.grey : Colors.orangeAccent,
                    child: Center(child: Text("Item $i")),
                  )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
