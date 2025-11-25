import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/vaccination_provider.dart';

class VaccinationListScreen extends ConsumerWidget {
  const VaccinationListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final doses = ref.watch(vaccinationProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Vaccinations')),
      body: doses.when(
        data: (items) => ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final dose = items[index];
            return ListTile(
              title: Text(dose.name),
              subtitle: Text('Dose ${dose.doseNumber} • ${dose.scheduledDate.toLocal()}'),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Failed: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/vaccinations/create'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
