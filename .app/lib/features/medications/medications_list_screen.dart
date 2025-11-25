import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/medication_provider.dart';

class MedicationsListScreen extends ConsumerWidget {
  const MedicationsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medications = ref.watch(medicationProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Medications')),
      body: medications.when(
        data: (items) => ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final medication = items[index];
            return ListTile(
              title: Text(medication.name),
              subtitle: Text(medication.dosage),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Failed to load: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/medications/create'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
