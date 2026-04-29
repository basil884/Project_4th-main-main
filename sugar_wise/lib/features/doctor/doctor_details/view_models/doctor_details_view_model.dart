import 'package:flutter/material.dart';
import '../models/doctor_details_model.dart';

class DoctorDetailsViewModel extends ChangeNotifier {
  final DoctorDetailsModel doctor;

  DoctorDetailsViewModel({required this.doctor});

  bool _isFollowing = false;
  bool get isFollowing => _isFollowing;

  int _userRating = 0;
  int get userRating => _userRating;

  void toggleFollow() {
    _isFollowing = !_isFollowing;
    notifyListeners();
  }

  void setUserRating(int rating) {
    _userRating = rating;
    notifyListeners();
  }
}
