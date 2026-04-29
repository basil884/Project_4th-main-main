import 'package:flutter/material.dart';
import 'package:sugar_wise/features/doctor/doctor_details/models/clinic_model.dart';
import 'package:sugar_wise/features/doctor/doctor_details/models/doctor_details_model.dart';
import 'package:sugar_wise/features/doctor/doctor_details/views/doctor_details_view.dart';
import 'package:sugar_wise/features/doctor/doctor_view_patient/model/doctor_model.dart';
import 'package:sugar_wise/features/doctor/doctor_view_patient/view_models/doctors_view_modle.dart';
import 'package:sugar_wise/features/doctor/review/review_screen.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  bool isUpcoming = true;

  // 🔥 إنشاء قوائم محلية للتحكم في الحالة (State) وعمل محاكاة للبيانات
  List<DoctorModle> upcomingBookings = [];
  List<DoctorModle> pastBookings = [];

  @override
  void initState() {
    super.initState();
    // نقوم بنسخ البيانات من القائمة العامة (كمثال مبدئي)
    upcomingBookings = List.from(globalDoctorsList);
    // كنوع من المحاكاة، سنجعل الحجوزات السابقة هي نفس القائمة ولكن معكوسة
    pastBookings = List.from(globalDoctorsList.reversed);
  }

  // 🛠️ منطق إلغاء الحجز
  void _cancelBooking(DoctorModle doctor) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel Booking'),
        content: const Text(
          'Are you sure you want to cancel this appointment?',
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('No', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() {
                upcomingBookings.remove(doctor); // حذف الكارت من القائمة
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Booking Cancelled Successfully'),
                  backgroundColor: Colors.redAccent,
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text(
              'Yes, Cancel',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // 🛠️ منطق إعادة الحجز
  void _bookAgain(DoctorModle doctor) {
    setState(() {
      upcomingBookings.insert(0, doctor); // إضافة الحجز لأول قائمة القادم
      isUpcoming = true; // تحويل المستخدم تلقائياً لتبويب الحجوزات القادمة
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Successfully Booked Again!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // تحديد القائمة النشطة بناءً على التبويب
    final currentList = isUpcoming ? upcomingBookings : pastBookings;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: null,
        title: Text(
          'My Booking',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF2F3E2F),
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
              child: currentList.isEmpty
                  ? Center(
                      // حالة الـ Empty State لو القائمة فاضية
                      child: Text(
                        'No bookings found.',
                        style: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey,
                        ),
                      ),
                    )
                  : ListView.separated(
                      itemCount: currentList.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final doctor = currentList[index];

                        return BookingCard(
                          doctor: doctor,
                          isPast: !isUpcoming,
                          // 🔥 تمرير الوظائف للكارت
                          onCancel: () => _cancelBooking(doctor),
                          onBookAgain: () => _bookAgain(doctor),
                          onViewDetails: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    BookingDetailsScreen(doctor: doctor),
                              ),
                            );
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

  Widget _buildCustomTabBar(bool isDark) {
    return Container(
      height: 50,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : const Color(0xFFE2ECE2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildTabItem("Upcoming", isUpcoming, isDark),
          _buildTabItem("Past", !isUpcoming, isDark),
        ],
      ),
    );
  }

  Widget _buildTabItem(String title, bool isActive, bool isDark) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            isUpcoming = title == "Upcoming";
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isActive
                ? (isDark ? Colors.grey[700] : Colors.white)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isActive && !isDark
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
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isActive
                  ? (isDark ? Colors.white : const Color(0xFF2F3E2F))
                  : Colors.grey,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// BookingCard المحدث لدعم التوجيه لصفحتك الفعلية (DoctorDetailsView)
// ---------------------------------------------------------
class BookingCard extends StatelessWidget {
  final DoctorModle doctor; // هذا هو الموديل الأساسي القادم من الـ ListView
  final bool isPast;
  final VoidCallback onCancel;
  final VoidCallback onBookAgain;
  final VoidCallback onViewDetails;

  const BookingCard({
    super.key,
    required this.doctor,
    this.isPast = false,
    required this.onCancel,
    required this.onBookAgain,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const greenColor = Color(0xFF5B7F5B);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
        ),
        boxShadow: [
          if (!isDark)
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order ID: ${doctor.id}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isDark ? Colors.white : const Color(0xFF2F3E2F),
                ),
              ),
              if (isPast)
                const Text(
                  "Completed",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Order Date: June 25, 2025, 10:00pm - 03:00pm',
            style: TextStyle(
              color: isDark ? Colors.grey[400] : Colors.grey[500],
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),

          // 🔥 الجزء المحدث: التوجيه لصفحتك الفعلية
          GestureDetector(
            onTap: () {
              // 1. تجهيز البيانات وتحويلها لـ DoctorDetailsModel كما تفعل في زر View Profile
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
                    (doctor.biograph != null && doctor.biograph!.isNotEmpty)
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

              // 2. التوجيه لصفحتك الفعلية
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      DoctorDetailsView(doctor: selectedDoctor),
                ),
              );
            },
            behavior: HitTestBehavior.opaque,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    doctor.image,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey[300],
                    ),
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
                        color: isDark ? Colors.white : const Color(0xFF2F3E2F),
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
                            color: isDark ? Colors.white70 : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
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
                      onCancel();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark
                        ? Colors.grey[800]
                        : const Color(0xFFEBEBEB),
                    foregroundColor: isDark ? Colors.white70 : Colors.black54,
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
                child: ElevatedButton(
                  onPressed: () {
                    if (isPast) {
                      onBookAgain();
                    } else {
                      onViewDetails();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: greenColor,
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
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------
// شاشة بروفايل الطبيب (التي تظهر عند الضغط على اسمه أو صورته)
// ---------------------------------------------------------
class DoctorProfileScreen extends StatelessWidget {
  final DoctorModle doctor;

  const DoctorProfileScreen({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Profile'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.asset(
                  doctor.image,
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 120,
                    height: 120,
                    color: Colors.grey[300],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              doctor.name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF2F3E2F),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star, color: Colors.orange, size: 22),
                const SizedBox(width: 6),
                Text(
                  '${doctor.rating} Rating',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // يمكنك هنا إضافة أي تفاصيل إضافية عن الطبيب
            // مثل التخصص، نبذة عنه، أوقات العمل، إلخ.
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[900] : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'This is the full profile of the doctor. You can add specialization, biography, working hours, and location details here to make it complete.',
                style: TextStyle(height: 1.5, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// شاشة جديدة كلياً لعرض تفاصيل الحجز (View Details)
// ---------------------------------------------------------
class BookingDetailsScreen extends StatelessWidget {
  final DoctorModle doctor;

  const BookingDetailsScreen({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Booking Details'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(doctor.image),
              onBackgroundImageError: (_, _) => const Icon(Icons.person),
            ),
            const SizedBox(height: 16),
            Text(
              doctor.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Order ID: ${doctor.id}',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[800] : Colors.green[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.calendar_month, color: Color(0xFF5B7F5B)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Appointment: June 25, 2025\nTime: 10:00 PM - 03:00 PM',
                      style: TextStyle(fontSize: 16, height: 1.5),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5B7F5B),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Back to My Bookings',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
