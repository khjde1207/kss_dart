class ChunkWithIndex {
  ChunkWithIndex({
    required this.start,
    required this.text,
  });
  int start;
  String text;

  getStart() => start;
  setStart(int v) => start = v;
  getText() => text;
  setText(String v) => text = v;
}
