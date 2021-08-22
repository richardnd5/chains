import 'dart:async';

import 'package:chains/constants/pitches_with_octaves.dart';
import 'package:quiver/async.dart';
import '../constants/acceptable_characters.dart';
import '../globals/global_functions.dart';
import '../models/note_object.dart';

class CreateNoteObjectService {
  static List<NoteObject> createNoteObjectArray(
    String melodyString,
    int key,
    List<int> mode,
  ) {
    String stringNoWhiteSpace = melodyString.replaceAll(new RegExp(r"\s+"), "");
    List<String> initialArray = _createInitialNoteArray(stringNoWhiteSpace);
    List<String> midiNoteArray =
        _convertArrayToMIDINumbers(initialArray, key, mode);
    return _createNoteObjectArrayFromMIDIArray(midiNoteArray);
  }

// Splits the melody string into individual character array,
  static List<String> _createInitialNoteArray(String string) {
    var array = string.split("");
    array.add("||"); // put a "double bar" at the end.

    /* if the first character is a note lengthen 
    or octave displacement symbol remove it 
    (a character that needs a note before it to be of use*/
    while (array[0] == ";" || array[0] == "'" || array[0] == ",") {
      array.removeAt(0);
    }
    return array;
  }

  static List<String> _convertArrayToMIDINumbers(
      List<String> array, int key, List<int> mode) {
    List<String> convertedArray = array;
    List<String> nonPermissibleChars = [];
    int bCounter = 0;
    int sharpCounter = 0;
    int upOctCounter = 0;
    int downOctCounter = 0;

    for (var i = 0; i < convertedArray.length; i++) {
      // Remove non convertable characters
      if (!acceptableCharacters.contains(convertedArray[i]) &&
          !isInteger(convertedArray[i])) {
        nonPermissibleChars.add(convertedArray[i]);
        convertedArray.removeAt(i);
        i -= 1;
      }

      // If it is an accidental, add 1 to the appropriate accidental counter (to be calculated later)
      if (convertedArray[i] == "b") {
        bCounter += 1;
      } else if (convertedArray[i] == "#") {
        sharpCounter += 1;
      }

      if (isInteger(convertedArray[i])) {
        // Change current note to MIDI note value

        int indexForScaleconvertedArray =
            (int.tryParse(convertedArray[i]) ?? 60) - 1;
        convertedArray[i] =
            '${(mode[indexForScaleconvertedArray] + key - bCounter + sharpCounter)}';

        // Take out all sharps and flats before the current note

        if (bCounter > 0 || sharpCounter > 0) {
          var start = i - (bCounter + sharpCounter);
          convertedArray.removeRange(start, i);
          i = i - (bCounter + sharpCounter);
          bCounter = 0;
          sharpCounter = 0;
        }

        // Count all the octave displacement, adjust MIDI note value and remove octave character from convertedArray
        if (convertedArray[i + 1] == "'" ||
            convertedArray[i + 1] == "," ||
            convertedArray[i + 1] == "’") {
          var temp;
          for (temp = i + 1; temp < convertedArray.length; temp++) {
            if (convertedArray[temp] == ",") {
              downOctCounter += 1;
            } else if (convertedArray[temp] == "'" ||
                convertedArray[temp] == "’") {
              upOctCounter += 1;
            } else {
              convertedArray[i] =
                  '${int.tryParse(convertedArray[i]) ?? 60 + (upOctCounter * 12) - (downOctCounter * 12)}';
              break;
            }
          }
          if (convertedArray[temp] != "," ||
              convertedArray[temp] != "'" ||
              convertedArray[temp] != "’") {
            var start = temp - (upOctCounter + downOctCounter);
            var end = start + (upOctCounter + downOctCounter);
            convertedArray.removeRange(start, end);
            upOctCounter = 0;
            downOctCounter = 0;
          }
        }
      }
    }

    return convertedArray;
  }

// Creates NoteObject array that the sequencer needs to schedule sampler to play in rhythm.
  static List<NoteObject> _createNoteObjectArrayFromMIDIArray(
      List<String> array) {
    List<NoteObject> noteObjects = [];

    for (var i = 0; i < array.length; i++) {
      // If it is a number, add a note object to the array.
      if (isInteger(array[i])) {
        int noteNumber = int.tryParse(array[i]) ?? 60;
        NoteObject noteObject = _makeNoteObject(noteNumber, i);
        noteObjects.add(noteObject);
      }

      /* If the next it is a sustain character, 
        count ahead and increment the sustain counter, 
        then convert all sustain counters in the character array to a '.' 
        (moment in sequence with no sound). */

      if (array[i] == ";" || array[i] == ":") {
        int temp;
        for (temp = i; temp < array.length; temp++) {
          if (array[temp] == ":" || array[temp] == ";") {
            array[temp] = ".";
          } else {
            noteObjects[noteObjects.length - 1].endPosition = temp;
            break;
          }
        }
      }
    }
    return noteObjects;
  }

  static NoteObject _makeNoteObject(int midiNumber, int arraySlot) {
    PitchesWithOctaves noodle = PitchesWithOctaves();
    String letterNameWithOctave = noodle.pitchesWithOctaves[midiNumber];
    int octave = int.tryParse(
        letterNameWithOctave.replaceAll(new RegExp(r'[^0-9]'), ''))!;
    int noteNumber = midiNumber;
    int startPosition = arraySlot;
    int endPosition = arraySlot + 1;

    NoteObject noteObject = NoteObject(
      noteNumber: noteNumber,
      letterName: letterNameWithOctave,
      octave: octave,
      startPosition: startPosition,
      endPosition: endPosition,
    );
    return noteObject;
  }
}
