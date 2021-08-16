class NoteObject {
  NoteObject({
    required this.noteNumber,
    this.letterName,
    required this.octave,
    required this.startPosition,
    required this.endPosition,
  });
  late int noteNumber;
  String? letterName;
  late int octave;
  late int startPosition;
  late int endPosition;
  static int tempo = 120;

  double _start() {
    return (startPosition / 4) * (60 / tempo);
  }

  double _end() {
    return ((endPosition / 4) * (60 / tempo) - _start());
  }

  Map<String, dynamic> toJson() => {
        "notes": [letterName],
        "duration": _end(),
        "position": _start()
      };
}
