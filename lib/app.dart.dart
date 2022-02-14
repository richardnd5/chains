import 'package:chains/ui/pages/markov/markov_page.dart';
import 'package:chains/ui/pages/opening/opening_page.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OpeningPage();
    return MarkovPage();
  }
}
