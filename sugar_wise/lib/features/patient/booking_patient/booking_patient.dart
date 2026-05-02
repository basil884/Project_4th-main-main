import 'package:flutter/material.dart';
import 'package:sugar_wise/features/doctor/doctor_view_patient/model/doctor_model.dart';
import 'package:sugar_wise/features/doctor/doctor_view_patient/view_models/doctors_view_modle.dart';
import 'package:sugar_wise/features/patient/review/review_screen.dart';
import 'package:sugar_wise/features/doctor/doctor_details/models/clinic_model.dart';
import 'package:sugar_wise/features/doctor/doctor_details/models/doctor_details_model.dart';
import 'package:sugar_wise/features/doctor/doctor_details/views/doctor_details_view.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  bool isUpcoming = true;

  @override
  Widget build(BuildContext context) {
    // 🔥 استخراج حالة الثيم الحالي
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(
        context,
      ).scaffoldBackgroundColor, // ✅ خلفية ديناميكية
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: null,
        title: Text(
          ('My Booking'),
          style: TextStyle(
            color: isDark
                ? Colors.white
                : const Color(0xFF2F3E2F), // ✅ لون العنوان يتغير
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildCustomTabBar(isDark),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemCount: globalDoctorsList.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final doctor = globalDoctorsList[index];

                  // التعديل 1: تمرير كائن الطبيب بالكامل
                  return BookingCard(
                    doctor: doctor,
                    isPast: !isUpcoming,
                    onCancel: () {
                      setState(() {
                        globalDoctorsList.remove(doctor);
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ تمرير حالة الثيم (isDark) لتعديل ألوان التبويبات
  Widget _buildCustomTabBar(bool isDark) {
    return Container(
      height: 50,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.grey[900]
            : const Color(0xFFE2ECE2), // ✅ خلفية التبويبات
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildTabItem(("Upcoming"), isUpcoming, isDark),
          _buildTabItem(("Past"), !isUpcoming, isDark),
        ],
      ),
    );
  }

  Widget _buildTabItem(String title, bool isActive, bool isDark) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            isUpcoming = title == ("Upcoming");
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isActive
                ? (isDark
                      ? Colors.grey[700]
                      : Colors.white) // ✅ لون التبويب النشط
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow:
                isActive &&
                    !isDark // ✅ إخفاء الظل في الوضع المظلم
                ? [
                    const BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          alignment: Alignment.center,
          child: Text(
            (title),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isActive
                  ? (isDark
                        ? Colors.white
                        : const Color(0xFF2F3E2F)) // ✅ لون النص النشط
                  : Colors.grey, // لون النص غير النشط
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// BookingCard المعدل لاستقبال كائن الطبيب والتجاوب مع الثيم
// ---------------------------------------------------------
class BookingCard extends StatelessWidget {
  final DoctorModle doctor;
  final bool isPast;
  final VoidCallback? onCancel;

  const BookingCard({
    super.key,
    required this.doctor,
    this.isPast = false,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    // 🔥 استخراج حالة الثيم لضبط ألوان الكارد
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const greenColor = Color(0xFF5B7F5B);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor, // ✅ الكارد يقرأ لونه من الثيم
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
        ), // ✅ إطار متكيف
        boxShadow: [
          if (!isDark) // ✅ الظلال تظهر فقط في الوضع الفاتح
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order ID
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${("Order ID")}: ${doctor.id}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isDark
                      ? Colors.white
                      : const Color(0xFF2F3E2F), // ✅ لون النص
                ),
              ),
              if (isPast)
                Text(
                  ("Completed"),
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),

          Text(
            ('Order Date: June 25, 2025, 10:00pm - 03:00pm'),
            style: TextStyle(
              color: isDark
                  ? Colors.grey[400]
                  : Colors.grey[500], // ✅ تباين أفضل للتاريخ
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),

          // تفاصيل الطبيب
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  doctor.image,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(width: 60, height: 60, color: Colors.grey[300]),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: isDark
                          ? Colors.white
                          : const Color(0xFF2F3E2F), // ✅ لون اسم الطبيب
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        '${doctor.rating}',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? Colors.white70
                              : Colors.black87, // ✅ لون التقييم
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // الأزرار
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (isPast) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              WriteReviewScreen(doctor: doctor),
                        ),
                      );
                    } else {
                      // كود الإلغاء الحقيقي
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Cancel Booking"),
                          content: const Text(
                            "Are you sure you want to cancel this booking?",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("No"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // إغلاق النافذة
                                if (onCancel != null) onCancel!(); // حذف الحجز
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Booking Cancelled successfully!",
                                    ),
                                    backgroundColor: Colors.redAccent,
                                  ),
                                );
                              },
                              child: const Text(
                                "Yes, Cancel",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark
                        ? Colors.grey[800]
                        : const Color(0xFFEBEBEB), // ✅ لون زر الإلغاء
                    foregroundColor: isDark
                        ? Colors.white70
                        : Colors.black54, // ✅ لون نص زر الإلغاء
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(isPast ? 'Write A Review' : 'Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2F80ED), Color(0xFF56CCF2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      if (!isPast) {
                        final selectedDoctor = DoctorDetailsModel(
                          name: doctor.name,
                          specialty: doctor.specialty,
                          jobTitle: doctor.workplace.isEmpty
                              ? 'Doctor'
                              : doctor.workplace,
                          age: doctor.age,
                          imagePath: doctor.image,
                          rating: doctor.rating,
                          experienceYears: doctor.expYears,
                          biography:
                              (doctor.biograph != null &&
                                  doctor.biograph!.isNotEmpty)
                              ? doctor.biograph!
                              : "${doctor.name} is a ${doctor.workplace.isEmpty ? 'Doctor' : doctor.workplace} specializing in ${doctor.specialty} with ${doctor.expYears} years of experience.",
                          reviewsCount: 128,
                          patientsCount: "1k+",
                          clinics: [
                            ClinicModel(
                              name: "Maadi Health Center",
                              address: "Road 9, Maadi, Cairo",
                              price: "400 EGP",
                              availableDays: "SUNDAY, MONDAY, TUESDAY",
                              capacity: "20 Patients / Day",
                              availableTimes: [
                                "10:00 AM",
                                "11:30 AM",
                                "01:00 PM",
                                "04:00 PM",
                                "05:30 PM",
                                "07:00 PM",
                              ],
                              clinics: [],
                            ),
                            ClinicModel(
                              name: "Nile Care Hospital",
                              address: "Corniche El Nil, Maadi",
                              price: "550 EGP",
                              availableDays: "MONDAY, WEDNESDAY, SATURDAY",
                              capacity: "20 Patients / Day",
                              availableTimes: [
                                "09:00 AM",
                                "12:00 PM",
                                "03:00 PM",
                                "06:00 PM",
                              ],
                              clinics: [],
                            ),
                          ],
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DoctorDetailsView(doctor: selectedDoctor),
                          ),
                        );
                      } else {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) {
                            final isDarkBottomSheet =
                                Theme.of(context).brightness == Brightness.dark;
                            return Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: isDarkBottomSheet
                                    ? Colors.grey[900]
                                    : Colors.white,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(24),
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Container(
                                      width: 40,
                                      height: 5,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade400,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    "Book Appointment Again",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: isDarkBottomSheet
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Select a quick slot for Dr. ${doctor.name}",
                                    style: TextStyle(
                                      color: isDarkBottomSheet
                                          ? Colors.grey.shade400
                                          : Colors.grey.shade600,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  Wrap(
                                    spacing: 12,
                                    runSpacing: 12,
                                    children:
                                        [
                                          "Tomorrow, 10:00 AM",
                                          "Tomorrow, 02:00 PM",
                                          "Wed, 11:30 AM",
                                        ].map((slot) {
                                          return InkWell(
                                            onTap: () {
                                              Navigator.pop(
                                                context,
                                              ); // Close sheet
                                              // Show success dialog
                                              showDialog(
                                                context: context,
                                                builder: (context) => AlertDialog(
                                                  backgroundColor:
                                                      isDarkBottomSheet
                                                      ? Colors.grey[850]
                                                      : Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          20,
                                                        ),
                                                  ),
                                                  title: const Column(
                                                    children: [
                                                      Icon(
                                                        Icons.check_circle,
                                                        color: Colors.green,
                                                        size: 60,
                                                      ),
                                                      SizedBox(height: 16),
                                                      Text(
                                                        "Booking Confirmed!",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  content: Text(
                                                    "Your appointment with Dr. ${doctor.name} is successfully booked for $slot.",
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      height: 1.5,
                                                    ),
                                                  ),
                                                  actions: [
                                                    Center(
                                                      child: SizedBox(
                                                        width: double.infinity,
                                                        height: 45,
                                                        child: ElevatedButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                context,
                                                              ),
                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor:
                                                                const Color(
                                                                  0xFF2F80ED,
                                                                ),
                                                            foregroundColor:
                                                                Colors.white,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    12,
                                                                  ),
                                                            ),
                                                          ),
                                                          child: const Text(
                                                            "Awesome!",
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 12,
                                                  ),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: const Color(
                                                    0xFF2F80ED,
                                                  ).withValues(alpha: 0.5),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                color: const Color(
                                                  0xFF2F80ED,
                                                ).withValues(alpha: 0.05),
                                              ),
                                              child: Text(
                                                slot,
                                                style: const TextStyle(
                                                  color: Color(0xFF2F80ED),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                  ),
                                  const SizedBox(height: 30),
                                ],
                              ),
                            );
                          },
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(isPast ? 'Book Again' : 'View Details'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
