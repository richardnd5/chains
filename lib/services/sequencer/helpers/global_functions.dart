bool isInteger(String? s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}
