import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tirono_technologies_flutter_task/src/core/routing/routes.dart';
import 'package:tirono_technologies_flutter_task/src/core/utils/dev_functions/dev_scaffold.dart';

import '../../../../core/routing/app_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return DevScaffold(
      child: Scaffold(
        backgroundColor: cs.surface,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Column(
              children: [
                _HeaderSection(cs: cs),
                SizedBox(height: 24.h),
                _LiveVitalsSection(cs: cs),
                SizedBox(height: 24.h),
                _PatientPortalButton(cs: cs),
                SizedBox(height: 24.h),
                _ProviderPortalSection(cs: cs),
                SizedBox(height: 24.h),
                _RepositorySection(cs: cs),
                SizedBox(height: 24.h),
                _DashboardButton(cs: cs),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection({required this.cs});
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [cs.primaryContainer, cs.onPrimaryContainer],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: cs.tertiaryContainer),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 50.w,
                height: 50.w,
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: cs.onErrorContainer, width: 1.5),
                ),
                child: Center(
                  child: Text(
                    'EHR',
                    style: TextStyle(
                      color: cs.onErrorContainer,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(
                width: 70.w,
                height: 70.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: cs.onPrimary,
                  boxShadow: [
                    BoxShadow(
                      color: cs.errorContainer.withOpacity(0.3),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.medical_services,
                    color: cs.error,
                    size: 32.sp,
                  ),
                ),
              ),
              Container(
                width: 50.w,
                height: 50.w,
                decoration: BoxDecoration(
                  color: cs.shadow,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.person_outline,
                  color: cs.onSurfaceVariant,
                  size: 28.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          RichText(
            text: TextSpan(
              text: 'Powered by ',
              style: TextStyle(color: cs.onSurfaceVariant, fontSize: 13.sp),
              children: [
                TextSpan(
                  text: 'InTEAM Technologies',
                  style: TextStyle(
                    color: cs.onSurface,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LiveVitalsSection extends StatelessWidget {
  const _LiveVitalsSection({required this.cs});
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: cs.secondaryContainer,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: cs.tertiaryContainer),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.monitor_heart_outlined,
                color: cs.onSurfaceVariant,
                size: 22.sp,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'Live Vitals from Wearable Devices',
                  style: TextStyle(
                    color: cs.onSurface,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _VitalCard(
                  cs: cs,
                  icon: Icons.favorite,
                  accentColor: cs.error,
                  label: 'Pulse',
                  value: '72',
                  unit: 'bpm',
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _VitalCard(
                  cs: cs,
                  icon: Icons.speed,
                  accentColor: cs.errorContainer,
                  label: 'BP',
                  value: '120/80',
                  unit: 'mmHg',
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _VitalCard(
                  cs: cs,
                  icon: Icons.thermostat,
                  accentColor: cs.onError,
                  label: 'Temp',
                  value: '98.6',
                  unit: '°F',
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _VitalCard(
                  cs: cs,
                  icon: Icons.air,
                  accentColor: cs.outline,
                  label: 'SpO2',
                  value: '98',
                  unit: '%',
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          _ECGSection(cs: cs),
          SizedBox(height: 12.h),
          Row(
            children: [
              Icon(Icons.bluetooth, color: cs.tertiaryFixed, size: 16.sp),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  'Data streamed from connected wearable devices',
                  style: TextStyle(color: cs.tertiaryFixedDim, fontSize: 11.sp),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _VitalCard extends StatelessWidget {
  final ColorScheme cs;
  final IconData icon;
  final Color accentColor;
  final String label;
  final String value;
  final String unit;

  const _VitalCard({
    required this.cs,
    required this.icon,
    required this.accentColor,
    required this.label,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: cs.onSecondaryContainer,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: cs.onTertiaryContainer),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: accentColor, size: 16.sp),
              SizedBox(width: 6.w),
              Text(
                label,
                style: TextStyle(
                  color: accentColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              color: accentColor,
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            unit,
            style: TextStyle(
              color: accentColor.withOpacity(0.7),
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class _ECGSection extends StatelessWidget {
  const _ECGSection({required this.cs});
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: cs.onSecondaryContainer,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: cs.onTertiaryContainer),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Electrocardiogram (ECG)',
            style: TextStyle(
              color: cs.onSurfaceVariant,
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            height: 80.h,
            width: double.infinity,
            child: CustomPaint(painter: _ECGPainter(color: cs.outlineVariant)),
          ),
          SizedBox(height: 8.h),
          Center(
            child: Text(
              'Normal Sinus Rhythm',
              style: TextStyle(
                color: cs.outlineVariant,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ECGPainter extends CustomPainter {
  final Color color;
  const _ECGPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final midY = size.height / 2;
    final segmentWidth = size.width / 6;

    path.moveTo(0, midY);

    for (int i = 0; i < 6; i++) {
      final startX = i * segmentWidth;
      path.lineTo(startX + segmentWidth * 0.2, midY);
      path.quadraticBezierTo(
        startX + segmentWidth * 0.28,
        midY - 8,
        startX + segmentWidth * 0.35,
        midY,
      );
      path.lineTo(startX + segmentWidth * 0.4, midY);
      path.lineTo(startX + segmentWidth * 0.43, midY + 6);
      path.lineTo(startX + segmentWidth * 0.48, midY - size.height * 0.55);
      path.lineTo(startX + segmentWidth * 0.53, midY + 10);
      path.lineTo(startX + segmentWidth * 0.56, midY);
      path.lineTo(startX + segmentWidth * 0.62, midY);
      path.quadraticBezierTo(
        startX + segmentWidth * 0.72,
        midY - 12,
        startX + segmentWidth * 0.82,
        midY,
      );
      path.lineTo(startX + segmentWidth, midY);
    }

    canvas.drawPath(path, paint);

    final glowPaint = Paint()
      ..color = color.withOpacity(0.15)
      ..strokeWidth = 6.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    canvas.drawPath(path, glowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PatientPortalButton extends StatelessWidget {
  const _PatientPortalButton({required this.cs});
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 22.h, horizontal: 20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [cs.secondary, cs.onSecondary],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: cs.secondary.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Patient Portal',
            style: TextStyle(
              color: cs.onSurface,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Access your health records, vitals, and appointments',
            textAlign: TextAlign.center,
            style: TextStyle(color: cs.onSurfaceVariant, fontSize: 13.sp),
          ),
        ],
      ),
    );
  }
}

class _ProviderPortalSection extends StatelessWidget {
  const _ProviderPortalSection({required this.cs});
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: cs.secondaryContainer,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: cs.tertiaryContainer),
      ),
      child: Column(
        children: [
          Text(
            'Provider Portal: EMR',
            style: TextStyle(
              color: cs.onSurface,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _PortalCard(
                  cs: cs,
                  icon: Icons.assignment,
                  iconColor: cs.outline,
                  bgColor: cs.inverseSurface,
                  borderColor: cs.inversePrimary,
                  title: 'Doctor',
                  subtitle: 'Full EMR Access',
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _PortalCard(
                  cs: cs,
                  icon: Icons.assignment_ind,
                  iconColor: cs.scrim,
                  bgColor: cs.primaryFixed,
                  borderColor: cs.onPrimaryFixed,
                  title: 'Nurse',
                  subtitle: 'Patient Care\nAccess',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RepositorySection extends StatelessWidget {
  const _RepositorySection({required this.cs});
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: cs.secondaryContainer,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: cs.tertiaryContainer),
      ),
      child: Column(
        children: [
          Text(
            'Repository',
            style: TextStyle(
              color: cs.onSurface,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    context.pushToMember();
                  },
                  child: _PortalCard(
                    cs: cs,
                    icon: Icons.folder_open,
                    iconColor: cs.secondaryFixedDim,
                    bgColor: cs.primaryFixedDim,
                    borderColor: cs.onPrimaryFixedVariant,
                    title: 'Internal',
                    subtitle: 'EMR System\nRecords',
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _PortalCard(
                  cs: cs,
                  icon: Icons.public,
                  iconColor: cs.onSecondaryFixedVariant,
                  bgColor: cs.secondaryFixed,
                  borderColor: cs.onSecondaryFixed,
                  title: 'External',
                  subtitle: 'External Systems',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PortalCard extends StatelessWidget {
  final ColorScheme cs;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final Color borderColor;
  final String title;
  final String subtitle;

  const _PortalCard({
    required this.cs,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.borderColor,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: borderColor.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Container(
            width: 56.w,
            height: 56.w,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: borderColor.withOpacity(0.4)),
            ),
            child: Icon(icon, color: iconColor, size: 28.sp),
          ),
          SizedBox(height: 10.h),
          Text(
            title,
            style: TextStyle(
              color: cs.onSurface,
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(color: cs.onSurfaceVariant, fontSize: 11.sp),
          ),
        ],
      ),
    );
  }
}

class _DashboardButton extends StatelessWidget {
  const _DashboardButton({required this.cs});
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 22.h, horizontal: 20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [cs.tertiary, cs.onTertiary],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: cs.tertiary.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Dashboard',
            style: TextStyle(
              color: cs.onSurface,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'View all patient records with sidebar navigation',
            textAlign: TextAlign.center,
            style: TextStyle(color: cs.onSurfaceVariant, fontSize: 13.sp),
          ),
        ],
      ),
    );
  }
}
