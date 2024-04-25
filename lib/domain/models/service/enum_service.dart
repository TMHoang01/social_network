enum BookingStatus {
  pending,
  accepted,
  rejected,
  completed;

  String toName() {
    switch (this) {
      case BookingStatus.pending:
        return 'Chờ xử lý';
      case BookingStatus.accepted:
        return 'Đã chấp nhận';
      case BookingStatus.rejected:
        return 'Đã từ chối';
      case BookingStatus.completed:
        return 'Đã hoàn thành';
      default:
        return '';
    }
  }

  String toJson() => name;
  static BookingStatus fromJson(String json) => values.byName(json);
}

enum BookingRepeatType {
  weekly,
  monthly,
  yearly;

  String toJson() => name;
  static BookingRepeatType fromJson(String json) => values.byName(json);

  String toName() {
    switch (this) {
      case BookingRepeatType.weekly:
        return 'Hàng tuần';
      case BookingRepeatType.monthly:
        return 'Hàng tháng';
      case BookingRepeatType.yearly:
        return 'Hàng năm';
      default:
        return '';
    }
  }
}

enum ServiceType {
  childCare,
  oldCare,
  petCare,
  houseCleaning,
  applianceRepair,
  plumbing,
  electrical,
  painting,
  carpentry,
  gardening,
  computerRepair,
  tutoring,
  eventPlanning,
  catering,
  hairStyling,
  makeup,
  massage,
  therapy,
  legal,
  // financial,
  // realEstate,
  other;

  String toJson() => name;
  static ServiceType fromJson(String json) => values.byName(json);

  String toName() {
    return switch (this) {
      ServiceType.childCare => 'Chăm sóc người già, trẻ em',
      ServiceType.oldCare => 'Chăm sóc người già',
      ServiceType.petCare => 'Trông thú cưng',
      ServiceType.houseCleaning => 'Dọn dẹp nhà cửa',
      ServiceType.applianceRepair => 'Sửa chữa thiết bị gia dụng',
      ServiceType.plumbing => 'Sửa ống nước',
      ServiceType.electrical => 'Sửa điện',
      ServiceType.painting => 'Sơn nhà',
      ServiceType.carpentry => 'Thợ mộc',
      ServiceType.gardening => 'Làm vườn',
      ServiceType.computerRepair => 'Sửa máy tính',
      ServiceType.tutoring => 'Gia sư',
      ServiceType.eventPlanning => 'Tổ chức sự kiện',
      ServiceType.catering => 'Cung cấp thực phẩm',
      ServiceType.hairStyling => 'Làm tóc',
      ServiceType.makeup => 'Trang điểm',
      ServiceType.massage => 'Mát-xa',
      ServiceType.therapy => 'Tư vấn sức khỏe',
      ServiceType.legal => 'Luật sư',
      ServiceType.other => 'Khác',
      _ => '',
    };
  }
}

// loại hình tính dịch tiền dịch vụ
enum PriceType {
  fixed,
  hourly,
  package,
  other;

  String toJson() => name;
  static PriceType fromJson(String json) => values.byName(json);

  String toName() {
    return switch (this) {
      PriceType.fixed => 'Cố định',
      PriceType.hourly => 'Theo giờ',
      PriceType.package => 'Gói',
      PriceType.other => 'Khác',
    };
  }
}
