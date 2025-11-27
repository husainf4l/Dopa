import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/record_provider.dart';
import '../../models/medical_record.dart';

class MedicalCategoryDetailScreen extends ConsumerStatefulWidget {
  final String categoryTitle;
  final String categoryName;

  const MedicalCategoryDetailScreen({
    super.key,
    required this.categoryTitle,
    required this.categoryName,
  });

  @override
  ConsumerState<MedicalCategoryDetailScreen> createState() => _MedicalCategoryDetailScreenState();
}

class _MedicalCategoryDetailScreenState extends ConsumerState<MedicalCategoryDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final medicalRecordsAsync = ref.watch(medicalRecordProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: Text(widget.categoryTitle),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF8175D1)),
        titleTextStyle: const TextStyle(
          color: Color(0xFF1A1A1A),
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        actions: [
          IconButton(
            onPressed: () => _addNewRecord(context),
            icon: const Icon(
              Icons.add_rounded,
              color: Color(0xFF8175D1),
            ),
          ),
        ],
      ),
      body: medicalRecordsAsync.when(
        data: (records) => _buildRecordsList(records),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error loading records: $error'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNewRecord(context),
        backgroundColor: const Color(0xFF8175D1),
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
    );
  }

  Widget _buildRecordsList(List<MedicalRecord> records) {
    final categoryRecords = _filterRecordsByCategory(records);

    if (categoryRecords.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: categoryRecords.length,
      itemBuilder: (context, index) {
        final record = categoryRecords[index];
        return _buildRecordCard(record);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF8175D1).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              _getCategoryIcon(),
              color: const Color(0xFF8175D1),
              size: 40,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No ${widget.categoryTitle.toLowerCase()} recorded',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first ${widget.categoryTitle.toLowerCase()} record',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF8A8A8A),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => _addNewRecord(context),
            icon: const Icon(Icons.add_rounded),
            label: Text('Add ${widget.categoryTitle}'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8175D1),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordCard(MedicalRecord record) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE4E4E4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _getCategoryColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _getCategoryIcon(),
                  color: _getCategoryColor(),
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                        letterSpacing: -0.2,
                      ),
                    ),
                    if (record.date != null)
                      Text(
                        _formatDate(record.date!),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF8A8A8A),
                        ),
                      ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _editRecord(record),
                icon: const Icon(
                  Icons.edit_rounded,
                  color: Color(0xFF9A9A9A),
                  size: 20,
                ),
              ),
            ],
          ),
          if (record.description != null && record.description!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              record.description!,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF8A8A8A),
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }

  List<MedicalRecord> _filterRecordsByCategory(List<MedicalRecord> records) {
    return records.where((record) {
      switch (widget.categoryName) {
        case 'chronic-diseases':
          return record.category == MedicalRecordCategory.chronicDisease;
        case 'medications':
          return record.category == MedicalRecordCategory.medication;
        case 'allergies':
          return record.category == MedicalRecordCategory.allergy;
        case 'surgeries':
          return record.category == MedicalRecordCategory.surgery;
        case 'vaccinations':
          return record.category == MedicalRecordCategory.vaccination;
        case 'lab-results':
          return record.category == MedicalRecordCategory.labResult;
        default:
          return false;
      }
    }).toList();
  }

  IconData _getCategoryIcon() {
    switch (widget.categoryName) {
      case 'chronic-diseases':
        return Icons.local_hospital;
      case 'medications':
        return Icons.medication;
      case 'allergies':
        return Icons.warning;
      case 'surgeries':
        return Icons.healing;
      case 'vaccinations':
        return Icons.vaccines;
      case 'lab-results':
        return Icons.science;
      default:
        return Icons.medical_services;
    }
  }

  Color _getCategoryColor() {
    switch (widget.categoryName) {
      case 'chronic-diseases':
        return const Color(0xFFFF6B6B);
      case 'medications':
        return const Color(0xFF4ECDC4);
      case 'allergies':
        return const Color(0xFFFFBE0B);
      case 'surgeries':
        return const Color(0xFF9B59B6);
      case 'vaccinations':
        return const Color(0xFF3498DB);
      case 'lab-results':
        return const Color(0xFFE74C3C);
      default:
        return const Color(0xFF95A5A6);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _addNewRecord(BuildContext context) {
    // Navigate to appropriate form based on category
    switch (widget.categoryName) {
      case 'medications':
        context.push('/home/medications/create');
        break;
      case 'vaccinations':
        context.push('/home/vaccinations/create');
        break;
      case 'chronic-diseases':
      case 'allergies':
      case 'surgeries':
      case 'lab-results':
        context.push('/home/records/edit', extra: {
          'category': widget.categoryName,
          'title': widget.categoryTitle,
        });
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Adding ${widget.categoryTitle} - Coming soon!'),
            backgroundColor: const Color(0xFF8175D1),
          ),
        );
    }
  }

  void _editRecord(MedicalRecord record) {
    // Navigate to edit screen based on record type
    switch (record.category) {
      case MedicalRecordCategory.medication:
        context.push('/home/medications/edit', extra: record);
        break;
      case MedicalRecordCategory.vaccination:
        context.push('/home/vaccinations/edit', extra: record);
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Edit functionality - Coming soon!'),
            backgroundColor: Color(0xFF8175D1),
          ),
        );
    }
  }
}