import 'package:chains/constants/models.dart';
import 'package:chains/globals/markov_chain_function.dart';
import 'package:chains/models/note_object.dart';
import 'package:chains/services/helpers/create_note_object_helpers.dart';
import 'package:chains/services/sequencer_service.dart';
import 'package:flutter/material.dart';

class MarkovPageViewModel extends ChangeNotifier {
  SequencerService sequencer;

  MarkovPageViewModel(this.sequencer);

  String stringToPlay = '';
  List<NoteObject> noteList = [];

  void generateMarkovMelody(String melody, int root, Mode mode) {
    var chain = generateMarkovChain(melody);

    if (chain != null && chain.isNotEmpty) {
      stringToPlay = chain;

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
