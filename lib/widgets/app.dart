import 'package:flutter/material.dart';
import 'package:ui/screens/home_screen.dart';


class App extends StatefulWidget{
  const App({super.key});

  @override
  State<App> createState() {
    return _AppState();
  }
}

class _AppState extends State<App>{

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }

}