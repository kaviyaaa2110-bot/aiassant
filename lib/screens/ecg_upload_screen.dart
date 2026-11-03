import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class EcgUploadScreen extends StatefulWidget {
  const EcgUploadScreen({super.key});

  @override
  State<EcgUploadScreen> createState() => _EcgUploadScreenState();
}

class _EcgUploadScreenState extends State<EcgUploadScreen>
    with SingleTickerProviderStateMixin {
  bool _isUploaded = false;
  bool _isAnalyzing = false;
  bool _analysisComplete = false;
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  void _simulateUpload() {
    setState(() => _isUploaded = true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white),
            SizedBox(width: 10),
            Text('ECG file uploaded successfully!'),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.success,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _simulateAnalysis() {
    setState(() => _isAnalyzing = true);
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
          _analysisComplete = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildUploadArea(),
                  const SizedBox(height: 24),
                  _buildEcgPreview(),
                  if (_isUploaded && !_analysisComplete) ...[
                    const SizedBox(height: 24),
                    _buildAnalyzeButton(),
                  ],
                  if (_isAnalyzing) ...[
                    const SizedBox(height: 24),
                    _buildAnalyzingCard(),
                  ],
                  if (_analysisComplete) ...[
                    const SizedBox(height: 24),
                    _buildAnalysisResults(),
                  ],
                  const SizedBox(height: 24),
                  _buildInfoSection(),
                ],
              ),
            ),
          ),
        ],
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
        gradient: LinearGradient(
          colors: [Color(0xFFC62828), Color(0xFFE53935), Color(0xFFEF5350)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x33C62828),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ECG Upload',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Upload your ECG for AI-powered analysis',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.monitor_heart_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadArea() {
    return GestureDetector(
      onTap: _isUploaded ? null : _simulateUpload,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
        decoration: BoxDecoration(
          color: _isUploaded
              ? AppColors.successLight
              : AppColors.primary.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _isUploaded
                ? AppColors.success.withValues(alpha: 0.3)
                : AppColors.primary.withValues(alpha: 0.2),
            width: 2,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _isUploaded
                    ? AppColors.success.withValues(alpha: 0.1)
                    : AppColors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isUploaded
                    ? Icons.check_circle_rounded
                    : Icons.cloud_upload_rounded,
                size: 44,
                color: _isUploaded ? AppColors.success : AppColors.primary,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              _isUploaded ? 'ECG File Uploaded' : 'Upload ECG File',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: _isUploaded ? AppColors.success : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _isUploaded
                  ? 'ecg_recording_oct2026.pdf'
                  : 'Tap to select ECG file\nSupported: PDF, PNG, JPG, DICOM',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: _isUploaded
                    ? AppColors.success.withValues(alpha: 0.8)
                    : AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            if (!_isUploaded) ...[
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildUploadOption(Icons.photo_library_rounded, 'Gallery'),
                  const SizedBox(width: 20),
                  _buildUploadOption(Icons.camera_alt_rounded, 'Camera'),
                  const SizedBox(width: 20),
                  _buildUploadOption(Icons.folder_rounded, 'Files'),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildUploadOption(IconData icon, String label) {
    return GestureDetector(
      onTap: _simulateUpload,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEcgPreview() {
    return Container(
      width: double.infinity,
      height: 180,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
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
                'ECG Preview',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE53935).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.favorite_rounded,
                      size: 14,
                      color: const Color(0xFFE53935),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Lead II',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFE53935),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: CustomPaint(
              size: Size.infinite,
              painter: _EcgWavePainter(_waveController),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyzeButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          colors: [Color(0xFFC62828), Color(0xFFE53935)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE53935).withValues(alpha: 0.35),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _simulateAnalysis,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          minimumSize: const Size(double.infinity, 56),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.auto_awesome_rounded, size: 20),
            SizedBox(width: 10),
            Text('Analyze with AI', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyzingCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Analyzing ECG...',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'AI is processing your ECG data.\nThis may take a moment.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisResults() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.success.withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
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
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.success,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Analysis Complete',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.success,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Normal Sinus Rhythm Detected',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildResultRow('Heart Rate', '72 bpm', AppColors.success),
          _buildResultRow('Rhythm', 'Regular', AppColors.success),
          _buildResultRow('PR Interval', '160 ms', AppColors.success),
          _buildResultRow('QRS Duration', '90 ms', AppColors.success),
          _buildResultRow('QT Interval', '380 ms', AppColors.success),
          _buildResultRow('ST Segment', 'Normal', AppColors.success),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primarySurface,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'This is an AI-assisted analysis. Please consult your doctor for medical advice.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.primary,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultRow(String label, String value, Color statusColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          Row(
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.check_circle_rounded,
                size: 16,
                color: statusColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'How it works',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoStep(1, 'Upload', 'Select your ECG file from your device',
              Icons.cloud_upload_rounded),
          _buildInfoStep(2, 'Analyze', 'AI processes and analyzes the ECG data',
              Icons.auto_awesome_rounded),
          _buildInfoStep(
              3,
              'Results',
              'Get detailed analysis and recommendations',
              Icons.analytics_rounded),
        ],
      ),
    );
  }

  Widget _buildInfoStep(
      int step, String title, String desc, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                '$step',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
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
                Text(
                  desc,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(icon, color: AppColors.primary, size: 22),
        ],
      ),
    );
  }
}

class _EcgWavePainter extends CustomPainter {
  final Animation<double> animation;

  _EcgWavePainter(this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE53935)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final gridPaint = Paint()
      ..color = const Color(0xFFE53935).withValues(alpha: 0.08)
      ..strokeWidth = 0.5;

    // Draw grid
    for (double x = 0; x < size.width; x += 20) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += 20) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final path = Path();
    final mid = size.height / 2;
    final offset = animation.value * 80;

    path.moveTo(0, mid);

    for (double x = 0; x < size.width; x += 1) {
      double adjustedX = x + offset;
      double segmentWidth = 80;
      double pos = (adjustedX % segmentWidth) / segmentWidth;
      double y;

      if (pos < 0.3) {
        y = mid;
      } else if (pos < 0.35) {
        y = mid - 8;
      } else if (pos < 0.40) {
        y = mid;
      } else if (pos < 0.45) {
        y = mid - size.height * 0.5;
      } else if (pos < 0.50) {
        y = mid + size.height * 0.15;
      } else if (pos < 0.55) {
        y = mid;
      } else if (pos < 0.65) {
        double t = (pos - 0.55) / 0.10;
        y = mid - 12 * (t < 0.5 ? 2 * t * t : 1 - (-2 * t + 2) * (-2 * t + 2) / 2);
      } else {
        y = mid;
      }

      path.lineTo(x, y);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
