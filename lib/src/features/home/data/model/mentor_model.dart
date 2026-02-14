import 'mentor_user_model.dart';

class MentorModel {
  final String id;
  final MentorUserModel user;
  final String? professionTitle;
  final int? yearsOfExperience;
  final List<String> expertiseArea;
  final List<String> languages;
  final String? bio;
  final String? country;
  final int rating;
  final int totalStudents;
  final int totalCourses;

  const MentorModel({
    required this.id,
    required this.user,
    this.professionTitle,
    this.yearsOfExperience,
    required this.expertiseArea,
    required this.languages,
    this.bio,
    this.country,
    required this.rating,
    required this.totalStudents,
    required this.totalCourses,
  });

  factory MentorModel.fromJson(Map<String, dynamic> json) {
    return MentorModel(
      id: json['id'] ?? '',
      user: MentorUserModel.fromJson(json['user'] ?? {}),
      professionTitle: json['professionTitle'],
      yearsOfExperience: json['yearsOfExperience'],
      expertiseArea:
          (json['expertiseArea'] as List<dynamic>? ?? []).cast<String>(),
      languages:
          (json['languages'] as List<dynamic>? ?? []).cast<String>(),
      bio: json['bio'],
      country: json['country'],
      rating: json['rating'] ?? 0,
      totalStudents: json['totalStudents'] ?? 0,
      totalCourses: json['totalCourses'] ?? 0,
    );
  }
}
