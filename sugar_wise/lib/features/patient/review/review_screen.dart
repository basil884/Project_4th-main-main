import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugar_wise/core/providers/user_provider.dart';
import 'package:sugar_wise/core/api/api_client.dart';
import 'package:sugar_wise/features/patient/notfications_patient/notfication/view_model/notifications_view_model.dart';
import 'package:sugar_wise/features/patient/notfications_patient/notfication/model/notification_model.dart';
import 'package:sugar_wise/features/doctor/doctor_view_patient/model/doctor_model.dart';

class WriteReviewScreen extends StatefulWidget {
  final DoctorModle doctor;

  const WriteReviewScreen({super.key, required this.doctor});

  @override
  State<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends State<WriteReviewScreen> {
  int _selectedStars = 4;
  int _recommendation = 1; // 1 = Yes, 0 = No
  final TextEditingController _reviewController = TextEditingController();
  bool _isLoading = false;

  final Color kPrimaryGreen = const Color(0xFF5F8D58);

  Future<void> _submitReview() async {
    if (_reviewController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter your review")));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final notificationsViewModel = Provider.of<NotificationsViewModel>(
        context,
        listen: false,
      );

      // 1. Send to Backend
      await ApiClient.postData(
        endpoint: 'reviews',
        data: {
          'doctorId': widget.doctor.id,
          'patientName': userProvider.name,
          'rating': _selectedStars,
          'comment': _reviewController.text.trim(),
          'date': "Just now",
        },
      );

      // 2. Update local model
      widget.doctor.reviews.add(
        ReviewModel(
          patientName: userProvider.name,
          comment: _reviewController.text.trim(),
          rating: _selectedStars.toDouble(),
          date: "Just now",
        ),
      );

      // 3. Trigger Notification
      notificationsViewModel.addNotification(
        NotificationModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: "New Review Received!",
          subtitle:
              "${userProvider.name} gave you $_selectedStars stars: \"${_reviewController.text.trim()}\"",
          time: "Just now",
          icon: Icons.star_rate_rounded,
          iconColor: Colors.amber,
          bgColor: Colors.amber.withValues(alpha: 0.1),
          senderName: userProvider.name,
        ),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Review Submitted Successfully!"),
            backgroundColor: Color(0xFF2F80ED),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint("❌ Error submitting review: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to submit review: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: isDark
                ? Colors.grey[800]
                : const Color(0xFFEFEFEF),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: isDark ? Colors.white : Colors.black,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: Text(
          'My Review',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF2F3E2F),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  if (!isDark)
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .05),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  widget.doctor.image,
                  width: 140,
                  height: 140,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => Container(
                    width: 140,
                    height: 140,
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "How was your experience with",
              style: TextStyle(
                color: isDark ? Colors.grey[400] : Colors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              "DR : ${widget.doctor.name}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: isDark ? Colors.white : const Color(0xFF2F3E2F),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  onPressed: () {
                    setState(() {
                      _selectedStars = index + 1;
                    });
                  },
                  icon: Icon(
                    Icons.star,
                    color: index < _selectedStars
                        ? const Color(0xFFFFA000)
                        : (isDark ? Colors.grey[700] : Colors.grey[300]),
                    size: 32,
                  ),
                );
              }),
            ),
            const SizedBox(height: 5),
            Divider(
              thickness: 1,
              color: isDark ? Colors.grey[800] : Colors.black12,
            ),
            const SizedBox(height: 15),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Write your Review",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF2F3E2F),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                ),
              ),
              child: TextField(
                controller: _reviewController,
                maxLines: 5,
                style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                decoration: InputDecoration(
                  hintText: "Write your experience",
                  hintStyle: TextStyle(
                    color: isDark ? Colors.grey[500] : Colors.grey,
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Would you recommended Dr. ${widget.doctor.name}?",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF2F3E2F),
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Radio<int>(
                  value: 1,
                  groupValue: _recommendation,
                  activeColor: kPrimaryGreen,
                  onChanged: (val) {
                    setState(() {
                      _recommendation = val!;
                    });
                  },
                ),
                Text(
                  "Yes",
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(width: 20),
                Radio<int>(
                  value: 0,
                  groupValue: _recommendation,
                  activeColor: kPrimaryGreen,
                  onChanged: (val) {
                    setState(() {
                      _recommendation = val!;
                    });
                  },
                ),
                Text(
                  "No",
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2F80ED), Color(0xFF56CCF2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  onPressed: _isLoading ? null : _submitReview,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          "Submit Review",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
