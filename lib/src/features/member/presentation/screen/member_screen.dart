import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tirono_technologies_flutter_task/src/core/utils/dev_functions/dev_scaffold.dart';

import '../../data/model/patient_record.dart';
import '../provider/member_provider.dart';

class MemberScreen extends ConsumerStatefulWidget {
  const MemberScreen({super.key});

  @override
  ConsumerState<MemberScreen> createState() => _MemberScreenState();
}

class _MemberScreenState extends ConsumerState<MemberScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _headerAnimController;
  late Animation<double> _headerFade;

  @override
  void initState() {
    super.initState();

    _headerAnimController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _headerFade = CurvedAnimation(
      parent: _headerAnimController,
      curve: Curves.easeOut,
    );
    _headerAnimController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _headerAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final locationAsync = ref.watch(userLocationProvider);
    final addressAsync = ref.watch(userAddressProvider);
    final memberState = ref.watch(memberNotifierProvider);
    final memberNotifier = ref.read(memberNotifierProvider.notifier);

    return DevScaffold(
      child: Scaffold(
        backgroundColor: cs.surface,
        body: SafeArea(
          child: Column(
            children: [

              _TopBar(onBack: () => Navigator.of(context).pop(), cs: cs),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4.h),

                      FadeTransition(
                        opacity: _headerFade,
                        child: _GradientHeader(cs: cs, tt: tt),
                      ),

                      SizedBox(height: 20.h),

                      locationAsync.when(
                        data: (pos) {
                          if (pos == null) {
                            return _LocationBanner(
                              cs: cs,
                              message: 'Location permission denied',
                              icon: Icons.location_off_rounded,
                              actionLabel: 'Open Settings',
                              onAction: () => Geolocator.openAppSettings(),
                            );
                          }
                          final addressText = addressAsync.maybeWhen(
                            data: (addr) => addr,
                            orElse: () => null,
                          );
                          final displayMessage = addressText != null
                              ? 'Your location: $addressText'
                              : 'Your location: ${pos.latitude.toStringAsFixed(4)}, ${pos.longitude.toStringAsFixed(4)}';
                          return _LocationBanner(
                            cs: cs,
                            message: displayMessage,
                            icon: Icons.my_location_rounded,
                            isSuccess: true,
                            isLoading: addressAsync.isLoading,
                          );
                        },
                        loading: () => _LocationBanner(
                          cs: cs,
                          message: 'Fetching your location...',
                          icon: Icons.gps_not_fixed_rounded,
                          isLoading: true,
                        ),
                        error: (_, __) => _LocationBanner(
                          cs: cs,
                          message: 'Could not get location',
                          icon: Icons.gps_off_rounded,
                        ),
                      ),

                      SizedBox(height: 20.h),

                      _GlassmorphicSearchBar(
                        controller: _searchController,
                        onChanged: (query) =>
                            memberNotifier.filterPatients(query),
                        cs: cs,
                      ),

                      SizedBox(height: 20.h),

                      _RecordsHeader(
                        count: memberState.filteredPatients.length,
                        cs: cs,
                      ),

                      SizedBox(height: 14.h),

                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: memberState.filteredPatients.length,
                        separatorBuilder: (_, __) => SizedBox(height: 14.h),
                        itemBuilder: (context, index) {
                          final patient = memberState.filteredPatients[index];
                          final distText = locationAsync.maybeWhen(
                            data: (pos) =>
                                memberNotifier.getDistanceText(patient, pos),
                            orElse: () => '',
                          );
                          return _PatientCard(
                            patient: patient,
                            index: index,
                            distanceText: distText,
                            cs: cs,
                            tt: tt,
                          );
                        },
                      ),

                      SizedBox(height: 32.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onBack, required this.cs});
  final VoidCallback onBack;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: onBack,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: cs.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: cs.primary,
                      size: 18,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      'Back',
                      style: TextStyle(
                        color: cs.primary,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Spacer(),
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: cs.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.tune_rounded, color: cs.primary, size: 20),
          ),
        ],
      ),
    );
  }
}


