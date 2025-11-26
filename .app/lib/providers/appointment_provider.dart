import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/appointment.dart';
import '../services/appointment_service.dart';

final appointmentProvider = FutureProvider.autoDispose<List<Appointment>>((ref) async {
  try {
    return await AppointmentService.createDefault().fetchAppointments();
  } catch (e) {
    print('[AppointmentProvider] Error fetching appointments: $e');
    return <Appointment>[];
  }
});
