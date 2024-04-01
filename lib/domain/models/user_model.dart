import 'package:cloud_firestore/cloud_firestore.dart';

enum Role { admin, user }

class UserModel {
  final String? id;
  final String? username;
  final String? email;
  final String? phoneNumber;
  final DateTime? createdAt;
  final Role? roles;
  final String? bio; // short description
  final String? photoUrl;
  final String? address;

  UserModel({
    this.username,
    this.email,
    this.phoneNumber,
    this.createdAt,
    this.roles,
    this.id,
    this.bio,
    this.photoUrl,
    this.address,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      createdAt: json["create_at"] != null
          ? (json["create_at"] as Timestamp).toDate()
          : DateTime.now(),
      roles: json['roles'] == 'admin' ? Role.admin : Role.user,
      bio: json['bio'],
      photoUrl: json['photoUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'created_at': createdAt,
      'roles': roles == Role.admin ? 'admin' : 'user',
      'bio': bio,
      'photoUrl': photoUrl,
    };
  }

  factory UserModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel.fromJson(data).copyWith(id: doc.id);
  }

  UserModel copyWith({
    String? id,
    String? username,
    String? email,
    String? phoneNumber,
    DateTime? createdAt,
    Role? roles,
    String? bio,
    String? photoUrl,
    String? address,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      createdAt: createdAt ?? this.createdAt,
      roles: roles ?? this.roles,
      bio: bio ?? this.bio,
      photoUrl: photoUrl ?? this.photoUrl,
      address: address ?? this.address,
    );
  }

  @override
  String toString() {
    return 'UserModel(username: $username, email: $email, roles: $roles)';
  }
}
