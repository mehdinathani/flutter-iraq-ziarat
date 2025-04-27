class ReadingItem {
  final String title;
  final String content;
  final String? audioPath; // <-- Add this

  ReadingItem({
    required this.title,
    required this.content,
    this.audioPath, // <-- Make it optional
  });
}
