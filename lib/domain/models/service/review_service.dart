import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:social_network/utils/text_format.dart';

class ReviewService extends Equatable {
  final String? id;
  final String? userId;
  final String? userName;
  final String? userAvatar;
  final String? serviceId;
  final String? bookingId;
  final double? rating;

  final String? comment;
  final DateTime? createdAt;
  final List<ReplyRating>? listReply;

  const ReviewService({
    this.id,
    this.userId,
    this.userName,
    this.userAvatar,
    this.serviceId,
    this.bookingId,
    this.rating,
    this.comment,
    this.createdAt,
    this.listReply,
  });

  @override
  List<Object?> get props =>
      [id, userId, serviceId, rating, bookingId, comment, createdAt];

  factory ReviewService.fromJson(Map<String, dynamic> json) {
    return ReviewService(
      id: json['id'],
      userId: json['userId'],
      userName: json['userName'],
      userAvatar: json['userAvatar'],
      serviceId: json['serviceId'],
      rating: json['rating'],
      bookingId: json['bookingId'],
      comment: json['comment'],
      createdAt: TextFormat.parseJson(json['createdAt']),
    );
  }

  factory ReviewService.fromDocumentSnapshot(DocumentSnapshot doc) {
    return ReviewService.fromJson(doc.data() as Map<String, dynamic>)
        .copyWith(id: doc.id);
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (userId != null) 'userId': userId,
      if (userName != null) 'userName': userName,
      if (userAvatar != null) 'userAvatar': userAvatar,
      if (serviceId != null) 'serviceId': serviceId,
      if (bookingId != null) 'bookingId': bookingId,
      if (rating != null) 'rating': rating,
      if (comment != null) 'comment': comment,
      if (createdAt != null) 'createdAt': createdAt,
    };
  }

  ReviewService copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userAvatar,
    String? serviceId,
    String? bookingId,
    double? rating,
    String? comment,
    DateTime? createdAt,
    List<ReplyRating>? listReply,
  }) {
    return ReviewService(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      serviceId: serviceId ?? this.serviceId,
      bookingId: bookingId ?? this.bookingId,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
      listReply: listReply ?? this.listReply,
    );
  }
}

class ReplyRating extends Equatable {
  final String? id;
  final String? isProvider;
  final String? userId;
  final String? content;
  final DateTime? createdAt;

  const ReplyRating({
    this.id,
    this.isProvider,
    this.userId,
    this.content,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, isProvider, userId, content, createdAt];

  factory ReplyRating.fromJson(Map<String, dynamic> json) {
    return ReplyRating(
      id: json['id'],
      isProvider: json['isProvider'],
      userId: json['userId'],
      content: json['content'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'isProvider': isProvider,
      'userId': userId,
      'content': content,
      'createdAt': createdAt,
    };
  }
}
