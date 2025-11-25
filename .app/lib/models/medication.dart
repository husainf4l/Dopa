class Medication {
  Medication({
    required this.id,
    required this.name,
    required this.dosage,
    required this.instructions,
    required this.startDate,
    this.endDate,
  });

  final String id;
  final String name;
  final String dosage;
  final String instructions;
  final DateTime startDate;
  final DateTime? endDate;

  factory Medication.fromJson(Map<String, dynamic> json) => Medication(
        id: json['id'] as String,
        name: json['name'] as String,
        dosage: json['dosage'] as String,
        instructions: json['instructions'] as String,
        startDate: DateTime.parse(json['startDate'] as String),
        endDate: json['endDate'] == null ? null : DateTime.parse(json['endDate'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'dosage': dosage,
        'instructions': instructions,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate?.toIso8601String(),
      };
}
