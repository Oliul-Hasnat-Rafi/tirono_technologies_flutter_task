/// Patient record model with mock coordinates
class PatientRecord {
  final String name;
  final String id;
  final int age;
  final String gender;
  final String lastVisit;
  final String diagnosis;
  final double latitude;
  final double longitude;
  final String locationName;

  const PatientRecord({
    required this.name,
    required this.id,
    required this.age,
    required this.gender,
    required this.lastVisit,
    required this.diagnosis,
    required this.latitude,
    required this.longitude,
    required this.locationName,
  });
}
