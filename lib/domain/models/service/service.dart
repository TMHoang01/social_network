import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:social_network/domain/models/service/price_list.dart';
import 'package:social_network/utils/text_format.dart';

import './enum_service.dart';

class ServiceModel extends Equatable {
  final String? id;
  final ServiceType? type;
  final bool? isRecurringSevice;
  final String? providerId;
  final String? providerName;
  final String? title;
  final String? image;
  final String? description;
  final List<PriceList>? priceList;
  final double? rating;
  final int? bookingCount;
  final DateTime? createdAt;
  final String? createdBy;
  final DateTime? updatedAt;
  final String? updatedBy;

  ServiceModel({
    this.id,
    this.type,
    this.image,
    this.isRecurringSevice,
    this.providerId,
    this.providerName,
    this.title,
    this.description,
    this.priceList,
    this.rating = 0.0,
    this.bookingCount = 0,
    this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
  });

  get typeNames => type?.toName();

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'],
      type: json['type'] != null ? ServiceType.fromJson(json['type']) : null,
      image: json['image'],
      isRecurringSevice: json['isRecurringSevice'],
      providerId: json['providerId'],
      providerName: json['providerName'],
      title: json['title'],
      description: json['description'],
      priceList: json['priceList'] != null
          ? List<PriceList>.from(
              json['priceList'].map((x) => PriceList.fromJson(x)))
          : [],
      rating: json['rating'] ?? 0.0,
      bookingCount: json['bookingCount'] ?? 0,
      createdAt: TextFormat.parseJson(json['createdAt']) ?? DateTime.now(),
      createdBy: json['createdBy'],
      updatedAt: TextFormat.parseJson(json['updatedAt']) ?? DateTime.now(),
    );
  }

  factory ServiceModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    return ServiceModel.fromJson(doc.data() as Map<String, dynamic>).copyWith(
      id: doc.id,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (type != null) 'type': type?.toJson(),
      if (image != null) 'image': image,
      if (isRecurringSevice != null) 'isRecurringSevice': isRecurringSevice,
      if (providerId != null) 'providerId': providerId,
      if (providerName != null) 'providerName': providerName,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (priceList != null)
        'priceList': priceList?.map((x) => x.toJson()).toList(),
      if (rating != null) 'rating': rating,
      if (bookingCount != null) 'bookingCount': bookingCount,
      if (createdAt != null) 'createdAt': createdAt,
      if (createdBy != null) 'createdBy': createdBy,
      if (updatedAt != null) 'updatedAt': updatedAt,
      if (updatedBy != null) 'updatedBy': updatedBy,
    };
  }

  ServiceModel copyWith({
    String? id,
    ServiceType? type,
    String? image,
    bool? isRecurringSevice,
    String? providerId,
    String? providerName,
    String? title,
    String? description,
    List<PriceList>? priceList,
    double? rating,
    int? bookingCount,
    DateTime? createdAt,
    String? createdBy,
    DateTime? updatedAt,
    String? updatedBy,
  }) {
    return ServiceModel(
      id: id ?? this.id,
      type: type ?? this.type,
      image: image ?? this.image,
      isRecurringSevice: isRecurringSevice ?? this.isRecurringSevice,
      providerId: providerId ?? this.providerId,
      title: title ?? this.title,
      description: description ?? this.description,
      priceList: priceList ?? this.priceList,
      rating: rating ?? this.rating,
      bookingCount: bookingCount ?? this.bookingCount,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
    );
  }

  @override
  List<Object?> get props => [
        id,
        type,
        image,
        isRecurringSevice,
        providerId,
        title,
        description,
        priceList,
        rating,
        bookingCount,
        createdAt,
        createdBy,
        updatedAt,
        updatedBy,
      ];
}
