import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart'; // ✅ استدعاء المكتبة
import 'package:sugar_wise/features/patient/language_screen/widgets/langue_item.dart';

class LanguageCard extends StatefulWidget {
  const LanguageCard({super.key});

  @override
  State<LanguageCard> createState() => _LanguageCardState();
}

class _LanguageCardState extends State<LanguageCard> {
  // ✅ نجعل اللغة المحددة افتراضياً هي لغة التطبيق الحالية
  late String selectedLanguage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    selectedLanguage = context.locale.languageCode == 'ar'
        ? 'Arabic'
        : 'English';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(25),
        border: isDark ? Border.all(color: Colors.grey.shade800) : null,
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(
                    0xff2563EB,
                  ).withValues(alpha: isDark ? 0.2 : 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/languagem/languagem.png',
                    width: 22,
                    height: 22,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "language_settings".tr(), // ✅ الترجمة السحرية
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Text(
            "select language".tr(), // ✅ الترجمة السحرية
            style: TextStyle(
              color: isDark ? Colors.grey.shade400 : Colors.grey,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 20),

          // ✅ اختصرنا القائمة لتشمل العربية والإنجليزية فقط
          Flexible(
            child: ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              children: [
                _buildLanguageOption("English", "English", "EN"),
                _buildLanguageOption("Arabic", "العربية", "AR"),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  setState(
                    () => selectedLanguage = context.locale.languageCode == 'ar'
                        ? 'Arabic'
                        : 'English',
                  );
                },
                child: Text(
                  "reset".tr(), // ✅ الترجمة السحرية
                  style: TextStyle(
                    color: isDark ? Colors.grey.shade400 : Colors.black54,
                    fontSize: 16,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  // ✅ تغيير اللغة فعلياً بسطر واحد!
                  if (selectedLanguage == "Arabic") {
                    await context.setLocale(const Locale('ar'));
                  } else {
                    await context.setLocale(const Locale('en'));
                  }

                  if (context.mounted) Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff2563EB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  "save_changes".tr(), // ✅ الترجمة السحرية
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(String name, String nativeName, String code) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedLanguage = name;
        });
      },
      child: LanguageItem(
        name: name,
        nativeName: nativeName,
        code: code,
        selected: selectedLanguage == name,
      ),
    );
  }
}
