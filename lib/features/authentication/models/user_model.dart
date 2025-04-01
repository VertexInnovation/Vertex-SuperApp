class UserModel {
  final String? id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final DateTime? createdAt;
  final Map<String, dynamic>? additionalInfo;

  UserModel({
    this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.createdAt,
    this.additionalInfo,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      displayName: json['displayName'],
      photoUrl: json['photoUrl'],
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : null,
      additionalInfo: json['additionalInfo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'createdAt': createdAt?.toIso8601String(),
      'additionalInfo': additionalInfo,
    };
  }
}