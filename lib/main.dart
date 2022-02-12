import 'package:chains/app.dart.dart';
import 'package:chains/services/markov_learning.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MarkovLearning()),
      ],
      child: MaterialApp(home: MyApp()),
    ),
  );
}
