import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/summary_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DOPA Dashboard')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SummaryCard(
            title: 'Medications',
            description: 'Track prescriptions and reminders',
            onTap: () => context.go('/medications'),
          ),
          SummaryCard(
            title: 'Appointments',
            description: 'Keep upcoming doctor visits organized',
            onTap: () => context.go('/appointments'),
          ),
          SummaryCard(
            title: 'Vaccinations',
            description: 'Never miss a vaccine dose',
            onTap: () => context.go('/vaccinations'),
          ),
          SummaryCard(
            title: 'Medical Records',
            description: 'Securely upload your files',
            onTap: () => context.go('/records'),
          ),
          SummaryCard(
            title: 'Resources',
            description: 'Trusted education library',
            onTap: () => context.go('/resources'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/profile'),
        child: const Icon(Icons.person_outline),
      ),
    );
  }
}
