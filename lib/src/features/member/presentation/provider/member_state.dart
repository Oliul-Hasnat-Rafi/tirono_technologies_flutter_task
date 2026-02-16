import '../../data/model/patient_record.dart';

/// Holds the state for the Member feature
class MemberState {
  final List<PatientRecord> allPatients;
  final List<PatientRecord> filteredPatients;
  final String searchQuery;

  const MemberState({
    required this.allPatients,
    required this.filteredPatients,
    this.searchQuery = '',
  });

  MemberState copyWith({
    List<PatientRecord>? allPatients,
    List<PatientRecord>? filteredPatients,
    String? searchQuery,
  }) {
    return MemberState(
      allPatients: allPatients ?? this.allPatients,
      filteredPatients: filteredPatients ?? this.filteredPatients,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
