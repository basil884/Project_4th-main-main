import 'package:flutter/material.dart';
import 'package:sugar_wise/features/auth/signin/views/login_view.dart';

class ItemWelcome extends StatelessWidget {
  const ItemWelcome({
    super.key,
    required this.urlimage,
    required this.textfirst,
    required this.description,
    required this.textbutton,
    required this.movescreen,
  });

  final String urlimage;
  final String textfirst;
  final String description;
  final String textbutton;
  final Widget movescreen;

  @override
  Widget build(BuildContext context) {
    // 🔥 استخراج حالة الثيم لضبط الألوان
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(
        context,
      ).scaffoldBackgroundColor, // ✅ خلفية متجاوبة
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0, // ✅ إزالة الظل من الـ AppBar ليكون مسطحاً تماماً
        title: Text(
          ('Sugar Wise'),
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black, // ✅ لون النص متجاوب
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // محتوى الصفحة
            Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0, right: 20.0),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => const LoginView(),
                          ),
                        );
                      },
                      child: Text(
                        ('Skip'),
                        style: TextStyle(
                          color: isDark
                              ? Colors.grey[400]
                              : Colors.grey[600], // ✅ لون زر التخطي متجاوب
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  // يسمح للعمود بالامتداد لملء المساحة المتبقية بعد زر Skip
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // الصورة
                        Image.asset(
                          urlimage,
                          fit: BoxFit.contain,
                          height: MediaQuery.of(context).size.height * 0.45,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.image_not_supported_outlined,
                              size: 100,
                              color: isDark
                                  ? Colors.grey[700]
                                  : Colors.grey[300],
                            );
                          },
                        ),
                        const SizedBox(height: 30),
                        // العنوان
                        Text(
                          textfirst,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? Colors.white
                                : const Color(
                                    0xFF333333,
                                  ), // ✅ لون العنوان متجاوب
                          ),
                        ),
                        const SizedBox(height: 15),
                        // الوصف
                        Text(
                          description,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark
                                ? Colors.grey[400]
                                : const Color(0xFF757575), // ✅ لون الوصف متجاوب
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 100), // مسافة من الأسفل للزر
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // الزر السفلي (Next)
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (ctx) => movescreen),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(
                        0xFF10B981,
                      ), // ✅ لون أخضر مميز ثابت
                      foregroundColor:
                          Colors.white, // ✅ تأكيد أن لون النص أبيض دائماً
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      (textbutton),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
