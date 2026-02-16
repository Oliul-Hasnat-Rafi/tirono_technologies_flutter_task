import 'package:flutter/material.dart';
import 'package:tirono_technologies_flutter_task/src/core/utils/dev_functions/dev_scaffold.dart';

class PatientScreen extends StatelessWidget {
  const PatientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DevScaffold(
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(colorScheme),
                  const SizedBox(height: 20),
                  _buildConnectionStatus(colorScheme),
                  const SizedBox(height: 20),
                  _buildCriticalAlert(colorScheme),
                  const SizedBox(height: 30),
                  _buildLiveVitalSignsHeader(colorScheme),
                  const SizedBox(height: 16),
                  _buildECGCard(colorScheme),
                  const SizedBox(height: 16),
                  _buildTemperatureCard(colorScheme),
                  const SizedBox(height: 16),
                  _buildBloodPressureCard(colorScheme),
                  const SizedBox(height: 16),
                  _buildRespiratoryRateCard(colorScheme),
                  const SizedBox(height: 16),
                  _buildOxygenSaturationCard(colorScheme),
                  const SizedBox(height: 30),
                  _buildQuickActionsHeader(colorScheme),
                  const SizedBox(height: 16),
                  _buildQuickActionsGrid(colorScheme),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: colorScheme.onPrimary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.person,
              color: colorScheme.surfaceContainer,
              size: 30,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome, Jonn',
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Patient ID: #MED-2024-1234',
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.logout, color: colorScheme.onSurfaceVariant, size: 24),
        ],
      ),
    );
  }

  Widget _buildConnectionStatus(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: colorScheme.outline.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.4),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: colorScheme.outline.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.watch, color: colorScheme.outline, size: 16),
          ),
          const SizedBox(width: 10),
          Text(
            'INTEAM Watch Connected',
            style: TextStyle(
              color: colorScheme.outline,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCriticalAlert(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.error.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.error.withOpacity(0.4),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.error.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline,
                  color: colorScheme.error,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Critical Alert',
                style: TextStyle(
                  color: colorScheme.error,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Blood Pressure is critically high. Your doctor has been notified via email.',
            style: TextStyle(
              color: colorScheme.onSurface.withOpacity(0.7),
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.error,
                foregroundColor: colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              child: const Text(
                'View Details',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveVitalSignsHeader(ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Live Vital Signs',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Icon(Icons.show_chart, color: colorScheme.secondary, size: 28),
      ],
    );
  }

  Widget _buildECGCard(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ELECTROCARDIOGRAM',
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.outline.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: colorScheme.outline,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'LIVE',
                      style: TextStyle(
                        color: colorScheme.outline,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: CustomPaint(
              painter: ECGPainter(color: colorScheme.outline),
              child: Container(),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '72',
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  'bpm',
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                'Sinus Rhythm',
                style: TextStyle(
                  color: colorScheme.outline,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.onSurfaceVariant.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Normal',
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVitalCard({
    required ColorScheme colorScheme,
    required String title,
    required String normalRange,
    required String value,
    required String unit,
    required IconData icon,
    required Color iconColor,
    required bool isCritical,
  }) {
    final statusColor = isCritical ? colorScheme.error : colorScheme.outline;
    final statusText = isCritical ? 'CRITICAL' : 'NORMAL';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  normalRange,
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant.withOpacity(0.5),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      value,
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        height: 1,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        unit,
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              statusText,
              style: TextStyle(
                color: statusColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemperatureCard(ColorScheme colorScheme) {
    return _buildVitalCard(
      colorScheme: colorScheme,
      title: 'Temperature',
      normalRange: 'Normal: 97-99°F',
      value: '98.6',
      unit: '°F',
      icon: Icons.thermostat,
      iconColor: colorScheme.error,
      isCritical: false,
    );
  }

  Widget _buildBloodPressureCard(ColorScheme colorScheme) {
    return _buildVitalCard(
      colorScheme: colorScheme,
      title: 'Blood Pressure',
      normalRange: 'Normal: 120/80',
      value: '165/95',
      unit: 'mmHg',
      icon: Icons.favorite,
      iconColor: colorScheme.scrim,
      isCritical: true,
    );
  }

  Widget _buildRespiratoryRateCard(ColorScheme colorScheme) {
    return _buildVitalCard(
      colorScheme: colorScheme,
      title: 'Respiratory Rate',
      normalRange: 'Normal: 12-20',
      value: '16',
      unit: '/min',
      icon: Icons.air,
      iconColor: colorScheme.onErrorContainer,
      isCritical: false,
    );
  }

  Widget _buildOxygenSaturationCard(ColorScheme colorScheme) {
    return _buildVitalCard(
      colorScheme: colorScheme,
      title: 'Oxygen Saturation',
      normalRange: 'Normal: 95-100%',
      value: '98',
      unit: '%',
      icon: Icons.water_drop,
      iconColor: colorScheme.secondary,
      isCritical: false,
    );
  }

  Widget _buildQuickActionsHeader(ColorScheme colorScheme) {
    return Text(
      'Quick Actions',
      style: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildQuickActionsGrid(ColorScheme colorScheme) {
    const double cardHeight = 140;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                'Find Doctors',
                'Video consult',
                colorScheme.tertiary,
                Icons.videocam,
                height: cardHeight,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickActionCard(
                'ClinGPT AI',
                'Ask symptoms',
                colorScheme.onTertiary,
                Icons.medical_services,
                height: cardHeight,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                'Appointments',
                'Schedule visit',
                colorScheme.secondary,
                Icons.calendar_today,
                height: cardHeight,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickActionCard(
                'Reports',
                'View history',
                colorScheme.outlineVariant,
                Icons.description,
                height: cardHeight,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildQuickActionCard(
          'Billing',
          'Pay bills',
          colorScheme.onError,
          Icons.credit_card,
          height: cardHeight,
          isWide: true,
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(
    String title,
    String subtitle,
    Color color,
    IconData icon, {
    bool isWide = false,
    double height = 140,
  }) {
    return Container(
      height: height,
      width: isWide ? double.infinity : null,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 26),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class ECGPainter extends CustomPainter {
  final Color color;

  ECGPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final path = Path();
    final width = size.width;
    final height = size.height;
    final centerY = height / 2;

    path.moveTo(0, centerY);

    double x = 0;
    while (x < width) {
      // P wave
      path.lineTo(x + 10, centerY - 8);
      path.lineTo(x + 20, centerY);
      x += 20;

      // QRS complex
      path.lineTo(x + 10, centerY);
      path.lineTo(x + 15, centerY + 15);
      path.lineTo(x + 20, centerY - 40);
      path.lineTo(x + 25, centerY + 10);
      path.lineTo(x + 30, centerY);
      x += 30;

      // T wave
      path.lineTo(x + 15, centerY - 12);
      path.lineTo(x + 30, centerY);
      x += 30;

      // Baseline
      path.lineTo(x + 20, centerY);
      x += 20;
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