class _GradientHeader extends StatelessWidget {
  const _GradientHeader({required this.cs, required this.tt});
  final ColorScheme cs;
  final TextTheme tt;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [cs.primary, cs.primary.withOpacity(0.75)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: cs.primary.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56.w,
            height: 56.w,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(
              Icons.medical_information_rounded,
              color: Colors.white,
              size: 30.w,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Internal Repository',
                  style: tt.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 18.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Patient records from inTEAM Health EMR',
                  style: tt.bodySmall?.copyWith(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12.sp,
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

class _LocationBanner extends StatelessWidget {
  const _LocationBanner({
    required this.cs,
    required this.message,
    required this.icon,
    this.isSuccess = false,
    this.isLoading = false,
    this.actionLabel,
    this.onAction,
  });

  final ColorScheme cs;
  final String message;
  final IconData icon;
  final bool isSuccess;
  final bool isLoading;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final color = isSuccess
        ? cs.outline
        : (isLoading ? cs.secondary : cs.error);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          if (isLoading)
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(color),
              ),
            )
          else
            Icon(icon, color: color, size: 18),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: color,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (actionLabel != null)
            GestureDetector(
              onTap: onAction,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  actionLabel!,
                  style: TextStyle(
                    color: color,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _GlassmorphicSearchBar extends StatelessWidget {
  const _GlassmorphicSearchBar({
    required this.controller,
    required this.onChanged,
    required this.cs,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: cs.outlineVariant.withOpacity(0.15),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: TextStyle(color: cs.onSurface, fontSize: 14.sp),
        decoration: InputDecoration(
          hintText: 'Search by name, ID, or diagnosis...',
          hintStyle: TextStyle(
            color: cs.onSurfaceVariant.withOpacity(0.45),
            fontSize: 13.sp,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: cs.primary.withOpacity(0.6),
            size: 22,
          ),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.close_rounded,
                    color: cs.onSurfaceVariant.withOpacity(0.5),
                    size: 20,
                  ),
                  onPressed: () {
                    controller.clear();
                    onChanged('');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 14.h,
          ),
        ),
      ),
    );
  }
}


class _RecordsHeader extends StatelessWidget {
  const _RecordsHeader({required this.count, required this.cs});
  final int count;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Patient Records',
          style: TextStyle(
            color: cs.onSurface,
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(width: 8.w),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
          decoration: BoxDecoration(
            color: cs.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '$count',
            style: TextStyle(
              color: cs.primary,
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const Spacer(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                cs.primary.withOpacity(0.12),
                cs.primary.withOpacity(0.06),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: cs.primary.withOpacity(0.2)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.verified_rounded, color: cs.primary, size: 14),
              SizedBox(width: 4.w),
              Text(
                'EMR System',
                style: TextStyle(
                  color: cs.primary,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PatientCard extends StatelessWidget {
  const _PatientCard({
    required this.patient,
    required this.index,
    required this.distanceText,
    required this.cs,
    required this.tt,
  });

  final PatientRecord patient;
  final int index;
  final String distanceText;
  final ColorScheme cs;
  final TextTheme tt;

  Color _diagnosisColor() {
    switch (patient.diagnosis.toLowerCase()) {
      case 'hypertension':
      case 'cardiac arrhythmia':
        return const Color(0xFFEF4444);
      case 'diabetes type 2':
        return const Color(0xFFF59E0B);
      case 'asthma':
        return const Color(0xFF3B82F6);
      case 'chronic back pain':
        return const Color(0xFF8B5CF6);
      default:
        return const Color(0xFF6B7280);
    }
  }

  /// Deterministic avatar color from name
  Color _avatarColor() {
    final colors = [
      const Color(0xFF176765),
      const Color(0xFF1976D2),
      const Color(0xFF6366F1),
      const Color(0xFFEC4899),
      const Color(0xFFF59E0B),
    ];
    return colors[index % colors.length];
  }

  String _initials() {
    final parts = patient.name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}';
    }
    return parts[0][0];
  }

  @override
  Widget build(BuildContext context) {
    final diagColor = _diagnosisColor();
    final avatarBg = _avatarColor();

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: cs.outlineVariant.withOpacity(0.12),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Top row: Avatar + Name + Status dot ───
          Row(
            children: [
              // Avatar circle with gradient border
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [avatarBg, avatarBg.withOpacity(0.6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: avatarBg.withOpacity(0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    _initials(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              SizedBox(width: 12.w),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            patient.name,
                            style: tt.titleSmall?.copyWith(
                              color: cs.onSurface,
                              fontWeight: FontWeight.w700,
                              fontSize: 15.sp,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        // Status dot
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: diagColor,
                            boxShadow: [
                              BoxShadow(
                                color: diagColor.withOpacity(0.4),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      patient.id,
                      style: tt.bodySmall?.copyWith(
                        color: cs.primary.withOpacity(0.7),
                        fontWeight: FontWeight.w600,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),

              // ─── Distance badge (top-right) ───
              if (distanceText.isNotEmpty)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 5.h,
                  ),
                  decoration: BoxDecoration(
                    color: cs.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: cs.primary.withOpacity(0.2)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.near_me_rounded, color: cs.primary, size: 13),
                      SizedBox(width: 4.w),
                      Text(
                        distanceText,
                        style: TextStyle(
                          color: cs.primary,
                          fontSize: 10.5.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          SizedBox(height: 14.h),

          // ─── Info chips row ───
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              _InfoChip(
                icon: Icons.person_outline_rounded,
                label: '${patient.age} yrs',
                cs: cs,
              ),
              _InfoChip(
                icon: patient.gender == 'Male'
                    ? Icons.male_rounded
                    : Icons.female_rounded,
                label: patient.gender,
                cs: cs,
              ),
              _InfoChip(
                icon: Icons.calendar_today_rounded,
                label: patient.lastVisit,
                cs: cs,
              ),
            ],
          ),

          SizedBox(height: 12.h),

          // ─── Diagnosis & Location row ───
          Row(
            children: [
              // Diagnosis chip
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: diagColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: diagColor.withOpacity(0.15)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: diagColor,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Flexible(
                        child: Text(
                          patient.diagnosis,
                          style: TextStyle(
                            color: diagColor,
                            fontSize: 11.5.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(width: 8.w),

              // Location chip
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: cs.onSurfaceVariant.withOpacity(0.6),
                      size: 13,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      patient.locationName,
                      style: TextStyle(
                        color: cs.onSurfaceVariant.withOpacity(0.7),
                        fontSize: 10.5.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label, required this.cs});

  final IconData icon;
  final String label;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: cs.outlineVariant.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: cs.onSurfaceVariant.withOpacity(0.6)),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              color: cs.onSurface.withOpacity(0.8),
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
