extension DoubleExt on double {
  bool canFill(int number) {
    return truncate() >= number || (this + .5).truncate() >= number;
  }
}
