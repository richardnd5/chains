import 'package:chains/app.dart.dart';
import 'package:chains/services/sequencer/sequencer_service.dart';
import 'package:chains/ui/pages/markov/viewModel/mark_page_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  final providers = [
    ChangeNotifierProvider<SequencerService>(
      create: (_) => SequencerService(),
    ),
    ChangeNotifierProxyProvider<SequencerService, MarkovPageViewModel>(
      create: (context) => MarkovPageViewModel(
        Provider.of<SequencerService>(context, listen: false),
      ),
      update: (context, sequencer, vm) {
        vm!.sequencer = sequencer;
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
