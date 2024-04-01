import 'package:equatable/equatable.dart';

class JobModel extends Equatable {
  final String? id;
  final String? title;
  final String? content;
  final String? image;
  final DateTime? createdAt;
  final String? createdBy;
  final DateTime? updatedAt;
  final String? updatedBy;
  final String? status;

  JobModel({
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

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'image': image,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'status': status,
    };
  }

  @override
  List<Object?> get props =>
      [id, title, content, image, createdAt, createdBy, updatedAt];
}
