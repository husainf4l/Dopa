import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/record_provider.dart';
import '../../services/medical_record_service.dart';

class MedicalRecordsScreen extends ConsumerWidget {
  const MedicalRecordsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final records = ref.watch(medicalRecordProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Medical Records')),
      body: records.when(
        data: (items) => ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final record = items[index];
            return ListTile(
              title: Text(record.title),
              subtitle: Text(record.description ?? 'No description'),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Failed: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await FilePicker.platform.pickFiles();
          if (result != null && result.files.single.path != null) {
            await MedicalRecordService.createDefault().uploadRecord(
              title: result.files.single.name,
              file: File(result.files.single.path!),
            );
            ref.refresh(medicalRecordProvider);
          }
        },
        child: const Icon(Icons.file_upload),
      ),
    );
  }
}
