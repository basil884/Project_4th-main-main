import 'package:flutter/material.dart';
import 'package:sugar_wise/features/doctor/doctor_details/models/clinic_model.dart';
import 'package:sugar_wise/features/doctor/doctor_details/models/doctor_details_model.dart';
import 'package:sugar_wise/features/doctor/doctor_details/views/doctor_details_view.dart';
import 'package:sugar_wise/features/doctor/doctor_view_patient/model/doctor_model.dart';

class DoctorCard extends StatelessWidget {
  final DoctorModle doctor;

  const DoctorCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image.asset(
                  doctor.image,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 180,
                      width: double.infinity,
                      color: Colors.teal.shade100,
                      child: const Icon(
                        Icons.person,
                        size: 80,
                        color: Colors.teal,
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        "${doctor.rating} (128)",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor.specialty.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Dr. ${doctor.name}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 12),

                // ✅ 1. صف العمر الجديد
                Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 18,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "${doctor.age} Years Old", // عرض العمر
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // 2. صف الموقع
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 18,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        doctor.location, // ✅ الموقع الديناميكي
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // 3. صف التوفر (Available)
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 18,
                      color: Colors.teal,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Available Today",
                      style: TextStyle(
                        color: Colors.teal,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 4. زر View Profile
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      // تجهيز بيانات الطبيب المختار وتمريرها لشاشة التفاصيل
                      final selectedDoctor = DoctorDetailsModel(
                        // ... (بياناتك السابقة كما هي)
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

                        // ✅ أضفنا هذه العيادات الافتراضية للتجربة (ستتغير لاحقاً لبيانات حقيقية)
                        clinics: [
                          ClinicModel(
                            name: "Maadi Health Center",
                            address: "Road 9, Maadi, Cairo",
                            price: "400 EGP",
                            availableDays:
                                "SUNDAY, MONDAY, TUESDAY", // كتبناها لتطابق تصميمك
                            capacity: "20 Patients / Day",
                            // ✅ أضفنا الأوقات هنا
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
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "View Profile",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
