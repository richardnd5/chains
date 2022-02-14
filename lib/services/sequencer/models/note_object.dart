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

  double _start(int tempo) {
    return (startPosition / 4) * (60 / tempo);
  }

  double _end(int tempo) {
    return ((endPosition / 4) * (60 / tempo) - _start(tempo));
  }

  Map<String, dynamic> toJson(int tempo) => {
        "notes": [letterName],
        "noteNumber": noteNumber,
        "duration": _end(tempo),
        "position": _start(tempo)
      };
}
