import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../services/health_data_service.dart';
import '../widgets/futuristic_background.dart';
import '../widgets/glass_container.dart';
import '../widgets/futuristic_button.dart';
import '../widgets/futuristic_text_field.dart';

/// Modern premium dark navy & electric cyan Health Data Entry Screen
class HealthDataEntryScreen extends StatefulWidget {
  const HealthDataEntryScreen({super.key});

  @override
  State<HealthDataEntryScreen> createState() => _HealthDataEntryScreenState();
}

class _HealthDataEntryScreenState extends State<HealthDataEntryScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  // Input Controllers for required fields
  late final TextEditingController _ageController;
  late final TextEditingController _heightController;
  late final TextEditingController _weightController;
  late final TextEditingController _systolicController;
  late final TextEditingController _diastolicController;
  late final TextEditingController _heartRateController;
  late final TextEditingController _bloodSugarController;

  bool _isSaving = false;
  double? _calculatedBmi;
  String? _bmiCategory;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();

    // Pre-populate with previous record or sensible defaults for smooth experience
    final initial = HealthDataService.instance.latestRecord;
    _ageController = TextEditingController(text: initial.age.toString());
    _heightController = TextEditingController(text: initial.height.toStringAsFixed(0));
    _weightController = TextEditingController(text: initial.weight.toStringAsFixed(1));
    _systolicController = TextEditingController(text: initial.systolic.toString());
    _diastolicController = TextEditingController(text: initial.diastolic.toString());
    _heartRateController = TextEditingController(text: initial.heartRate.toString());
    _bloodSugarController = TextEditingController(
      text: initial.bloodSugar != null ? initial.bloodSugar!.toStringAsFixed(0) : '',
    );

    _calculateBmi();
    _heightController.addListener(_calculateBmi);
    _weightController.addListener(_calculateBmi);

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
    _animController.forward();
  }

  void _calculateBmi() {
    final h = double.tryParse(_heightController.text.trim());
    final w = double.tryParse(_weightController.text.trim());
    if (h != null && w != null && h > 40 && w > 10) {
      final hm = h / 100.0;
      final bmi = w / (hm * hm);
      setState(() {
        _calculatedBmi = bmi;
        if (bmi < 18.5) {
          _bmiCategory = 'Underweight';
        } else if (bmi < 25.0) {
          _bmiCategory = 'Normal';
        } else if (bmi < 30.0) {
          _bmiCategory = 'Overweight';
        } else {
          _bmiCategory = 'Obese';
        }
      });
    } else {
      if (_calculatedBmi != null) {
        setState(() {
          _calculatedBmi = null;
          _bmiCategory = null;
        });
      }
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _systolicController.dispose();
    _diastolicController.dispose();
    _heartRateController.dispose();
    _bloodSugarController.dispose();
    super.dispose();
  }

  void _handleSaveData() async {
    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.error_outline_rounded, color: Colors.white, size: 20),
              SizedBox(width: 10),
              Expanded(
                child: Text('Please correct the highlighted fields before saving.'),
              ),
            ],
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    // Simulate saving to local clinical ledger
    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;

    final age = int.parse(_ageController.text.trim());
    final height = double.parse(_heightController.text.trim());
    final weight = double.parse(_weightController.text.trim());
    final systolic = int.parse(_systolicController.text.trim());
    final diastolic = int.parse(_diastolicController.text.trim());
    final heartRate = int.parse(_heartRateController.text.trim());
    final sugarText = _bloodSugarController.text.trim();
    final double? bloodSugar = sugarText.isNotEmpty ? double.tryParse(sugarText) : null;

    final record = HealthRecord(
      age: age,
      height: height,
      weight: weight,
      systolic: systolic,
      diastolic: diastolic,
      heartRate: heartRate,
      bloodSugar: bloodSugar,
    );

    // Save in reactive service
    HealthDataService.instance.saveRecord(record);

    setState(() => _isSaving = false);

    // Display high-tech success confirmation dialog
    _showSaveSuccessDialog(record);
  }

  void _showSaveSuccessDialog(HealthRecord record) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: GlassContainer(
            borderRadius: 28,
            hasGlow: true,
            borderColor: AppColors.cyanNeon,
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Glowing Check Emblem
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.neonTeal.withValues(alpha: 0.15),
                    border: Border.all(color: AppColors.neonTeal, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.neonTeal.withValues(alpha: 0.4),
                        blurRadius: 18,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: AppColors.neonTeal,
                    size: 36,
                  ),
                ),
                const SizedBox(height: 16),

                const Text(
                  'HEALTH DATA SAVED',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Your daily biometric record has been saved and synchronized with your dashboard.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 18),

                // Recorded Summary Card
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.bgDarkest.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.cyanNeon.withValues(alpha: 0.25),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildSummaryRow('Age', '${record.age} years'),
                      const Divider(color: AppColors.divider, height: 16),
                      _buildSummaryRow(
                        'Height & Weight',
                        '${record.height.toStringAsFixed(0)} cm • ${record.weight.toStringAsFixed(1)} kg',
                      ),
                      const Divider(color: AppColors.divider, height: 16),
                      _buildSummaryRow(
                        'Blood Pressure',
                        '${record.systolic}/${record.diastolic} mmHg',
                        highlightColor: AppColors.cyanNeon,
                      ),
                      const Divider(color: AppColors.divider, height: 16),
                      _buildSummaryRow(
                        'Heart Rate',
                        '${record.heartRate} BPM',
                        highlightColor: AppColors.neonPink,
                      ),
                      const Divider(color: AppColors.divider, height: 16),
                      _buildSummaryRow(
                        'Blood Sugar',
                        record.bloodSugar != null
                            ? '${record.bloodSugar!.toStringAsFixed(0)} mg/dL'
                            : 'Not recorded',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 22),

                // Return to Dashboard Button
                FuturisticButton(
                  text: 'RETURN TO DASHBOARD',
                  trailingIcon: Icons.arrow_back_rounded,
                  onPressed: () {
                    Navigator.pop(ctx); // Close dialog
                    _navigateBackToDashboard();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryRow(String label, String value, {Color? highlightColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: highlightColor ?? AppColors.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  void _navigateBackToDashboard() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final todayDate = DateFormat('EEE, MMM d, yyyy').format(DateTime.now());

    return Scaffold(
      body: FuturisticBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Futuristic Top Navigation Header
              _buildTopHeader(todayDate),

              // Scrollable Form Body
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    position: _slideAnim,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 1. Patient Demographics & Body Metrics Card
                            _buildDemographicsCard(),

                            const SizedBox(height: 20),

                            // 2. Cardiovascular Vitals Card (BP & Heart Rate)
                            _buildCardiovascularCard(),

                            const SizedBox(height: 20),

                            // 3. Metabolic Biometrics Card (Blood Sugar - Optional)
                            _buildMetabolicCard(),

                            const SizedBox(height: 28),

                            // Save Health Data Button
                            FuturisticButton(
                              text: 'SAVE HEALTH DATA',
                              isLoading: _isSaving,
                              leadingIcon: Icons.save_rounded,
                              onPressed: _handleSaveData,
                            ),

                            const SizedBox(height: 14),

                            // Back to Dashboard Ghost Button
                            Center(
                              child: TextButton.icon(
                                onPressed: _navigateBackToDashboard,
                                icon: const Icon(
                                  Icons.chevron_left_rounded,
                                  color: AppColors.textSecondary,
                                  size: 18,
                                ),
                                label: const Text(
                                  'Discard & Back to Dashboard',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopHeader(String dateString) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.bgDarkest.withValues(alpha: 0.8),
        border: Border(
          bottom: Border.all(
            color: AppColors.cyanNeon.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Back Navigation Button
          GestureDetector(
            onTap: _navigateBackToDashboard,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.bgElevated.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.cyanNeon.withValues(alpha: 0.35),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.cyanNeon.withValues(alpha: 0.1),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 16,
                color: AppColors.cyanNeon,
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Header Title & Telemetry Status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.neonTeal,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.neonTeal,
                            blurRadius: 6,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'BIOMETRIC DATA LOGGING',
                      style: TextStyle(
                        color: AppColors.cyanNeon,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.4,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                const Text(
                  'Log Health Data',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),

          // Current Date Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.bgElevated.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.cyanNeon.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.calendar_today_rounded,
                  size: 12,
                  color: AppColors.cyanNeon,
                ),
                const SizedBox(width: 6),
                Text(
                  dateString,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 1. Patient Demographics & Body Metrics Card
  Widget _buildDemographicsCard() {
    return GlassContainer(
      hasGlow: true,
      borderRadius: 22,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(
            icon: Icons.person_outline_rounded,
            title: 'PATIENT DEMOGRAPHICS & BODY METRICS',
            subtitle: 'Age, Height, and Weight metrics',
            color: AppColors.cyanNeon,
          ),
          const SizedBox(height: 18),

          // 1. Age Input Field
          FuturisticTextField(
            controller: _ageController,
            label: '1. Patient Age (Years)',
            hintText: 'e.g., 28',
            prefixIcon: Icons.cake_outlined,
            keyboardType: TextInputType.number,
            suffix: const Padding(
              padding: EdgeInsets.only(right: 14),
              child: Text(
                'years',
                style: TextStyle(color: AppColors.textMuted, fontSize: 13),
              ),
            ),
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return 'Age is required';
              }
              final n = int.tryParse(val.trim());
              if (n == null || n < 1 || n > 125) {
                return 'Enter a valid age between 1 and 125';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // 2. Height (cm) & 3. Weight (kg) Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 2. Height Input
              Expanded(
                child: FuturisticTextField(
                  controller: _heightController,
                  label: '2. Height',
                  hintText: 'e.g., 175',
                  prefixIcon: Icons.height_rounded,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  suffix: const Padding(
                    padding: EdgeInsets.only(right: 14),
                    child: Text(
                      'cm',
                      style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Height required';
                    }
                    final n = double.tryParse(val.trim());
                    if (n == null || n < 50 || n > 260) {
                      return 'Between 50-260 cm';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 14),

              // 3. Weight Input
              Expanded(
                child: FuturisticTextField(
                  controller: _weightController,
                  label: '3. Weight',
                  hintText: 'e.g., 68.5',
                  prefixIcon: Icons.monitor_weight_outlined,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  suffix: const Padding(
                    padding: EdgeInsets.only(right: 14),
                    child: Text(
                      'kg',
                      style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Weight required';
                    }
                    final n = double.tryParse(val.trim());
                    if (n == null || n < 20 || n > 350) {
                      return 'Between 20-350 kg';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),

          // Dynamic BMI Display Chip
          if (_calculatedBmi != null) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.bgDarkest.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.cyanNeon.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.calculate_outlined,
                    size: 16,
                    color: AppColors.cyanNeon,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'CALCULATED BMI: ${_calculatedBmi!.toStringAsFixed(1)} kg/m²',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: _getBmiColor(_bmiCategory).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: _getBmiColor(_bmiCategory),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      _bmiCategory?.toUpperCase() ?? '',
                      style: TextStyle(
                        color: _getBmiColor(_bmiCategory),
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getBmiColor(String? cat) {
    switch (cat) {
      case 'Normal':
        return AppColors.neonTeal;
      case 'Underweight':
        return AppColors.warning;
      case 'Overweight':
        return const Color(0xFFFF9100);
      case 'Obese':
        return AppColors.error;
      default:
        return AppColors.cyanNeon;
    }
  }

  /// 2. Cardiovascular Vitals Card (Blood Pressure & Heart Rate)
  Widget _buildCardiovascularCard() {
    return GlassContainer(
      hasGlow: true,
      borderRadius: 22,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(
            icon: Icons.monitor_heart_rounded,
            title: 'CARDIOVASCULAR VITALS',
            subtitle: 'Blood Pressure and Pulse telemetry',
            color: AppColors.neonPink,
          ),
          const SizedBox(height: 18),

          // 4. Blood Pressure: Systolic & Diastolic
          const Text(
            '4. BLOOD PRESSURE (SYSTOLIC & DIASTOLIC)',
            style: TextStyle(
              color: AppColors.cyanNeon,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 8),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Systolic (mmHg)
              Expanded(
                child: FuturisticTextField(
                  controller: _systolicController,
                  label: 'Systolic (Upper)',
                  hintText: 'e.g., 120',
                  prefixIcon: Icons.speed_rounded,
                  keyboardType: TextInputType.number,
                  suffix: const Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: Text(
                      'mmHg',
                      style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Systolic is required';
                    }
                    final n = int.tryParse(val.trim());
                    if (n == null || n < 60 || n > 260) {
                      return 'Range: 60-260';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 14),

              // Diastolic (mmHg)
              Expanded(
                child: FuturisticTextField(
                  controller: _diastolicController,
                  label: 'Diastolic (Lower)',
                  hintText: 'e.g., 80',
                  prefixIcon: Icons.speed_rounded,
                  keyboardType: TextInputType.number,
                  suffix: const Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: Text(
                      'mmHg',
                      style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Diastolic is required';
                    }
                    final d = int.tryParse(val.trim());
                    if (d == null || d < 40 || d > 160) {
                      return 'Range: 40-160';
                    }
                    final s = int.tryParse(_systolicController.text.trim());
                    if (s != null && d >= s) {
                      return 'Must be < Systolic';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 5. Heart Rate (BPM)
          FuturisticTextField(
            controller: _heartRateController,
            label: '5. Heart Rate (BPM)',
            hintText: 'e.g., 72',
            prefixIcon: Icons.favorite_rounded,
            keyboardType: TextInputType.number,
            suffix: const Padding(
              padding: EdgeInsets.only(right: 14),
              child: Text(
                'BPM',
                style: TextStyle(color: AppColors.textMuted, fontSize: 13),
              ),
            ),
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return 'Heart Rate is required';
              }
              final n = int.tryParse(val.trim());
              if (n == null || n < 30 || n > 240) {
                return 'Enter a valid heart rate between 30 and 240 BPM';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  /// 3. Metabolic Biometrics Card (Blood Sugar - Optional)
  Widget _buildMetabolicCard() {
    return GlassContainer(
      hasGlow: true,
      borderRadius: 22,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(
            icon: Icons.water_drop_outlined,
            title: 'METABOLIC BIOMETRICS',
            subtitle: 'Glucose level telemetry (optional)',
            color: AppColors.warning,
          ),
          const SizedBox(height: 18),

          // 6. Blood Sugar (mg/dL) - Optional
          FuturisticTextField(
            controller: _bloodSugarController,
            label: '6. Blood Sugar (Optional)',
            hintText: 'e.g., 95 (Fasting / Random)',
            prefixIcon: Icons.water_drop_rounded,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            suffix: const Padding(
              padding: EdgeInsets.only(right: 14),
              child: Text(
                'mg/dL',
                style: TextStyle(color: AppColors.textMuted, fontSize: 13),
              ),
            ),
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return null; // Optional field
              }
              final n = double.tryParse(val.trim());
              if (n == null || n < 30 || n > 600) {
                return 'Enter a valid glucose level between 30 and 600 mg/dL';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),

          Row(
            children: const [
              Icon(
                Icons.info_outline_rounded,
                size: 13,
                color: AppColors.textMuted,
              ),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Leave blank if blood sugar was not tested in this session.',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: color.withValues(alpha: 0.35),
              width: 1,
            ),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
