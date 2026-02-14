class MentorUserModel {
  final String id;
  final String name;
  final String email;
  final String? avatar;

  const MentorUserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
  });

  factory MentorUserModel.fromJson(Map<String, dynamic> json) {
    return MentorUserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatar: json['avatar'],
    );
  }
}
