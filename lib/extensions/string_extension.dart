extension stringExtension on String {
  String slice(int start, int end) {
    var charList = this.split('');
    charList.removeRange(start, end);
    return charList.join();
  }
}
