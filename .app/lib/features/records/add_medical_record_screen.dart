import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AddMedicalRecordScreen extends ConsumerStatefulWidget {
  final String categoryTitle;

  const AddMedicalRecordScreen({
    super.key,
    required this.categoryTitle,
  });

  @override
  ConsumerState<AddMedicalRecordScreen> createState() => _AddMedicalRecordScreenState();
}

class _AddMedicalRecordScreenState extends ConsumerState<AddMedicalRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dosageController = TextEditingController();
  final _dateController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dosageController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1A1A1A)),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Add ${widget.categoryTitle}',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(24),
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
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: _getCategoryColor().withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _getCategoryIcon(),
                          color: _getCategoryColor(),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Add New ${widget.categoryTitle}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _getFormDescription(),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF8A8A8A),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Form Fields
                ..._buildFormFields(),

                const SizedBox(height: 32),

                // Save Button
                Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFF8175D1),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF8175D1).withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _saveRecord,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Save Record',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFormFields() {
    final fields = <Widget>[];

    // Title/Name field - always present
    fields.addAll([
      _buildTextField(
        controller: _titleController,
        label: _getTitleLabel(),
        hint: _getTitleHint(),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'This field is required';
          }
          return null;
        },
      ),
      const SizedBox(height: 16),
    ]);

    // Category-specific fields
    switch (widget.categoryTitle) {
      case 'Current Medications':
        fields.addAll([
          _buildTextField(
            controller: _dosageController,
            label: 'Dosage',
            hint: 'e.g., 10mg, 500mg twice daily',
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _descriptionController,
            label: 'Instructions',
            hint: 'e.g., Take with food, Once daily',
            maxLines: 3,
          ),
          const SizedBox(height: 16),
        ]);
        break;

      case 'Recent Vaccination':
        fields.addAll([
          _buildTextField(
            controller: _descriptionController,
            label: 'Vaccine Type',
            hint: 'e.g., Pfizer, Moderna, Flu Shot',
          ),
          const SizedBox(height: 16),
        ]);
        break;

      case 'Allergies':
        fields.addAll([
          _buildTextField(
            controller: _descriptionController,
            label: 'Reaction Details',
            hint: 'Describe the allergic reaction',
            maxLines: 3,
          ),
          const SizedBox(height: 16),
        ]);
        break;

      case 'Past Operations':
      case 'Recent Illness':
        fields.addAll([
          _buildTextField(
            controller: _descriptionController,
            label: 'Details',
            hint: 'Additional information about the procedure/illness',
            maxLines: 3,
          ),
          const SizedBox(height: 16),
        ]);
        break;

      case 'Emergency Contact':
        fields.addAll([
          _buildTextField(
            controller: _descriptionController,
            label: 'Phone Number',
            hint: '+1 (555) 123-4567',
          ),
          const SizedBox(height: 16),
        ]);
        break;

      default:
        fields.addAll([
          _buildTextField(
            controller: _descriptionController,
            label: 'Description',
            hint: 'Additional details (optional)',
            maxLines: 3,
          ),
          const SizedBox(height: 16),
        ]);
    }

    // Date field - present for most categories
    if (_shouldShowDateField()) {
      fields.addAll([
        _buildDateField(),
        const SizedBox(height: 16),
      ]);
    }

    return fields;
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE4E4E4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: const TextStyle(color: Color(0xFF8A8A8A)),
          hintStyle: const TextStyle(color: Color(0xFF8A8A8A)),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF8175D1), width: 2),
          ),
          contentPadding: const EdgeInsets.all(20),
        ),
      ),
    );
  }

  Widget _buildDateField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE4E4E4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: _dateController,
        readOnly: true,
        onTap: _selectDate,
        decoration: InputDecoration(
          labelText: 'Date',
          hintText: 'Select date',
          labelStyle: const TextStyle(color: Color(0xFF8A8A8A)),
          hintStyle: const TextStyle(color: Color(0xFF8A8A8A)),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF8175D1), width: 2),
          ),
          contentPadding: const EdgeInsets.all(20),
          suffixIcon: const Icon(
            Icons.calendar_today_rounded,
            color: Color(0xFF8175D1),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF8175D1),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF1A1A1A),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text = '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
      });
    }
  }

  void _saveRecord() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Save record to backend
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${widget.categoryTitle} record saved successfully!'),
          backgroundColor: const Color(0xFF27AE60),
        ),
      );
      context.pop(); // Go back to previous screen
    }
  }

  IconData _getCategoryIcon() {
    switch (widget.categoryTitle) {
      case 'Chronic Diseases':
        return Icons.local_hospital;
      case 'Current Medications':
        return Icons.medication;
      case 'Allergies':
        return Icons.warning;
      case 'Past Operations':
        return Icons.healing;
      case 'Recent Illness':
        return Icons.sick;
      case 'Family Diseases':
        return Icons.family_restroom;
      case 'Recent Travel':
        return Icons.flight;
      case 'Recent Vaccination':
        return Icons.vaccines;
      case 'Lifestyle Factors':
        return Icons.fitness_center;
      case 'Imaging':
        return Icons.image;
      case 'Lab Records':
        return Icons.science;
      case 'Emergency Contact':
        return Icons.contact_emergency;
      default:
        return Icons.medical_services;
    }
  }

  Color _getCategoryColor() {
    switch (widget.categoryTitle) {
      case 'Chronic Diseases':
        return const Color(0xFFFF6B6B);
      case 'Current Medications':
        return const Color(0xFF4ECDC4);
      case 'Allergies':
        return const Color(0xFFFFBE0B);
      case 'Past Operations':
        return const Color(0xFF9B59B6);
      case 'Recent Illness':
        return const Color(0xFFE74C3C);
      case 'Family Diseases':
        return const Color(0xFF3498DB);
      case 'Recent Travel':
        return const Color(0xFF2ECC71);
      case 'Recent Vaccination':
        return const Color(0xFF9B59B6);
      case 'Lifestyle Factors':
        return const Color(0xFFF39C12);
      case 'Imaging':
        return const Color(0xFF8E44AD);
      case 'Lab Records':
        return const Color(0xFFE67E22);
      case 'Emergency Contact':
        return const Color(0xFF16A085);
      default:
        return const Color(0xFF95A5A6);
    }
  }

  String _getFormDescription() {
    switch (widget.categoryTitle) {
      case 'Current Medications':
        return 'Add a new medication to your records';
      case 'Recent Vaccination':
        return 'Record a recent vaccination';
      case 'Allergies':
        return 'Add a new allergy to track';
      case 'Emergency Contact':
        return 'Add emergency contact information';
      default:
        return 'Add a new record to your medical history';
    }
  }

  String _getTitleLabel() {
    switch (widget.categoryTitle) {
      case 'Current Medications':
        return 'Medication Name';
      case 'Recent Vaccination':
        return 'Vaccine Name';
      case 'Allergies':
        return 'Allergen';
      case 'Emergency Contact':
        return 'Contact Name';
      case 'Recent Travel':
        return 'Destination';
      default:
        return 'Title';
    }
  }

  String _getTitleHint() {
    switch (widget.categoryTitle) {
      case 'Current Medications':
        return 'e.g., Lisinopril, Metformin';
      case 'Recent Vaccination':
        return 'e.g., COVID-19, Flu Shot';
      case 'Allergies':
        return 'e.g., Penicillin, Peanuts';
      case 'Emergency Contact':
        return 'e.g., John Doe';
      case 'Recent Travel':
        return 'e.g., Paris, France';
      default:
        return 'Enter a title for this record';
    }
  }

  bool _shouldShowDateField() {
    // Don't show date field for emergency contact
    return widget.categoryTitle != 'Emergency Contact';
  }
}