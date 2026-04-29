import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // ✅ تم استيراد مكتبة الحفظ
import '../models/patient_profile_model.dart';

class ProfileViewModel extends ChangeNotifier {
  // ✅ أزلنا كلمة final لكي نتمكن من تعديل البيانات
  PatientProfileModel patientData = PatientProfileModel(
    name: "Basil Ashraf",
    imageUrl: "assets/images/patient_avatar.png",
    patientId: "SW-4029",
    height: "175",
    weight: "60",
    age: "22 Years",
    gender: "Male",
    bloodType: "A+",
    address: "Al-Maadi, Cairo, Egypt",
    phone: "+20 1005550944",
    primaryCondition: "Type 1 Diabetes",
    conditionDuration: "Since 4 Years",
    basalInsulin: "Lantus",
    bolusInsulin: "Novorapid",
    otherMedications: ["Vitamin D3", "Multivitamin"],
  );

  // 🔥 1. دالة لاسترجاع البيانات المحفوظة عند فتح التطبيق
  Future<void> loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();

    // نتحقق مما إذا كان هناك اسم محفوظ مسبقاً (كدليل على وجود بيانات)
    if (prefs.containsKey('p_name')) {
      patientData = PatientProfileModel(
        name: prefs.getString('p_name') ?? patientData.name,
        phone: prefs.getString('p_phone') ?? patientData.phone,
        imageUrl: prefs.getString('p_image') ?? patientData.imageUrl,
        patientId: patientData.patientId, // الـ ID يظل كما هو
        age: prefs.getString('p_age') ?? patientData.age,
        gender: prefs.getString('p_gender') ?? patientData.gender,
        bloodType: prefs.getString('p_bloodType') ?? patientData.bloodType,
        address: prefs.getString('p_address') ?? patientData.address,
        height: prefs.getString('p_height') ?? patientData.height,
        weight: prefs.getString('p_weight') ?? patientData.weight,
        primaryCondition:
            prefs.getString('p_condition') ?? patientData.primaryCondition,
        conditionDuration:
            prefs.getString('p_duration') ?? patientData.conditionDuration,
        basalInsulin: prefs.getString('p_basal') ?? patientData.basalInsulin,
        bolusInsulin: prefs.getString('p_bolus') ?? patientData.bolusInsulin,
        otherMedications:
            patientData.otherMedications, // الأدوية تظل كما هي حالياً
      );
      notifyListeners(); // تحديث الواجهة بالبيانات المحفوظة
    }
  }

  // 🔥 2. تم تحويل الدالة إلى async لكي ننتظر عملية الحفظ
  Future<void> updateProfile({
    required String newName,
    required String newPhone,
    String? newImagePath,
    required String newAge,
    required String newGender,
    required String newBloodType,
    required String newAddress,
    required String newHeight,
    required String newWeight,
    required String newCondition,
    required String newDuration,
    required String newBasal,
    required String newBolus,
  }) async {
    patientData = PatientProfileModel(
      name: newName,
      phone: newPhone,
      imageUrl: newImagePath ?? patientData.imageUrl,
      patientId: patientData.patientId,
      age: newAge,
      gender: newGender,
      bloodType: newBloodType,
      address: newAddress,
      height: newHeight,
      weight: newWeight,
      primaryCondition: newCondition,
      conditionDuration: newDuration,
      basalInsulin: newBasal,
      bolusInsulin: newBolus,
      otherMedications: patientData.otherMedications,
    );

    notifyListeners(); // تحديث الشاشة فوراً

    // 🔥 3. استدعاء دالة الحفظ في الهاتف
    await _saveDataToLocal();
  }

  // 🔥 4. دالة خاصة لحفظ كل البيانات في SharedPreferences
  Future<void> _saveDataToLocal() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('p_name', patientData.name);
    await prefs.setString('p_phone', patientData.phone);
    await prefs.setString('p_image', patientData.imageUrl);
    await prefs.setString('p_age', patientData.age);
    await prefs.setString('p_gender', patientData.gender);
    await prefs.setString('p_bloodType', patientData.bloodType);
    await prefs.setString('p_address', patientData.address);
    await prefs.setString('p_height', patientData.height);
    await prefs.setString('p_weight', patientData.weight);
    await prefs.setString('p_condition', patientData.primaryCondition);
    await prefs.setString('p_duration', patientData.conditionDuration);
    await prefs.setString('p_basal', patientData.basalInsulin);
    await prefs.setString('p_bolus', patientData.bolusInsulin);
  }
}
