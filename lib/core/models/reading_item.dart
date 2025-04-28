class ReadingItem {
  final String title;
  final List<String> arabic;
  final List<String> translation;
  final String? audioPath;

  ReadingItem({
    required this.title,
    required this.arabic,
    required this.translation,
    this.audioPath,
  });
}
