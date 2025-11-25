class ResourceArticle {
  ResourceArticle({
    required this.id,
    required this.title,
    required this.summary,
    required this.category,
    required this.sourceUrl,
  });

  final String id;
  final String title;
  final String summary;
  final String category;
  final String sourceUrl;

  factory ResourceArticle.fromJson(Map<String, dynamic> json) => ResourceArticle(
        id: json['id'] as String,
        title: json['title'] as String,
        summary: json['summary'] as String,
        category: json['category'] as String,
        sourceUrl: json['sourceUrl'] as String,
      );
}
