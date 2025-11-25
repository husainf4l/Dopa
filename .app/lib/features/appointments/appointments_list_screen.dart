import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/appointment_provider.dart';

class AppointmentsListScreen extends ConsumerWidget {
  const AppointmentsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncAppointments = ref.watch(appointmentProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Appointments')),
      body: asyncAppointments.when(
        data: (items) => ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final appointment = items[index];
            return ListTile(
              title: Text(appointment.doctorName),
              subtitle: Text('${appointment.location} • ${appointment.date}'),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Failed: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/appointments/create'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
