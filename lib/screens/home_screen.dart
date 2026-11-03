import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/health_data_service.dart';
import '../widgets/health_metric_card.dart';
import '../widgets/action_card.dart';
import 'health_data_entry_screen.dart';
import 'ecg_upload_screen.dart';
import 'health_report_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animController.forward();
    HealthDataService.instance.addListener(_onHealthDataChanged);
  }

  void _onHealthDataChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    HealthDataService.instance.removeListener(_onHealthDataChanged);
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 24),
            _buildGreeting(context),
            const SizedBox(height: 20),
            _buildHealthOverview(context),
            const SizedBox(height: 28),
            _buildVitalsGrid(context),
            const SizedBox(height: 28),
            _buildQuickActions(context),
            const SizedBox(height: 28),
            _buildUpcomingReminders(context),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 24,
        right: 24,
        bottom: 24,
      ),
      decoration: const BoxDecoration(
        gradient: AppColors.headerGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x331565C0),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white54, width: 2),
                    ),
                    child: CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      child: const Icon(
                        Icons.person_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good Morning',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Sarah Johnson',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  _buildHeaderIcon(Icons.notifications_none_rounded, badge: 3),
                  const SizedBox(width: 8),
                  _buildHeaderIcon(Icons.search_rounded),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.favorite_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Overall Health Score',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Text(
                            '87',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              height: 1,
                            ),
                          ),
                          const Text(
                            '/100',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4CAF50).withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.trending_up_rounded,
                                  color: Colors.white,
                                  size: 14,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  '+3%',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
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
        ],
      ),
    );
  }

  Widget _buildHeaderIcon(IconData icon, {int badge = 0}) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
        if (badge > 0)
          Positioned(
            right: 4,
            top: 4,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$badge',
                style: const TextStyle(
                  fontSize: 9,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildGreeting(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Health Dashboard',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          TextButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const HealthReportScreen(),
                ),
              );
            },
            icon: const Icon(Icons.analytics_outlined, size: 18),
            label: const Text('Reports'),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthOverview(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Today\'s Summary',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.successLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.check_circle_rounded,
                          size: 14, color: AppColors.success),
                      SizedBox(width: 4),
                      Text(
                        'All Good',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem(Icons.directions_walk_rounded, '8,247',
                    'Steps', AppColors.primary),
                _buildSummaryDivider(),
                _buildSummaryItem(Icons.local_fire_department_rounded, '1,842',
                    'Calories', AppColors.warning),
                _buildSummaryDivider(),
                _buildSummaryItem(Icons.bedtime_rounded, '7.5h', 'Sleep',
                    AppColors.accent),
                _buildSummaryDivider(),
                _buildSummaryItem(Icons.water_drop_rounded, '6', 'Glasses',
                    const Color(0xFF5C6BC0)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(
      IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.textHint),
        ),
      ],
    );
  }

  Widget _buildSummaryDivider() {
    return Container(
      height: 40,
      width: 1,
      color: AppColors.divider,
    );
  }

  Widget _buildVitalsGrid(BuildContext context) {
    final latest = HealthDataService.instance.latestRecord;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Vital Signs',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const HealthDataEntryScreen(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.cyanNeon.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.cyanNeon.withValues(alpha: 0.35),
                      width: 1,
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.add_rounded,
                        size: 14,
                        color: AppColors.cyanNeon,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Log Data',
                        style: TextStyle(
                          color: AppColors.cyanNeon,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 1.05,
            children: [
              HealthMetricCard(
                icon: Icons.favorite_rounded,
                label: 'Heart Rate',
                value: latest.heartRate.toString(),
                unit: 'bpm',
                color: const Color(0xFFE53935),
                status: latest.heartRate < 60
                    ? 'Low'
                    : latest.heartRate <= 100
                        ? 'Normal'
                        : 'Elevated',
              ),
              HealthMetricCard(
                icon: Icons.bloodtype_rounded,
                label: 'Blood Pressure',
                value: latest.bloodPressureString,
                unit: 'mmHg',
                color: const Color(0xFF7B1FA2),
                status: latest.systolic < 120 && latest.diastolic < 80
                    ? 'Optimal'
                    : latest.systolic <= 129 && latest.diastolic < 80
                        ? 'Elevated'
                        : 'High',
              ),
              const HealthMetricCard(
                icon: Icons.thermostat_rounded,
                label: 'Temperature',
                value: '98.6',
                unit: '°F',
                color: Color(0xFFFF6F00),
                status: 'Normal',
              ),
              const HealthMetricCard(
                icon: Icons.air_rounded,
                label: 'SpO2',
                value: '98',
                unit: '%',
                color: Color(0xFF0097A7),
                status: 'Normal',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 14),
          ActionCard(
            icon: Icons.edit_note_rounded,
            title: 'Log Health Data',
            subtitle: 'Record your daily vitals and symptoms',
            color: AppColors.primary,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const HealthDataEntryScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          ActionCard(
            icon: Icons.monitor_heart_rounded,
            title: 'Upload ECG',
            subtitle: 'Upload your ECG for AI analysis',
            color: const Color(0xFFE53935),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const EcgUploadScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          ActionCard(
            icon: Icons.assessment_rounded,
            title: 'View Reports',
            subtitle: 'Check your health trends and analytics',
            color: AppColors.accent,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const HealthReportScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingReminders(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Upcoming Reminders',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('See All'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildReminderTile(
            Icons.medication_rounded,
            'Take Medication',
            'Aspirin 75mg - 2:00 PM',
            AppColors.primary,
            '30 min',
          ),
          const SizedBox(height: 10),
          _buildReminderTile(
            Icons.local_hospital_rounded,
            'Doctor Appointment',
            'Dr. Smith - Cardiology',
            AppColors.accent,
            'Tomorrow',
          ),
          const SizedBox(height: 10),
          _buildReminderTile(
            Icons.science_rounded,
            'Blood Test',
            'Annual health checkup lab work',
            const Color(0xFF7B1FA2),
            'Nov 3',
          ),
        ],
      ),
    );
  }

  Widget _buildReminderTile(
    IconData icon,
    String title,
    String subtitle,
    Color color,
    String time,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              time,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
