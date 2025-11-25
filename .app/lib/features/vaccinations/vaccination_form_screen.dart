import 'package:flutter/material.dart';
import '../../services/vaccination_service.dart';

class VaccinationFormScreen extends StatefulWidget {
  const VaccinationFormScreen({super.key});

  @override
  State<VaccinationFormScreen> createState() => _VaccinationFormScreenState();
}

class _VaccinationFormScreenState extends State<VaccinationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _doseController = TextEditingController();
  DateTime _scheduledDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Vaccine Dose')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Vaccine name'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _doseController,
                decoration: const InputDecoration(labelText: 'Dose number'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await VaccinationService.createDefault().createDose({
                      'vaccineName': _nameController.text,
                      'doseNumber': _doseController.text,
                      'scheduledDate': _scheduledDate.toIso8601String(),
                    });
                    if (mounted) Navigator.of(context).pop();
                  }
                },
                child: const Text('Save'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
