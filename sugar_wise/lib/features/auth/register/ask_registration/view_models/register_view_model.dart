import 'package:flutter/material.dart';

// نحدد أنواع الحسابات المتاحة
enum AccountType { none, patient, doctor }

class RegisterViewModel extends ChangeNotifier {
  AccountType _selectedType = AccountType.none;

  AccountType get selectedType => _selectedType;

  // دالة لتغيير الاختيار وتحديث الشاشة
  void selectAccountType(AccountType type) {
    _selectedType = type;
    notifyListeners();
  }

  // للتحقق مما إذا كان الزر السفلي يجب أن يكون مفعلاً
  bool get canContinue => _selectedType != AccountType.none;
}
