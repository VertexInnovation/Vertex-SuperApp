import 'package:firebase_auth/firebase_auth.dart';

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

  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      id: user.uid,
      email: user.email ?? '', // Firebase email can sometimes be null, provide a fallback
      displayName: user.displayName ?? user.email?.split('@').first, // Use email part if displayName is null
      photoUrl: user.photoURL,
      createdAt: user.metadata.creationTime ?? DateTime.now(), // Use Firebase creation time
      additionalInfo: {'Nothing': 'Absolutely nothing'},
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