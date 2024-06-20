import 'package:social_network/domain/models/service/service_detail.dart';

class ServiceDetailPet extends ServiceDetail {
  final bool isDog;
  final bool isCat;
  final bool isOther;
  final Map<String, String> dogSKU;
  final Map<String, String> catSKU;
  final Map<String, String> otherSKU;
  final bool serviceInHome;

  const ServiceDetailPet({
    required this.isDog,
    required this.isCat,
    required this.isOther,
    required this.dogSKU,
    required this.catSKU,
    required this.otherSKU,
    required this.serviceInHome,
  });

  @override
  List<Object?> get props =>
      [isDog, isCat, isOther, dogSKU, catSKU, otherSKU, serviceInHome];

  @override
  factory ServiceDetailPet.fromJson(Map<String, dynamic> json) {
    return ServiceDetailPet(
      isDog: json['isDog'],
      isCat: json['isCat'],
      isOther: json['isOther'],
      dogSKU: json['dogSKU'],
      catSKU: json['catSKU'],
      otherSKU: json['otherSKU'],
      serviceInHome: json['serviceInHome'],
    );
  }
}
