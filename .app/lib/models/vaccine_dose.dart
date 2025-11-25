class VaccineDose {
  VaccineDose({
    required this.id,
    required this.name,
    required this.doseNumber,
    required this.scheduledDate,
    this.completedDate,
  });

  final String id;
  final String name;
  final String doseNumber;
  final DateTime scheduledDate;
  final DateTime? completedDate;

  factory VaccineDose.fromJson(Map<String, dynamic> json) => VaccineDose(
        id: json['id'] as String,
        name: json['vaccineName'] as String,
        doseNumber: json['doseNumber'] as String,
        scheduledDate: DateTime.parse(json['scheduledDate'] as String),
        completedDate: json['completedDate'] == null ? null : DateTime.parse(json['completedDate'] as String),
      );
}
