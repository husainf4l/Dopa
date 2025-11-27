import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../../providers/profile_provider.dart';
import '../../providers/record_provider.dart';
import '../../models/medical_record.dart';

class MedicalHistoryScreen extends ConsumerStatefulWidget {
  const MedicalHistoryScreen({super.key});

  @override
  ConsumerState<MedicalHistoryScreen> createState() => _MedicalHistoryScreenState();
}

class _MedicalHistoryScreenState extends ConsumerState<MedicalHistoryScreen> with TickerProviderStateMixin {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _bmiCardController;
  late AnimationController _healthScoreCardController;
  late AnimationController _completenessCardController;
  late Animation<double> _bmiCardAnimation;
  late Animation<double> _healthScoreCardAnimation;
  late Animation<double> _completenessCardAnimation;
  late AnimationController _gridController;
  late Animation<Offset> _gridSlideAnimation;
  late AnimationController _vitalStatsController;
  late Animation<double> _vitalStatsAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    // Initialize card animations with staggered delays
    _bmiCardController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _healthScoreCardController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _completenessCardController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _bmiCardAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _bmiCardController,
      curve: Curves.elasticOut,
    ));

    _healthScoreCardAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _healthScoreCardController,
      curve: Curves.elasticOut,
    ));

    _completenessCardAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _completenessCardController,
      curve: Curves.elasticOut,
    ));

    // Initialize grid slide animation
    _gridController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _gridSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _gridController,
      curve: Curves.easeOutCubic,
    ));

    // Initialize vital stats bounce animation
    _vitalStatsController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _vitalStatsAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _vitalStatsController,
      curve: Curves.elasticOut,
    ));

    // Start main fade animation
    _fadeController.forward();

    // Start vital stats animation
    _vitalStatsController.forward();

    // Start card animations with delays
    Future.delayed(const Duration(milliseconds: 200), () {
      _bmiCardController.forward();
    });
    Future.delayed(const Duration(milliseconds: 400), () {
      _healthScoreCardController.forward();
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      _completenessCardController.forward();
    });

    // Start grid animation after cards
    Future.delayed(const Duration(milliseconds: 800), () {
      _gridController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _bmiCardController.dispose();
    _healthScoreCardController.dispose();
    _completenessCardController.dispose();
    _gridController.dispose();
    _vitalStatsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileControllerProvider);
    final medicalRecordsAsync = ref.watch(medicalRecordProvider);

    // Debug logging
    // print('Profile state: ${profileState.profile?.fullName ?? 'No profile'}');
    // print('Medical records async: ${medicalRecordsAsync.value?.length ?? 'Loading/No data'}');

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _refreshData,
          color: const Color(0xFF8175D1),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Header
                _buildHeader(),
                const SizedBox(height: 24),

                // Health Summary Dashboard
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: _buildHealthSummaryDashboard(profileState, medicalRecordsAsync),
                ),
                const SizedBox(height: 32),

                // Patient Identity Section
                _buildPatientIdentityCard(profileState),
                const SizedBox(height: 24),

                // Vital Physical Stats (3 mini-cards)
                ScaleTransition(
                  scale: _vitalStatsAnimation,
                  child: _buildVitalStatsCards(profileState),
                ),
                const SizedBox(height: 24),

                // Vital Signs Card
                _buildVitalSignsCard(),
                const SizedBox(height: 32), // Reduced from 40

                // Medical Categories Grid
                SlideTransition(
                  position: _gridSlideAnimation,
                  child: FadeTransition(
                    opacity: _gridController,
                    child: _buildMedicalCategoriesSection(medicalRecordsAsync),
                  ),
                ),
                const SizedBox(height: 24), // Add bottom padding
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _refreshData() async {
    // print('Refreshing data...');

    // Refresh profile data
    final profileState = ref.read(profileControllerProvider);
    if (profileState.profile != null) {
      // print('Refreshing profile for user: ${profileState.profile!.id}');
      await ref.read(profileControllerProvider.notifier).loadProfile(profileState.profile!.id);
    } else {
      // print('No profile available to refresh');
    }

    // Refresh medical records
    // print('Refreshing medical records...');
    ref.invalidate(medicalRecordProvider);

    // Small delay for better UX
    await Future.delayed(const Duration(milliseconds: 500));
    // print('Data refresh completed');
  }

  Widget _buildHeader() {
    return Builder(
      builder: (context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // iOS-style status bar area (placeholder)
              const SizedBox(height: 8),
              // Title
              const Text(
                'Medical History',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          // Share/Export Icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE4E4E4)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: IconButton(
              onPressed: () {
                // TODO: Implement share/export functionality
                Share.share(
                  'Medical History Summary\n\nPatient: ${ref.read(profileControllerProvider).profile?.fullName ?? 'Unknown'}\nView complete medical history in DOPA app.',
                  subject: 'Medical History',
                );
              },
              icon: const Icon(
                Icons.share_rounded,
                color: Color(0xFF9A9A9A),
                size: 20,
              ),
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientIdentityCard(ProfileState profileState) {
    final profile = profileState.profile;

    // Calculate age from date of birth
    String ageText = 'Age not set';
    if (profile?.dateOfBirth != null) {
      final now = DateTime.now();
      final age = now.year - profile!.dateOfBirth!.year;
      if (now.month < profile.dateOfBirth!.month ||
          (now.month == profile.dateOfBirth!.month && now.day < profile.dateOfBirth!.day)) {
        ageText = '${age - 1} years';
      } else {
        ageText = '$age years';
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE4E4E4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Patient Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name
                Text(
                  profile?.fullName ?? 'Patient Name',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 8),
                // Age and Gender
                Row(
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          ageText,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF8A8A8A),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8), // Reduced from 12
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Gender not set',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF8A8A8A),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // QR Code Placeholder
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.qr_code_rounded,
              color: Color(0xFF9A9A9A),
              size: 40,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVitalStatsCards(ProfileState profileState) {
    final profile = profileState.profile;

    return Row(
      children: [
        // Weight Card
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE4E4E4)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  profile?.weight?.toString() ?? '--',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'KG',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF8A8A8A).withValues(alpha: 0.8),
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Weight',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF8A8A8A),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8), // Reduced from 12

        // Height Card
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE4E4E4)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  profile?.height?.toString() ?? '--',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'CM',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF8A8A8A).withValues(alpha: 0.8),
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Height',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF8A8A8A),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8), // Reduced from 12

        // Blood Type Card
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE4E4E4)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  profile?.bloodType ?? '--',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'TYPE',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF8A8A8A).withValues(alpha: 0.8),
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Blood',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF8A8A8A),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHealthSummaryDashboard(ProfileState profileState, AsyncValue<List<MedicalRecord>> medicalRecordsAsync) {
    final profile = profileState.profile;

    // Calculate BMI if weight and height are available
    String bmiText = '--';
    String bmiCategory = 'Not calculated';
    Color bmiColor = const Color(0xFF8A8A8A);

    if (profile?.weight != null && profile?.height != null) {
      final heightInMeters = profile!.height! / 100;
      final bmi = profile.weight! / (heightInMeters * heightInMeters);
      bmiText = bmi.toStringAsFixed(1);

      if (bmi < 18.5) {
        bmiCategory = 'Underweight';
        bmiColor = const Color(0xFFFFBE0B);
      } else if (bmi < 25) {
        bmiCategory = 'Normal';
        bmiColor = const Color(0xFF2ECC71);
      } else if (bmi < 30) {
        bmiCategory = 'Overweight';
        bmiColor = const Color(0xFFF39C12);
      } else {
        bmiCategory = 'Obese';
        bmiColor = const Color(0xFFE74C3C);
      }
    }

    // Calculate data completeness
    int completenessScore = 0;
    int totalFields = 6; // name, age, gender, weight, height, blood type

    if (profile?.fullName != null && profile!.fullName!.isNotEmpty) completenessScore++;
    if (profile?.dateOfBirth != null) completenessScore++;
    // Gender is not implemented yet, so skip
    if (profile?.weight != null) completenessScore++;
    if (profile?.height != null) completenessScore++;
    if (profile?.bloodType != null && profile!.bloodType!.isNotEmpty) completenessScore++;

    final completenessPercentage = (completenessScore / totalFields * 100).round();

    // Calculate health score based on available data
    int healthScore = 0;
    if (profile?.weight != null && profile?.height != null) {
      final heightInMeters = profile!.height! / 100;
      final bmi = profile.weight! / (heightInMeters * heightInMeters);
      if (bmi >= 18.5 && bmi < 25) healthScore += 30; // Normal BMI
      else if (bmi >= 25 && bmi < 30) healthScore += 20; // Overweight
      else if (bmi < 18.5) healthScore += 15; // Underweight
    }

    // Add points for medical records
    medicalRecordsAsync.whenData((records) {
      if (records.isNotEmpty) healthScore += 20; // Has medical records
      if (records.length >= 3) healthScore += 10; // Good medical history
    });

    // Add points for profile completeness
    healthScore += (completenessPercentage ~/ 10); // 0-10 points based on completeness

    healthScore = healthScore.clamp(0, 100);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE4E4E4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF8175D1).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.health_and_safety,
                  color: Color(0xFF8175D1),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Text(
                  'Health Summary',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                    letterSpacing: -0.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Health Metrics Row
          Row(
            children: [
              // BMI Card
              Expanded(
                child: ScaleTransition(
                  scale: _bmiCardAnimation,
                  child: FadeTransition(
                    opacity: _bmiCardAnimation,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE4E4E4)),
                      ),
                      child: Column(
                        children: [
                          Text(
                            bmiText,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'BMI',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF8A8A8A),
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: bmiColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              bmiCategory,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: bmiColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Health Score Card
              Expanded(
                child: ScaleTransition(
                  scale: _healthScoreCardAnimation,
                  child: FadeTransition(
                    opacity: _healthScoreCardAnimation,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE4E4E4)),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '$healthScore',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Health Score',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF8A8A8A),
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: healthScore >= 70
                                  ? const Color(0xFF2ECC71).withValues(alpha: 0.1)
                                  : healthScore >= 40
                                      ? const Color(0xFFF39C12).withValues(alpha: 0.1)
                                      : const Color(0xFFE74C3C).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              healthScore >= 70 ? 'Good' : healthScore >= 40 ? 'Fair' : 'Needs Attention',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: healthScore >= 70
                                    ? const Color(0xFF2ECC71)
                                    : healthScore >= 40
                                        ? const Color(0xFFF39C12)
                                        : const Color(0xFFE74C3C),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Profile Completeness Card
              Expanded(
                child: ScaleTransition(
                  scale: _completenessCardAnimation,
                  child: FadeTransition(
                    opacity: _completenessCardAnimation,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE4E4E4)),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '$completenessPercentage%',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Complete',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF8A8A8A),
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 4,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE4E4E4),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: completenessPercentage / 100,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF8175D1),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVitalSignsCard() {
    return Builder(
      builder: (context) => InkWell(
        onTap: () {
          context.push('/home/vital-signs');
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE4E4E4)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF8175D1).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.monitor_heart_rounded,
                  color: Color(0xFF8175D1),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Vital Signs',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Last updated: 2 hours ago',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF8A8A8A),
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow Icon
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Color(0xFF9A9A9A),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMedicalCategoriesSection(AsyncValue<List<MedicalRecord>> medicalRecordsAsync) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title (optional)
        const Padding(
          padding: EdgeInsets.only(bottom: 16), // Reduced from 24
          child: Text(
            'Medical Records',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
              letterSpacing: -0.3,
            ),
          ),
        ),

        // Medical Categories in a responsive grid
        medicalRecordsAsync.when(
          data: (medicalRecords) => _buildMedicalCategoriesGrid(medicalRecords),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Text('Error loading medical records: $error'),
          ),
        ),
      ],
    );
  }

  Widget _buildMedicalCategoriesGrid(List<MedicalRecord> medicalRecords) {
    // Create comprehensive medical category cards
    final categories = _createMedicalCategories(medicalRecords);

    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8, // Reduced from 12
        mainAxisSpacing: 8, // Reduced from 12
        childAspectRatio: 0.9, // Reduced from 1.0 to make items more compact
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return _buildDetailedCategoryCard(category);
      },
    );
  }

  List<MedicalCategoryData> _createMedicalCategories(List<MedicalRecord> records) {
    // Group records by category
    final groupedRecords = <MedicalRecordCategory, List<MedicalRecord>>{};
    for (final record in records) {
      groupedRecords.putIfAbsent(record.category, () => []).add(record);
    }

    return [
      MedicalCategoryData(
        title: 'Chronic Diseases',
        icon: Icons.local_hospital,
        color: const Color(0xFFFF6B6B),
        records: groupedRecords[MedicalRecordCategory.chronicDisease] ?? [],
        showAddButton: true,
        showArrow: true,
      ),
      MedicalCategoryData(
        title: 'Current Medications',
        icon: Icons.medication,
        color: const Color(0xFF4ECDC4),
        records: groupedRecords[MedicalRecordCategory.medication] ?? [],
        showAddButton: true,
        showArrow: true,
      ),
      MedicalCategoryData(
        title: 'Allergies',
        icon: Icons.warning,
        color: const Color(0xFFFFBE0B),
        records: groupedRecords[MedicalRecordCategory.allergy] ?? [],
        showAddButton: true,
        showArrow: false,
      ),
      MedicalCategoryData(
        title: 'Past Operations',
        icon: Icons.healing,
        color: const Color(0xFF9B59B6),
        records: groupedRecords[MedicalRecordCategory.surgery] ?? [],
        showAddButton: false,
        showArrow: true,
      ),
      MedicalCategoryData(
        title: 'Recent Illness',
        icon: Icons.sick,
        color: const Color(0xFFE74C3C),
        records: [], // TODO: Add illness records
        showAddButton: true,
        showArrow: false,
      ),
      MedicalCategoryData(
        title: 'Family Diseases',
        icon: Icons.family_restroom,
        color: const Color(0xFF3498DB),
        records: [], // TODO: Add family history records
        showAddButton: true,
        showArrow: false,
      ),
      MedicalCategoryData(
        title: 'Recent Travel',
        icon: Icons.flight,
        color: const Color(0xFF2ECC71),
        records: [], // TODO: Add travel records
        showAddButton: true,
        showArrow: false,
      ),
      MedicalCategoryData(
        title: 'Recent Vaccination',
        icon: Icons.vaccines,
        color: const Color(0xFF9B59B6),
        records: groupedRecords[MedicalRecordCategory.vaccination] ?? [],
        showAddButton: true,
        showArrow: true,
      ),
      MedicalCategoryData(
        title: 'Lifestyle Factors',
        icon: Icons.fitness_center,
        color: const Color(0xFFF39C12),
        records: [], // TODO: Add lifestyle records
        showAddButton: false,
        showArrow: true,
      ),
      MedicalCategoryData(
        title: 'Imaging',
        icon: Icons.image,
        color: const Color(0xFF8E44AD),
        records: [], // TODO: Add imaging records
        showAddButton: false,
        showArrow: true,
      ),
      MedicalCategoryData(
        title: 'Lab Records',
        icon: Icons.science,
        color: const Color(0xFFE67E22),
        records: groupedRecords[MedicalRecordCategory.labResult] ?? [],
        showAddButton: false,
        showArrow: true,
      ),
      MedicalCategoryData(
        title: 'Emergency Contact',
        icon: Icons.contact_emergency,
        color: const Color(0xFF16A085),
        records: [], // TODO: Add emergency contact
        showAddButton: true,
        showArrow: false,
      ),
    ];
  }

  Widget _buildDetailedCategoryCard(MedicalCategoryData category) {
    return Builder(
      builder: (context) => InkWell(
        onTap: category.showArrow ? () {
          _navigateToCategory(context, category);
        } : null,
        borderRadius: BorderRadius.circular(16), // Reduced from 20
        child: Container(
          padding: const EdgeInsets.all(12), // Reduced from 16
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16), // Reduced from 20
            border: Border.all(color: const Color(0xFFE4E4E4)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Icon and Action
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: category.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      category.icon,
                      color: category.color,
                      size: 16,
                    ),
                  ),
                  const Spacer(),
                  if (category.showAddButton)
                    InkWell(
                      onTap: () => _addToCategory(context, category),
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: const Color(0xFF8175D1).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Color(0xFF8175D1),
                          size: 12,
                        ),
                      ),
                    )
                  else if (category.showArrow)
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Color(0xFF9A9A9A),
                      size: 12,
                    ),
                ],
              ),
              const SizedBox(height: 8),

              // Title
              Text(
                category.title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                  letterSpacing: -0.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),

              // Content based on category
              SizedBox(
                height: 32,
                child: _buildCategoryContent(category),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryContent(MedicalCategoryData category) {
    if (category.records.isEmpty) {
      return Text(
        category.title == 'Allergies' ? 'None' : 'No records',
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w400,
          color: Color(0xFF8A8A8A),
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      );
    }

    // Show sample content based on category type
    switch (category.title) {
      case 'Current Medications':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: category.records.take(2).map((record) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(
                record.title,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF8A8A8A),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
        );
      case 'Recent Vaccination':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: category.records.take(2).map((record) {
            final dateStr = record.date != null
                ? '${record.date!.day}/${record.date!.month}/${record.date!.year}'
                : 'Date not set';
            return Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(
                '${record.title} - $dateStr',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF8A8A8A),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
        );
      default:
        return Text(
          '${category.records.length} record${category.records.length == 1 ? '' : 's'}',
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w400,
            color: Color(0xFF8A8A8A),
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        );
    }
  }

  void _navigateToCategory(BuildContext context, MedicalCategoryData category) {
    final routeName = _getCategoryRouteName(category.title);
    context.push('/home/medical-history/$routeName');
  }

  void _addToCategory(BuildContext context, MedicalCategoryData category) {
    switch (category.title) {
      case 'Current Medications':
        context.push('/home/medications/create');
        break;
      case 'Recent Vaccination':
        context.push('/home/vaccinations/create');
        break;
      case 'Emergency Contact':
        // TODO: Navigate to emergency contact form
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Add emergency contact - Coming soon!'),
            backgroundColor: Color(0xFF8175D1),
          ),
        );
        break;
      default:
        // Navigate to general medical record form
        context.push('/home/records/edit', extra: {
          'category': _getCategoryRouteName(category.title),
          'title': category.title,
        });
    }
  }

  String _getCategoryRouteName(String title) {
    return title.toLowerCase().replaceAll(' ', '-');
  }
}

class MedicalCategoryData {
  final String title;
  final IconData icon;
  final Color color;
  final List<MedicalRecord> records;
  final bool showAddButton;
  final bool showArrow;

  const MedicalCategoryData({
    required this.title,
    required this.icon,
    required this.color,
    required this.records,
    required this.showAddButton,
    required this.showArrow,
  });
}