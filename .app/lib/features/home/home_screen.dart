import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../../models/medication.dart';
import '../../models/appointment.dart';
import '../../models/vaccine_dose.dart';
import '../../providers/medication_provider.dart';
import '../../providers/appointment_provider.dart';
import '../../providers/vaccination_provider.dart';
import '../../providers/saved_articles_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the providers for real data
    final medicationsAsync = ref.watch(medicationProvider);
    final appointmentsAsync = ref.watch(appointmentProvider);
    final vaccinationsAsync = ref.watch(vaccinationProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Header
              _buildHeader(),
              const SizedBox(height: 32),

              // Quick Action Tiles
              _buildQuickActions(),
              const SizedBox(height: 32),

              // Next Medicine Card
              medicationsAsync.when(
                data: (medications) => _buildNextMedicineCard(medications),
                loading: () => _buildLoadingCard('Loading medications...'),
                error: (error, stack) => _buildErrorCard('Failed to load medications'),
              ),
              const SizedBox(height: 24),

              // Next Doctor Visit Card
              appointmentsAsync.when(
                data: (appointments) => _buildNextDoctorVisitCard(appointments),
                loading: () => _buildLoadingCard('Loading appointments...'),
                error: (error, stack) => _buildErrorCard('Failed to load appointments'),
              ),
              const SizedBox(height: 24),

              // Upcoming Vaccinations
              vaccinationsAsync.when(
                data: (vaccinations) => _buildUpcomingVaccinations(vaccinations),
                loading: () => _buildLoadingCard('Loading vaccinations...'),
                error: (error, stack) => _buildErrorCard('Failed to load vaccinations'),
              ),
              const SizedBox(height: 40),

              // Latest Blogs Section
              _buildLatestBlogsSection(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              // Already on home
              break;
            case 1:
              context.push('/home/medications');
              break;
            case 2:
              context.push('/home/appointments');
              break;
            case 3:
              context.push('/home/vaccinations');
              break;
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF8175D1),
        unselectedItemColor: Colors.grey[400],
        showSelectedLabels: true,
        showUnselectedLabels: true,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medication_rounded),
            label: 'Medications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_rounded),
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.vaccines_rounded),
            label: 'Vaccinations',
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // iOS-style status bar area (placeholder)
        const SizedBox(height: 8),
        // Date
        Text(
          'Monday, 4 September',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF8A8A8A),
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 4),
        // Today
        const Text(
          'Today',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A1A),
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Builder(
      builder: (context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildQuickActionTile(
            icon: Icons.add_circle_outline_rounded,
            label: 'Action',
            onTap: () => context.push('/home/medications/create'),
          ),
          _buildQuickActionTile(
            icon: Icons.folder_open_rounded,
            label: 'Medical History',
            onTap: () => context.push('/home/medical-history'),
          ),
          _buildQuickActionTile(
            icon: Icons.article_outlined,
            label: 'Blogs',
            onTap: () => context.push('/home/resources'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 80,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF8175D1).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF8175D1),
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1A1A1A),
                letterSpacing: -0.2,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextMedicineCard(List<Medication> medications) {
    // Find the next medication that needs to be taken
    final now = DateTime.now();
    final upcomingMedications = medications.where((med) {
      // Check if medication is still active (no end date or end date is in future)
      if (med.endDate != null && med.endDate!.isBefore(now)) {
        return false;
      }
      // For now, we'll show medications that started today or earlier
      return med.startDate.isBefore(now) || med.startDate.isAtSameMomentAs(now);
    }).toList();

    if (upcomingMedications.isEmpty) {
      return _buildEmptyCard(
        'No upcoming medications',
        'Add your medications to see reminders here',
        Icons.medication_rounded,
      );
    }

    // For simplicity, show the first upcoming medication
    final nextMedication = upcomingMedications.first;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
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
          // Title
          const Text(
            'Your Next Medicine',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF8A8A8A),
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 8),
          // Medicine name
          Text(
            nextMedication.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 8),
          // Dosage
          Text(
            nextMedication.dosage,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color(0xFF8A8A8A),
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 16),
          // Divider
          Container(
            height: 1,
            color: const Color(0xFFE4E6EB),
          ),
          const SizedBox(height: 16),
          // Instructions
          Text(
            nextMedication.instructions,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF6A6A6A),
              letterSpacing: -0.2,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextDoctorVisitCard(List<Appointment> appointments) {
    // Find the next upcoming appointment
    final now = DateTime.now();
    final upcomingAppointments = appointments.where((appointment) {
      return appointment.date.isAfter(now);
    }).toList();

    // Sort by date (earliest first)
    upcomingAppointments.sort((a, b) => a.date.compareTo(b.date));

    if (upcomingAppointments.isEmpty) {
      return _buildEmptyCard(
        'No upcoming appointments',
        'Schedule your next doctor visit here',
        Icons.calendar_today_rounded,
      );
    }

    final nextAppointment = upcomingAppointments.first;
    final daysUntil = nextAppointment.date.difference(now).inDays;
    final timeUntil = daysUntil == 0 ? 'Today' : daysUntil == 1 ? 'Tomorrow' : '$daysUntil Days';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
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
          // Title
          const Text(
            'Your Next Doctor Visit',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF8A8A8A),
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 8),
          // Doctor name
          Text(
            nextAppointment.doctorName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 8),
          // Location
          Text(
            nextAppointment.location,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color(0xFF8A8A8A),
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 16),
          // Divider
          Container(
            height: 1,
            color: const Color(0xFFE4E6EB),
          ),
          const SizedBox(height: 16),
          // Timer section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Appointment in',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF8A8A8A),
                  letterSpacing: -0.2,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF8175D1).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  timeUntil,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF8175D1),
                    letterSpacing: -0.3,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingVaccinations(List<VaccineDose> vaccinations) {
    // Find upcoming vaccinations (not completed yet and scheduled for future)
    final now = DateTime.now();
    final upcomingVaccinations = vaccinations.where((vaccination) {
      return vaccination.completedDate == null && vaccination.scheduledDate.isAfter(now);
    }).toList();

    // Sort by scheduled date (earliest first)
    upcomingVaccinations.sort((a, b) => a.scheduledDate.compareTo(b.scheduledDate));

    if (upcomingVaccinations.isEmpty) {
      return _buildEmptyCard(
        'No upcoming vaccinations',
        'Stay up to date with your vaccination schedule',
        Icons.vaccines_rounded,
      );
    }

    // Show up to 3 upcoming vaccinations
    final displayVaccinations = upcomingVaccinations.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        const Text(
          'Upcoming Vaccinations',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A1A),
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Stay on top of your vaccination schedule',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF8A8A8A),
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 20),

        // Vaccination Cards
        ...displayVaccinations.map((vaccination) {
          final daysUntil = vaccination.scheduledDate.difference(now).inDays;
          final timeUntil = daysUntil == 0 ? 'Today' : daysUntil == 1 ? 'Tomorrow' : '$daysUntil Days';

          return Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
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
                // Vaccine Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF8175D1).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.vaccines_rounded,
                    color: Color(0xFF8175D1),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),

                // Vaccine Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vaccination.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A),
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Dose ${vaccination.doseNumber}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF8A8A8A),
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),
                ),

                // Due Date
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8175D1).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    timeUntil,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF8175D1),
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildLatestBlogsSection() {
    // Sample blog data
    final blogs = [
      {
        'title': 'Understanding Your Blood Pressure Readings',
        'excerpt': 'Learn what your blood pressure numbers mean and how to maintain healthy levels for better heart health.',
        'author': 'Dr. Sarah Johnson',
        'tags': ['Heart Health', 'Prevention'],
        'imageColor': const Color(0xFFE3F2FD), // Light blue
      },
      {
        'title': 'The Importance of Regular Health Screenings',
        'excerpt': 'Discover why preventive screenings are crucial for early detection and maintaining long-term wellness.',
        'author': 'Dr. Michael Chen',
        'tags': ['Prevention', 'Screening'],
        'imageColor': const Color(0xFFF3E5F5), // Light purple
      },
      {
        'title': 'Nutrition Tips for Managing Diabetes',
        'excerpt': 'Practical dietary advice to help manage blood sugar levels and improve overall quality of life.',
        'author': 'Dr. Emily Rodriguez',
        'tags': ['Diabetes', 'Nutrition'],
        'imageColor': const Color(0xFFE8F5E8), // Light green
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        const Text(
          'Latest Blogs',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A1A),
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Health and wellness articles for you',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF8A8A8A),
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 24),

        // Blog Cards
        _buildBlogCard(
          title: 'Understanding Your Blood Pressure Readings',
          excerpt: 'Learn what your blood pressure numbers mean and how to maintain healthy levels for better heart health.',
          author: 'Dr. Sarah Johnson',
          tags: ['Heart Health', 'Prevention'],
          imageColor: const Color(0xFFE3F2FD),
        ),
        const SizedBox(height: 24),
        _buildBlogCard(
          title: 'The Importance of Regular Health Screenings',
          excerpt: 'Discover why preventive screenings are crucial for early detection and maintaining long-term wellness.',
          author: 'Dr. Michael Chen',
          tags: ['Prevention', 'Screening'],
          imageColor: const Color(0xFFF3E5F5),
        ),
        const SizedBox(height: 24),
        _buildBlogCard(
          title: 'Nutrition Tips for Managing Diabetes',
          excerpt: 'Practical dietary advice to help manage blood sugar levels and improve overall quality of life.',
          author: 'Dr. Emily Rodriguez',
          tags: ['Diabetes', 'Nutrition'],
          imageColor: const Color(0xFFE8F5E8),
        ),
      ],
    );
  }

  Widget _buildBlogCard({
    required String title,
    required String excerpt,
    required String author,
    required List<String> tags,
    required Color imageColor,
  }) {
    return Builder(
      builder: (context) => Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: const Color(0xFFE4E6EB), width: 1),
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
            // Top Image Area
            Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                color: imageColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Stack(
                children: [
                  // Placeholder content - could be an image
                  Center(
                    child: Icon(
                      Icons.article_rounded,
                      size: 48,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),

                  // Floating Author Avatar
                  Positioned(
                    bottom: 16,
                    right: 20,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFE0E0E0),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        color: Color(0xFF6A6A6A),
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content Area
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Blog Title
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A1A),
                      letterSpacing: -0.3,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Short Excerpt
                  Text(
                    excerpt,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF8A8A8A),
                      letterSpacing: -0.2,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Tags
                  Row(
                    children: tags.map((tag) => Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFEFEF),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF6A6A6A),
                          letterSpacing: -0.1,
                        ),
                      ),
                    )).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Action Buttons
                  Row(
                    children: [
                      // Read More Button
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigate to blog detail screen
                            context.push('/home/blog/${title.replaceAll(' ', '-').toLowerCase()}', extra: {
                              'title': title,
                              'excerpt': excerpt,
                              'author': author,
                              'tags': tags,
                              'imageColor': imageColor,
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8175D1),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Read More',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.1,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Save Button
                      _buildSaveButton(title),

                      const SizedBox(width: 8),

                      // Share Button
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          onPressed: () {
                            // Share the article
                            Share.share(
                              'Check out this health article: "$title" by $author\n\n$excerpt',
                              subject: title,
                            );
                          },
                          icon: const Icon(
                            Icons.share_rounded,
                            color: Color(0xFF6A6A6A),
                            size: 20,
                          ),
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton(String title) {
    return Consumer(
      builder: (context, ref, child) {
        // Simple state management for saved articles (in real app, use persistent storage)
        final savedArticles = ref.watch(savedArticlesProvider);
        final isSaved = savedArticles.contains(title);

        return Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: isSaved ? const Color(0xFF8175D1).withOpacity(0.1) : const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            onPressed: () {
              // Toggle save state
              if (isSaved) {
                ref.read(savedArticlesProvider.notifier).removeArticle(title);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Removed "$title" from saved articles'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              } else {
                ref.read(savedArticlesProvider.notifier).addArticle(title);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Saved "$title" to your articles'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
            icon: Icon(
              isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
              color: isSaved ? const Color(0xFF8175D1) : const Color(0xFF6A6A6A),
              size: 20,
            ),
            padding: EdgeInsets.zero,
          ),
        );
      },
    );
  }

  Widget _buildLoadingCard(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
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
          const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8175D1)),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            message,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color(0xFF8A8A8A),
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCard(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
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
          const Icon(
            Icons.error_outline_rounded,
            color: Color(0xFFFF6B6B),
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFF8A8A8A),
                letterSpacing: -0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCard(String title, String subtitle, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFF8175D1).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF8175D1),
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF8A8A8A),
              letterSpacing: -0.2,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}