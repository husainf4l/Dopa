import 'package:flutter/material.dart';
import '../../models/appointment.dart';
import '../../services/appointment_service.dart';

class AppointmentFormScreen extends StatefulWidget {
  const AppointmentFormScreen({super.key, this.appointment});

  final Appointment? appointment;

  @override
  State<AppointmentFormScreen> createState() => _AppointmentFormScreenState();
}

class _AppointmentFormScreenState extends State<AppointmentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _doctorController = TextEditingController();
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();
  late DateTime _date;
  late TimeOfDay _time;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.appointment != null) {
      _doctorController.text = widget.appointment!.doctorName;
      _locationController.text = widget.appointment!.location;
      _notesController.text = widget.appointment!.notes ?? '';
      _date = widget.appointment!.date;
      _time = TimeOfDay.fromDateTime(widget.appointment!.date);
    } else {
      _date = DateTime.now();
      _time = TimeOfDay.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.black87, size: 22),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.appointment == null ? 'New Appointment' : 'Edit Appointment',
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFE6E6E6)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8175D1).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.calendar_month_rounded,
                        color: Color(0xFF8175D1),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Appointment Details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _doctorController,
                  style: const TextStyle(fontSize: 13),
                  decoration: InputDecoration(
                    labelText: 'Doctor Name',
                    labelStyle: const TextStyle(color: Colors.black54, fontSize: 12),
                    filled: true,
                    fillColor: const Color(0xFFFAFAFA),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFEEEEEE)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFEEEEEE)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF8175D1), width: 1.5),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  ),
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _locationController,
                  style: const TextStyle(fontSize: 13),
                  decoration: InputDecoration(
                    labelText: 'Location',
                    labelStyle: const TextStyle(color: Colors.black54, fontSize: 12),
                    filled: true,
                    fillColor: const Color(0xFFFAFAFA),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFEEEEEE)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFEEEEEE)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF8175D1), width: 1.5),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  ),
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 14),
                InkWell(
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _date,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: Color(0xFF8175D1),
                              onPrimary: Colors.white,
                              onSurface: Colors.black87,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null && picked != _date) {
                      setState(() {
                        _date = picked;
                      });
                    }
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAFAFA),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFEEEEEE)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today_rounded, color: Color(0xFF8175D1), size: 16),
                        const SizedBox(width: 10),
                        const Text(
                          'Date:',
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                        const Spacer(),
                        Text(
                          '${_date.day}/${_date.month}/${_date.year}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () async {
                    final TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: _time,
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: Color(0xFF8175D1),
                              onPrimary: Colors.white,
                              onSurface: Colors.black87,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null && picked != _time) {
                      setState(() {
                        _time = picked;
                      });
                    }
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAFAFA),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFEEEEEE)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.access_time_rounded, color: Color(0xFF8175D1), size: 16),
                        const SizedBox(width: 10),
                        const Text(
                          'Time:',
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                        const Spacer(),
                        Text(
                          '${_time.hour.toString().padLeft(2, '0')}:${_time.minute.toString().padLeft(2, '0')}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _notesController,
                  maxLines: 3,
                  style: const TextStyle(fontSize: 13),
                  decoration: InputDecoration(
                    labelText: 'Notes (optional)',
                    labelStyle: const TextStyle(color: Colors.black54, fontSize: 12),
                    filled: true,
                    fillColor: const Color(0xFFFAFAFA),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFEEEEEE)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFEEEEEE)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF8175D1), width: 1.5),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() => _isLoading = true);
                        
                        try {
                          // Combine date and time
                          final dateTime = DateTime(
                            _date.year,
                            _date.month,
                            _date.day,
                            _time.hour,
                            _time.minute,
                          );
                          
                          // Convert to UTC for server
                          final utcDateTime = dateTime.toUtc();
                          
                          final payload = <String, dynamic>{
                            'doctorName': _doctorController.text.trim(),
                            'location': _locationController.text.trim(),
                            'appointmentDate': utcDateTime.toIso8601String(),
                          };
                          
                          // Add notes only if not empty
                          if (_notesController.text.trim().isNotEmpty) {
                            payload['notes'] = _notesController.text.trim();
                          } else {
                            payload['notes'] = '';
                          }
                          
                          print('[AppointmentForm] Validation passed');
                          print('[AppointmentForm] Doctor: ${payload['doctorName']}');
                          print('[AppointmentForm] Location: ${payload['location']}');
                          print('[AppointmentForm] Date: ${payload['appointmentDate']}');
                          print('[AppointmentForm] Notes: ${payload['notes']}');
                          print('[AppointmentForm] Full payload: $payload');
                          
                          if (widget.appointment == null) {
                            await AppointmentService.createDefault().createAppointment(payload);
                            print('[AppointmentForm] Appointment created successfully');
                          } else {
                            await AppointmentService.createDefault().updateAppointment(widget.appointment!.id, payload);
                            print('[AppointmentForm] Appointment updated successfully');
                          }
                          
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(widget.appointment == null 
                                  ? 'Appointment scheduled successfully!' 
                                  : 'Appointment updated successfully!'),
                                backgroundColor: const Color(0xFF8175D1),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                            // Navigate back and signal refresh
                            Navigator.of(context).pop(true);
                          }
                        } catch (e, stackTrace) {
                          print('[AppointmentForm] Error scheduling appointment: $e');
                          print('[AppointmentForm] Stack trace: $stackTrace');
                          
                          if (mounted) {
                            setState(() => _isLoading = false);
                            
                            // Extract meaningful error message
                            String errorMessage = 'Failed to schedule appointment';
                            if (e.toString().contains('400')) {
                              errorMessage = 'Invalid data. Please check all fields.';
                            } else if (e.toString().contains('401')) {
                              errorMessage = 'Session expired. Please login again.';
                            } else if (e.toString().contains('500')) {
                              errorMessage = 'Server error. Please try again later.';
                            } else if (e.toString().contains('Connection')) {
                              errorMessage = 'No internet connection';
                            }
                            
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(errorMessage),
                                backgroundColor: Colors.red,
                                duration: const Duration(seconds: 4),
                                action: SnackBarAction(
                                  label: 'Details',
                                  textColor: Colors.white,
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Error Details'),
                                        content: Text(e.toString()),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          }
                        }
                      } else {
                        print('[AppointmentForm] Validation failed');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8175D1),
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shadowColor: const Color(0xFF8175D1).withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      disabledBackgroundColor: Colors.grey.shade300,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            widget.appointment == null ? 'Schedule Appointment' : 'Update Appointment',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
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
}
