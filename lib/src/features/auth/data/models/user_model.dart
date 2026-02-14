class UserModel {
  final String? id;
  final String? name;
  final String? phone;
  final String? email;
  final String? role;
  final String? accessToken;
  final bool? isDeleted;
  final String? password;
  final String? createdAt;
  final String? updatedAt;

  UserModel({
    this.id,
    this.name,
    this.phone,
    this.email,
    this.role,
    this.accessToken,
    this.isDeleted,
    this.password,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      role: json['role'] as String?,
      accessToken: json['accessToken'] as String?,
      isDeleted: json['isDeleted'] as bool?,
      password: json['password'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel.fromJson(map);

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'role': role,
      'accessToken': accessToken,
      'isDeleted': isDeleted,
      'password': password,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
