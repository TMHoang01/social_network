class Validators {
  static String? validateEmail(String? value) {
    if (value!.isEmpty) {
      return 'Vui lòng nhập email của bạn';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Email không hợp lệ';
    }
    return null;
  }

  // validate password
  static String? validatePassword(String? value) {
    if (value!.isEmpty) {
      return 'Vui lòng nhập mật khẩu của bạn';
    }
    if (value.length < 6) {
      return 'Mật khẩu phải chứa ít nhất 6 ký tự';
    }
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value!.isEmpty) {
      return 'Vui lòng nhập số điện thoại của bạn';
    }
    if (!RegExp(r'^(\+84|0)+([0-9]{9,10})$').hasMatch(value)) {
      return 'Số điện thoại không hợp lệ';
    }
    return null;
  }

  // validate date
  static String? validateDateTime(String? value) {
    if (value!.isEmpty) {
      return 'Vui lòng chọn ngày sinh của bạn';
    }
    try {
      DateTime.parse(value);
    } catch (e) {
      return 'Ngày sinh không hợp lệ';
    }
    return null;
  }
}
