import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class PriceList extends Equatable {
  final String? id;
  final String? name;
  final num? price;
  final String? note;

  PriceList({
    this.id,
    this.name,
    this.price,
    this.note,
  });

  factory PriceList.fromJson(Map<String, dynamic> json) {
    return PriceList(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      note: json['note'],
    );
  }

  factory PriceList.fromDocumentSnapshot(DocumentSnapshot doc) {
    return PriceList.fromJson(doc.data() as Map<String, dynamic>).copyWith(
      id: doc.id,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (price != null) 'price': price,
      if (note != null) 'note': note,
    };
  }

  PriceList copyWith({
    String? id,
    String? name,
    num? price,
    String? note,
  }) {
    return PriceList(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      note: note ?? this.note,
    );
  }

  @override
  List<Object?> get props => [id, name, price];
}
