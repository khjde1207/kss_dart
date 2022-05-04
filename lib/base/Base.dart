class Base {
  static bool empty(List<dynamic> o) {
    return o.isEmpty;
  }

  bool top(List<String> stack, String symbol) {
    return true; //Objects.equals(stack.peek(), symbol);
  }
}
