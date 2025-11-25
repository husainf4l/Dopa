class Appointment {
  Appointment({
    required this.id,
    required this.doctorName,
    required this.location,
    required this.date,
    this.notes,
  });

  final String id;
  final String doctorName;
  final String location;
  final DateTime date;
  final String? notes;

  factory Appointment.fromJson(Map<String, dynamic> json) => Appointment(
        id: json['id'] as String,
        doctorName: json['doctorName'] as String,
        location: json['location'] as String,
        date: DateTime.parse(json['appointmentDate'] as String),
        notes: json['notes'] as String?,
      );
}
