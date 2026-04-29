import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_models/patient_chats_view_model.dart';

class ChatSearchBar extends StatelessWidget {
  const ChatSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<PatientChatsViewModel>(
      context,
      listen: false,
    );

    // 🔥 استخراج حالة الثيم
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(30),

        // ✅ السحر هنا: إضافة الحواف البيضاء
        border: Border.all(
          color: Colors.white, // لون الحافة
          width: 2.0, // سمك الحافة (يمكنك زيادته أو تقليله حسب رغبتك)
        ),

        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: viewModel.searchChats,
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
              decoration: InputDecoration(
                hintText: "Search",
                hintStyle: TextStyle(
                  color: isDark ? Colors.grey[500] : Colors.grey,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
              ),
            ),
          ),
          // زر البحث الدائري
          Container(
            margin: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Color(0xFF3A4B3C),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
