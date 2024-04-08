import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

enum PostType { event, news, other, jobs }

class PostModel extends Equatable {
  final String? id;
  final String? title;
  final String? content;
  final String? image;
  final DateTime? createdAt;
  final String? createdBy;
  final DateTime? updatedAt;
  final String? updatedBy;
  final String? status;

  PostModel({
    this.id,
    this.title,
    this.content,
    this.image,
    this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
    this.status,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      image: json['image'],
      createdBy: json['createdBy'],
      updatedBy: json['updatedBy'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      status: json['status'],
    );
  }

  factory PostModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    return PostModel.fromJson(doc.data() as Map<String, dynamic>)
        .copyWith(id: doc.id);
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (image != null) 'image': image,
      if (createdBy != null) 'createdBy': createdBy,
      if (updatedBy != null) 'updatedBy': updatedBy,
      if (createdAt != null) 'createdAt': createdAt?.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toIso8601String(),
      if (status != null) 'status': status,
    };
  }

  PostModel copyWith({
    String? id,
    String? title,
    String? content,
    String? image,
    DateTime? createdAt,
    String? createdBy,
    DateTime? updatedAt,
    String? updatedBy,
    String? status,
  }) {
    return PostModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      image: image ?? this.image,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props =>
      [id, title, content, image, createdAt, createdBy, updatedAt];
}
