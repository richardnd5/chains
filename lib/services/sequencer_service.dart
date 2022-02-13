import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;

import 'package:chains/models/note_object.dart';
import 'package:chains/services/markov_learning_service.dart';
import 'package:flutter/material.dart';

class SequencerService extends ChangeNotifier {
  MarkovLearningService markovService;
  SequencerService(this.markovService) {
    init();
  }
  String stringToPlay = '1';

  List<NoteObject> noteList = [];

  init() {
    loadSampler();
  }

  void loadSampler() {
    js.context.callMethod('loadSampler', ['Arguments can be passed here.']);
  }

  void playSequence(List<NoteObject> noteList) {
    this.noteList = noteList;
    List<Map<String, dynamic>> theMap = [];
    noteList.forEach((element) {
      theMap.add(element.toJson(90));
    });
    var json = jsonEncode(theMap);
    js.context.callMethod('playSequencer', [json]);
    notifyListeners();
  }

  generateChain() {
    var chain = markovService.generateMarkovChain();

    if (chain != null && chain.isNotEmpty) {
      stringToPlay = chain.last;
      notifyListeners();
    } else {
      throw Exception('No chain to generate');
    }
  }
}
