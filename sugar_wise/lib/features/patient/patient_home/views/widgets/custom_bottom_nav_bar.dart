import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(
          color: isDark ? Colors.grey[800]! : Colors.transparent,
          width: 1,
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: const Color(0xFF2F80ED).withValues(alpha: 0.15),
              blurRadius: 25,
              offset: const Offset(0, 10),
            ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavItem(Icons.home_filled, 0, isDark),
          _buildNavItem(Icons.calendar_month_outlined, 1, isDark),
          _buildNavItem(Icons.grid_view_rounded, 2, isDark),
          _buildNavItem(Icons.chat_bubble_outline, 3, isDark),
          _buildNavItem(Icons.personal_injury_outlined, 4, isDark),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index, bool isDark) {
    bool isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFF2F80ED), Color(0xFF56CCF2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : Colors.transparent,
        ),
        child: Icon(
          icon,
          color: isSelected
              ? Colors.white
              : (isDark ? Colors.grey[500] : Colors.grey[400]),
          size: 26,
        ),
      ),
    );
  }
}
