class Gram {
  Gram({
    required this.gram,
    this.count = 1,
    this.nextPossibleChars,
  });
  String gram;
  int count;
  List<String>? nextPossibleChars = [];
}
