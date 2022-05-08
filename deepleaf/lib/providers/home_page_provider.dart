import 'package:deepleaf/state/home_page_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Provider class to provide HomePageState() to its children
class HomePageProvider extends StatelessWidget {
  final Widget child;

  HomePageProvider({Key? key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomePageState>(
      create: (_) => HomePageState(),
      child: child,
    );
  }
}
