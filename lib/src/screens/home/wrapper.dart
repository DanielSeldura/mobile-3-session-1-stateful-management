import 'package:flutter/material.dart';
import 'package:state_change_demo/src/screens/google_map_screen/google_map_screen.dart';
import 'package:state_change_demo/src/screens/home/home.screen.dart';

import '../../routing/router.dart';

class HomeWrapper extends StatefulWidget {
  final Widget? child;
  const HomeWrapper({super.key, this.child});

  @override
  State<HomeWrapper> createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  int index = 0;

  List<String> routes = [HomeScreen.route, "/index", GoogleMapDemoScreen.route];

  @override
  void initState() {
    super.initState();
    GlobalRouter.I.router.routeInformationProvider
        .addListener(updateCurrentRouteWhenChangeDetected);
  }

  updateCurrentRouteWhenChangeDetected() {
    String route =
        GlobalRouter.I.router.routeInformationProvider.value.uri.toString();
    if (routes.contains(route)) {
      int index = routes.indexOf(route);
      setState(() {
        this.index = index;
      });
    }
    print([route, index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child ?? const Placeholder(),
      bottomNavigationBar: BottomNavigationBar(
        // showSelectedLabels: false,
        // showUnselectedLabels: false,
        currentIndex: index,
        onTap: (i) {
          setState(() {
            index = i;
            // GoRouter.of(context).go(routes[i]);

            GlobalRouter.I.router.go(routes[i]);
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              activeIcon: Icon(
                Icons.home,
                color: Colors.blueAccent,
              ),
              label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.menu),
              activeIcon: Icon(
                Icons.menu,
                color: Colors.blueAccent,
              ),
              label: "Index"),
          BottomNavigationBarItem(
              icon: Icon(Icons.map),
              activeIcon: Icon(
                Icons.map,
                color: Colors.blueAccent,
              ),
              label: "Map"),
        ],
      ),
    );
  }
}
