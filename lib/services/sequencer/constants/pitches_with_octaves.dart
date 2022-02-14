const noteLetters = [
  "C",
  "C#",
  "D",
  "D#",
  "E",
  "F",
  "F#",
  "G",
  "G#",
  "A",
  "A#",
  "B"
];

class PitchesWithOctaves {
  PitchesWithOctaves() {
    for (var j = 0; j < 9; j++) {
      for (var i = 0; i < noteLetters.length; i++) {
        pitchesWithOctaves.add('${noteLetters[i]}${j - 1}');
      }
    }
  }
  var pitchesWithOctaves = [];
}
