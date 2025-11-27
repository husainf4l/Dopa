enum MedicalRecordCategory {
  medication,
  vaccination,
  appointment,
  chronicDisease,
  allergy,
  surgery,
  labResult,
  other,
}

class MedicalRecord {
  MedicalRecord({
    required this.id,
    required this.title,
    required this.category,
    this.description,
    this.filePath,
    this.date,
  });

  final String id;
  final String title;
  final MedicalRecordCategory category;
  final String? description;
  final String? filePath;
  final DateTime? date;

  factory MedicalRecord.fromJson(Map<String, dynamic> json) => MedicalRecord(
        id: json['id'] as String,
        title: json['title'] as String,
        category: MedicalRecordCategory.values.firstWhere(
          (e) => e.name == json['category'],
          orElse: () => MedicalRecordCategory.other,
        ),
        description: json['description'] as String?,
        filePath: json['filePath'] as String?,
        date: json['date'] != null ? DateTime.parse(json['date'] as String) : null,
      );

  // Factory constructors for different data types
  factory MedicalRecord.fromMedication(dynamic medication) => MedicalRecord(
        id: medication.id,
        title: medication.name,
        category: MedicalRecordCategory.medication,
        description: '${medication.dosage} - ${medication.instructions}',
        date: medication.startDate,
      );

  factory MedicalRecord.fromVaccination(dynamic vaccination) => MedicalRecord(
        id: vaccination.id,
        title: vaccination.name,
        category: MedicalRecordCategory.vaccination,
        description: 'Dose ${vaccination.doseNumber}',
        date: vaccination.scheduledDate,
      );

  factory MedicalRecord.fromAppointment(dynamic appointment) => MedicalRecord(
        id: appointment.id,
        title: 'Appointment with ${appointment.doctorName}',
        category: MedicalRecordCategory.other, // Could be a separate category
        description: appointment.notes,
        date: appointment.date,
      );
}
