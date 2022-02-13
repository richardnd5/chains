import 'package:chains/constants/models.dart';
import 'package:chains/models/note_object.dart';
import 'package:chains/services/helpers/create_note_object_helpers.dart';
import 'package:chains/services/markov_learning_service.dart';
import 'package:chains/services/sequencer_service.dart';
import 'package:flutter/material.dart';

class MarkovPageViewModel extends ChangeNotifier {
  SequencerService sequencer;
  MarkovLearningService service;
  MarkovPageViewModel(this.sequencer, this.service);

  String stringToPlay = '';
  List<NoteObject> noteList = [];

  void generateChainFrom(String melody, int root, Mode mode) {
    var chain = service.generateMarkovChainFrom(melody);

    if (chain != null && chain.isNotEmpty) {
      stringToPlay = chain.last;

      noteList = createNoteObjectArray(
        stringToPlay,
        root,
        mode,
      );
      notifyListeners();
    } else {
      throw Exception('No chain to generate');
    }
  }

  void playSequence({int tempo = 90}) {
    sequencer.playSequence(noteList, tempo);
  }
}
