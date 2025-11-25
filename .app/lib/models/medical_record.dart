class MedicalRecord {
  MedicalRecord({
    required this.id,
    required this.title,
    required this.filePath,
    this.description,
  });

  final String id;
  final String title;
  final String filePath;
  final String? description;

  factory MedicalRecord.fromJson(Map<String, dynamic> json) => MedicalRecord(
        id: json['id'] as String,
        title: json['title'] as String,
        filePath: json['filePath'] as String,
        description: json['description'] as String?,
      );
}
