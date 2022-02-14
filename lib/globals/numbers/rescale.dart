class ClosedRange {
  double lowerBound;
  double upperBound;

  ClosedRange(
    this.lowerBound,
    this.upperBound,
  );
}

class Rescale {
  ClosedRange from;
  ClosedRange to;

  Rescale({required this.from, required this.to});

  double _interpolate(double x) {
    return to.lowerBound * (1 - x) + to.upperBound * x;
  }

  double _uninterpolate(double x) {
    var b = (from.upperBound - from.lowerBound != 0
        ? from.upperBound - from.lowerBound
        : 1 / from.upperBound);
    return (x - from.lowerBound) / b;
  }

  double rescale(double x) {
    return _interpolate(_uninterpolate(x));
  }
}
