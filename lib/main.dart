import 'package:chains/app.dart.dart';
import 'package:chains/services/markov_learning_service.dart';
import 'package:chains/services/sequencer_service.dart';
import 'package:chains/ui/pages/viewModel/mark_page_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  final providers = [
    ChangeNotifierProvider(create: (_) => MarkovLearningService()),
    ChangeNotifierProxyProvider<MarkovLearningService, SequencerService>(
      create: (context) => SequencerService(
        Provider.of<MarkovLearningService>(context, listen: false),
      ),
      update: (context, markovService, sequencer) {
        sequencer!.markovService = markovService;
        return sequencer;
      },
    ),
    ChangeNotifierProxyProvider2<MarkovLearningService, SequencerService,
        MarkovPageViewModel>(
      create: (context) => MarkovPageViewModel(
        Provider.of<SequencerService>(context, listen: false),
        Provider.of<MarkovLearningService>(context, listen: false),
      ),
      update: (context, markovService, sequencer, vm) {
        vm!.service = markovService;
        vm.sequencer = sequencer;
        return vm;
      },
    ),
  ];
  runApp(
    MultiProvider(
      providers: providers,
      child: MaterialApp(
        home: MyApp(),
      ),
    ),
  );
}
