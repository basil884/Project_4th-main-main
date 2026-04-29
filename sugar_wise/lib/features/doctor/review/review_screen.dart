import 'package:flutter/material.dart';

class WriteReviewScreen extends StatefulWidget {
  final dynamic doctor; // استقبال بيانات الطبيب

  const WriteReviewScreen({super.key, required this.doctor});

  @override
  State<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends State<WriteReviewScreen> {
  int _selectedStars = 4; // القيمة الافتراضية للنجوم
  int _recommendation = 1; // 1 = Yes, 2 = No
  final TextEditingController _reviewController = TextEditingController();

  // الألوان
  final Color kPrimaryGreen = const Color(0xFF5F8D58);

  @override
  Widget build(BuildContext context) {
    // 🔥 استخراج حالة الثيم لضبط الألوان
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(
        context,
      ).scaffoldBackgroundColor, // ✅ متجاوب مع الثيم
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
            color: isDark
                ? Colors.white
                : const Color(0xFF2F3E2F), // ✅ متجاوب مع الثيم
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

            // 1. صورة الطبيب
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  if (!isDark) // الظلال في الفاتح فقط
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

            // 2. السؤال واسم الطبيب
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

            // 3. نجوم التقييم
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
                        ? Color(0xFFFFA000)
                        : (isDark
                              ? Colors.grey[700]
                              : Colors.grey[300]), // متجاوب
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

            // 4. حقل الكتابة
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
                color: Theme.of(context).cardColor, // ✅ يقرأ من الثيم
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                ),
                boxShadow: [
                  if (!isDark)
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: .05),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                ],
              ),
              child: TextField(
                controller: _reviewController,
                maxLines: 5,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                ), // لون النص المكتوب
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

            // 5. السؤال والخيارات (تم إصلاح RadioGroup واستبداله بـ Row)
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

            // ✅ الطريقة الصحيحة لعمل أزرار الراديو في فلاتر
            Row(
              children: [
                // الخيار الأول (Yes)
                // 1. الحاوية الأم التي تدير جميع الأزرار
                RadioGroup<int>(
                  groupValue: _recommendation,
                  onChanged: (val) {
                    setState(() {
                      _recommendation = val!;
                    });
                  },
                  child: Row(
                    children: [
                      Radio<int>(value: 1, activeColor: kPrimaryGreen),

                      // يمكنك إضافة الزر الثاني هنا بنفس الطريقة
                      // Radio<int>(
                      //   value: 2,
                      //   activeColor: kPrimaryGreen,
                      // ),
                    ],
                  ),
                ),
                Text(
                  "Yes",
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),

                const SizedBox(width: 20),

                // الخيار الثاني (No)
                // ✅ 1. نضع RadioGroup كحاوية رئيسية للمجموعة كلها
                RadioGroup<int>(
                  groupValue: _recommendation,
                  onChanged: (val) {
                    setState(() {
                      _recommendation = val!;
                    });
                  },

                  // ✅ 2. نضع الأداة التي ترتب الأزرار (مثل Row أو Column)
                  child: Row(
                    // أو أي أداة تستخدمها لترتيب الأزرار
                    children: [
                      // الزر الأول (القيمة 1)
                      Radio<int>(value: 0, activeColor: kPrimaryGreen),

                      // ✅ 3. الزر الثاني الخاص بك (القيمة 2) بعد تنظيفه من الخصائص القديمة
                      // Radio<int>(value: 2, activeColor: kPrimaryGreen),
                    ],
                  ),
                ),
                Text(
                  "NO",
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // 6. زر الإرسال
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Review Submitted Successfully!"),
                      backgroundColor: Color(0xFF5F8D58),
                    ),
                  );
                },
                child: const Text(
                  "Submit Review",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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
