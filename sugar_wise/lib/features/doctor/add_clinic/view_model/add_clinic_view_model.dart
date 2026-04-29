import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';

class AddClinicViewModel extends ChangeNotifier {
  LatLng? _pickedLocation;
  String _pickedAddress = "اضغط لاختيار موقع العيادة";

  LatLng? get pickedLocation => _pickedLocation;
  String get pickedAddress => _pickedAddress; // 1. الأيام المتاحة

  final List<String> allDays = [
    'SAT',
    'SUN',
    'MON',
    'TUE',
    'WED',
    'THU',
    'FRI',
  ];

  // الأيام المحددة (افتراضياً كما في الصورة)
  final List<String> _selectedDays = ['MON', 'TUE', 'WED', 'THU'];
  List<String> get selectedDays => _selectedDays;

  // 2. الساعات
  TimeOfDay _fromTime = const TimeOfDay(hour: 9, minute: 0); // 09:00 AM
  TimeOfDay _toTime = const TimeOfDay(hour: 17, minute: 0); // 05:00 PM

  TimeOfDay get fromTime => _fromTime;
  TimeOfDay get toTime => _toTime;

  // دالة تحديد/إلغاء تحديد اليوم
  void toggleDay(String day) {
    if (_selectedDays.contains(day)) {
      _selectedDays.remove(day);
    } else {
      _selectedDays.add(day);
    }
    notifyListeners();
  }

  // دالة تحديث وقت البدء
  void setFromTime(TimeOfDay time) {
    _fromTime = time;
    notifyListeners();
  }

  // دالة تحديث وقت الانتهاء
  void setToTime(TimeOfDay time) {
    _toTime = time;
    notifyListeners();
  }

  // دالة تنسيق الوقت ليكون (09:00 AM)
  String formatTime(TimeOfDay time, BuildContext context) {
    return time.format(context);
  }

  Future<void> updateLocation(LatLng location) async {
    _pickedLocation = location;
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        _pickedAddress = "${place.street}, ${place.locality}, ${place.country}";
      }
    } catch (e) {
      _pickedAddress = "موقع مخصص (${location.latitude.toStringAsFixed(4)})";
    }
    notifyListeners();
  }
}
