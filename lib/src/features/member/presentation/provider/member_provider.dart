import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/services/location_service.dart';
import '../../data/model/patient_record.dart';
import 'member_state.dart';

// ═══════════════════════════════════════════════════════════════════
// Location providers (unchanged)
// ═══════════════════════════════════════════════════════════════════

/// Provides a singleton LocationService instance
final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

/// Fetches the user's current GPS position (requests permission on first call)
final userLocationProvider = FutureProvider<Position?>((ref) async {
  final locationService = ref.read(locationServiceProvider);
  return await locationService.getCurrentPosition();
});

/// Reverse geocodes the user's position into a human-readable address
final userAddressProvider = FutureProvider<String?>((ref) async {
  final posAsync = await ref.watch(userLocationProvider.future);
  if (posAsync == null) return null;
  final locationService = ref.read(locationServiceProvider);
  return await locationService.getAddressFromPosition(posAsync);
});

// ═══════════════════════════════════════════════════════════════════
// Member Notifier — all data & logic lives here
// ═══════════════════════════════════════════════════════════════════

/// Mock patient data with Dhaka-area coordinates
const List<PatientRecord> _mockPatients = [
  PatientRecord(
    name: 'John Doe',
    id: 'INT-001',
    age: 45,
    gender: 'Male',
    lastVisit: '2024-12-01',
    diagnosis: 'Hypertension',
    latitude: 23.8103,
    longitude: 90.4125,
    locationName: 'Dhaka Medical College',
  ),
  PatientRecord(
    name: 'Sarah Smith',
    id: 'INT-002',
    age: 32,
    gender: 'Female',
    lastVisit: '2024-11-28',
    diagnosis: 'Diabetes Type 2',
    latitude: 23.7465,
    longitude: 90.3763,
    locationName: 'Dhanmondi Clinic',
  ),
  PatientRecord(
    name: 'Michael Johnson',
    id: 'INT-003',
    age: 58,
    gender: 'Male',
    lastVisit: '2024-12-05',
    diagnosis: 'Cardiac Arrhythmia',
    latitude: 23.7937,
    longitude: 90.4066,
    locationName: 'Bangabandhu Cardiac Center',
  ),
  PatientRecord(
    name: 'Emily Davis',
    id: 'INT-004',
    age: 27,
    gender: 'Female',
    lastVisit: '2024-11-20',
    diagnosis: 'Asthma',
    latitude: 23.7806,
    longitude: 90.4195,
    locationName: 'Motijheel Health Point',
  ),
  PatientRecord(
    name: 'Robert Wilson',
    id: 'INT-005',
    age: 63,
    gender: 'Male',
    lastVisit: '2024-12-03',
    diagnosis: 'Chronic Back Pain',
    latitude: 23.8700,
    longitude: 90.3950,
    locationName: 'Uttara Spine Clinic',
  ),
];

class MemberNotifier extends StateNotifier<MemberState> {
  final LocationService _locationService;

  MemberNotifier(this._locationService)
    : super(
        const MemberState(
          allPatients: _mockPatients,
          filteredPatients: _mockPatients,
        ),
      );

  /// Filter patients by name, ID, or diagnosis
  void filterPatients(String query) {
    if (query.isEmpty) {
      state = state.copyWith(
        filteredPatients: state.allPatients,
        searchQuery: '',
      );
    } else {
      final lowerQuery = query.toLowerCase();
      state = state.copyWith(
        filteredPatients: state.allPatients
            .where(
              (p) =>
                  p.name.toLowerCase().contains(lowerQuery) ||
                  p.id.toLowerCase().contains(lowerQuery) ||
                  p.diagnosis.toLowerCase().contains(lowerQuery),
            )
            .toList(),
        searchQuery: query,
      );
    }
  }

  /// Calculate formatted distance string between user and patient
  String getDistanceText(PatientRecord patient, Position? userPosition) {
    if (userPosition == null) return '';
    final distKm = _locationService.calculateDistanceKm(
      userLat: userPosition.latitude,
      userLng: userPosition.longitude,
      destLat: patient.latitude,
      destLng: patient.longitude,
    );
    if (distKm < 1) {
      return '${(distKm * 1000).toStringAsFixed(0)} m away';
    }
    return '${distKm.toStringAsFixed(1)} km away';
  }
}

/// Provider for MemberNotifier
final memberNotifierProvider =
    StateNotifierProvider<MemberNotifier, MemberState>((ref) {
      final locationService = ref.read(locationServiceProvider);
      return MemberNotifier(locationService);
    });
