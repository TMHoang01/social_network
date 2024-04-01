import 'package:equatable/equatable.dart';

class EventModel extends Equatable {
  final String? id;
  final String? title;
  final String? content;
  final String? image;
  final String? location;
  final DateTime? beginDate;
  final DateTime? endDate;
  final List<String> joiners;
  final DateTime? createdAt;
  final String? createdBy;
  final DateTime? updatedAt;
  final String? updatedBy;
  final String? status;

  EventModel({
    this.id,
    this.title,
    this.content,
    this.image,
    this.location,
    this.beginDate,
    this.endDate,
    this.joiners = const [],
    this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
    this.status,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      image: json['image'],
      location: json['location'],
      beginDate:
          json['beginDate'] != null ? DateTime.parse(json['beginDate']) : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      joiners: (json['joiners'] as List).map((e) => e.toString()).toList(),
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
      'location': location,
      'beginDate': beginDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'joiners': joiners,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'status': status,
    };
  }

  @override
  List<Object?> get props => [
        id,
        title,
        content,
        image,
        location,
        beginDate,
        endDate,
        joiners,
        createdAt,
        createdBy,
        updatedAt,
        updatedBy,
        status
      ];
}
