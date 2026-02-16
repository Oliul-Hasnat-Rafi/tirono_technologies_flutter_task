import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tirono_technologies_flutter_task/src/core/utils/dev_functions/dev_scaffold.dart';

/// Patient record model
class PatientRecord {
  final String name;
  final String id;
  final int age;
  final String gender;
  final String lastVisit;
  final String diagnosis;

  const PatientRecord({
    required this.name,
    required this.id,
    required this.age,
    required this.gender,
    required this.lastVisit,
    required this.diagnosis,
  });
}

class MemberScreen extends StatefulWidget {
  const MemberScreen({super.key});

  @override
  State<MemberScreen> createState() => _MemberScreenState();
}

class _MemberScreenState extends State<MemberScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<PatientRecord> _patients = const [
    PatientRecord(
      name: 'John Doe',
      id: 'INT-001',
      age: 45,
      gender: 'Male',
      lastVisit: '2024-12-01',
      diagnosis: 'Hypertension',
    ),
    PatientRecord(
      name: 'Sarah Smith',
      id: 'INT-002',
      age: 32,
      gender: 'Female',
      lastVisit: '2024-11-28',
      diagnosis: 'Diabetes Type 2',
    ),
    PatientRecord(
      name: 'Michael Johnson',
      id: 'INT-003',
      age: 58,
      gender: 'Male',
      lastVisit: '2024-12-05',
      diagnosis: 'Cardiac Arrhythmia',
    ),
    PatientRecord(
      name: 'Emily Davis',
      id: 'INT-004',
      age: 27,
      gender: 'Female',
      lastVisit: '2024-11-20',
      diagnosis: 'Asthma',
    ),
    PatientRecord(
      name: 'Robert Wilson',
      id: 'INT-005',
      age: 63,
      gender: 'Male',
      lastVisit: '2024-12-03',
      diagnosis: 'Chronic Back Pain',
    ),
  ];

  List<PatientRecord> _filteredPatients = [];

  @override
  void initState() {
    super.initState();
    _filteredPatients = _patients;
  }

  void _filterPatients(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredPatients = _patients;
      } else {
        _filteredPatients = _patients
            .where((p) =>
                p.name.toLowerCase().contains(query.toLowerCase()) ||
                p.id.toLowerCase().contains(query.toLowerCase()) ||
                p.diagnosis.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DevScaffold(
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _BackButton(onTap: () => Navigator.of(context).pop()),

              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8.h),

                      const _RepositoryHeader(),

                      SizedBox(height: 16.h),

                      _SearchBar(
                        controller: _searchController,
                        onChanged: _filterPatients,
                      ),

                      SizedBox(height: 20.h),

                      _RecordsTitle(count: _filteredPatients.length),

                      SizedBox(height: 12.h),

                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _filteredPatients.length,
                        separatorBuilder: (_, __) => SizedBox(height: 12.h),
                        itemBuilder: (context, index) {
                          return _PatientCard(
                            patient: _filteredPatients[index],
                          );
                        },
                      ),

                      SizedBox(height: 24.h),
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

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      child: TextButton.icon(
        onPressed: onTap,
        icon: Icon(Icons.arrow_back, color: colorScheme.primary, size: 20),
        label: Text(
          'Back',
          style: TextStyle(
            color: colorScheme.primary,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
        ),
      ),
    );
  }
}

class _RepositoryHeader extends StatelessWidget {
  const _RepositoryHeader();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Container(
          width: 44.w,
          height: 44.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: colorScheme.outlineVariant.withOpacity(0.5),
              width: 1.5,
            ),
            color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
          ),
          child: Icon(
            Icons.account_circle_rounded,
            color: colorScheme.onSurfaceVariant,
            size: 28.w,
          ),
        ),

        SizedBox(width: 12.w),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Internal Repository',
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Patient records from inTEAM Health EMR System',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.25),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outlineVariant.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 14.sp,
        ),
        decoration: InputDecoration(
          hintText: 'Search internal records...',
          hintStyle: TextStyle(
            color: colorScheme.onSurfaceVariant.withOpacity(0.5),
            fontSize: 14.sp,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: colorScheme.onSurfaceVariant.withOpacity(0.5),
            size: 20,
          ),
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

class _RecordsTitle extends StatelessWidget {
  const _RecordsTitle({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Internal Patient Records\n($count)',
          style: textTheme.titleSmall?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
            height: 1.4,
          ),
        ),

        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: colorScheme.primary.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: colorScheme.primary.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Text(
            'Internal\nSystem',
            textAlign: TextAlign.center,
            style: textTheme.labelSmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}

class _PatientCard extends StatelessWidget {
  const _PatientCard({required this.patient});
  final PatientRecord patient;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.2),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: colorScheme.outlineVariant.withOpacity(0.25),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorScheme.primary.withOpacity(0.5),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  Icons.person_outline_rounded,
                  color: colorScheme.primary,
                  size: 22.w,
                ),
              ),

              SizedBox(width: 12.w),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    patient.name,
                    style: textTheme.titleSmall?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    patient.id,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.primary.withOpacity(0.7),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 12.h),

          Row(
            children: [
              _DetailItem(
                icon: Icons.person_outline,
                label: 'Age:',
                value: '${patient.age}',
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),

              SizedBox(width: 24.w),

              _DetailItem(
                label: 'Gender:',
                value: patient.gender,
                colorScheme: colorScheme,
                textTheme: textTheme,
                isBoldValue: true,
              ),
            ],
          ),

          SizedBox(height: 8.h),

          Row(
            children: [
              _DetailItem(
                icon: Icons.calendar_today_outlined,
                label: 'Last\nVisit:',
                value: patient.lastVisit,
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),

              SizedBox(width: 16.w),

              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '•  ',
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant.withOpacity(0.6),
                        fontSize: 12.sp,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Diagnosis:',
                          style: textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant.withOpacity(0.6),
                          ),
                        ),
                        Text(
                          patient.diagnosis,
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
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

class _DetailItem extends StatelessWidget {
  const _DetailItem({
    this.icon,
    required this.label,
    required this.value,
    required this.colorScheme,
    required this.textTheme,
    this.isBoldValue = false,
  });

  final IconData? icon;
  final String label;
  final String value;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final bool isBoldValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            size: 14,
            color: colorScheme.onSurfaceVariant.withOpacity(0.5),
          ),
          SizedBox(width: 4.w),
        ],
        Text(
          label,
          style: textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant.withOpacity(0.6),
          ),
        ),
        SizedBox(width: 6.w),
        Text(
          value,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: isBoldValue ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}