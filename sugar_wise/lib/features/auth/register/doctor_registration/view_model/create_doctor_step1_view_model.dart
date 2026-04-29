import 'package:flutter/material.dart';

class CreateDoctorStep1ViewModel extends ChangeNotifier {
  // المتغيرات التي تحمل بيانات الفورم
  String _firstName = '';
  String _lastName = '';
  String _gender = 'Male'; // القيمة الافتراضية كما في التصميم
  DateTime? _birthday;
  String _phoneNumber = '';

  // Getters
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get gender => _gender;
  DateTime? get birthday => _birthday;
  String get phoneNumber => _phoneNumber;

  // 🔥 هنا السحر: دالة تتحقق مما إذا كانت كل الحقول ممتلئة
  bool get isFormValid {
    return _firstName.trim().isNotEmpty &&
        _lastName.trim().isNotEmpty &&
        _birthday != null &&
        _phoneNumber.trim().isNotEmpty;
  }

  // دوال تحديث البيانات (كل دالة تنادي notifyListeners لتحديث لون الزر)
  void updateFirstName(String val) {
    _firstName = val;
    notifyListeners();
  }

  void updateLastName(String val) {
    _lastName = val;
    notifyListeners();
  }

  void setGender(String val) {
    _gender = val;
    notifyListeners();
  }

  void setBirthday(DateTime date) {
    _birthday = date;
    notifyListeners();
  }

  void updatePhoneNumber(String val) {
    _phoneNumber = val;
    notifyListeners();
  }

  // فورمات التاريخ ليظهر بالشكل المطلوب mm/dd/yyyy
  String get formattedBirthday {
    if (_birthday == null) return "mm/dd/yyyy";
    return "${_birthday!.month.toString().padLeft(2, '0')}/${_birthday!.day.toString().padLeft(2, '0')}/${_birthday!.year}";
  }
}
