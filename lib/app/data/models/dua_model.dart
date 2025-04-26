
class Dua {
  final int id;
  final String title;
  final String? urduTitle;
  final String arabic;
  final String? transliteration;
  final String translation;
  final String? reference;

  Dua({
    required this.id,
    required this.title,
    this.urduTitle,
    required this.arabic,
    this.transliteration,
    required this.translation,
    this.reference,
  });

  // Factory method to create a Dua from JSON
  factory Dua.fromJson(Map<String, dynamic> json) {
    return Dua(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'No Title',
      urduTitle: json['urduTitle'],
      arabic: json['arabic'] ?? '',
      transliteration: json['transliteration'],
      translation: json['translation'] ?? '',
      reference: json['reference'],
    );
  }

  // Convert Dua object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'urduTitle': urduTitle,
      'arabic': arabic,
      'transliteration': transliteration,
      'translation': translation,
      'reference': reference,
    };
  }
}
