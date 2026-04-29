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
    return Container(
      margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavItem(Icons.home_filled, 0),
          _buildNavItem(Icons.calendar_month_outlined, 1),
          _buildNavItem(Icons.health_and_safety_outlined, 2),
          _buildNavItem(Icons.chat_bubble_outline, 3),
          _buildNavItem(Icons.person_outline, 4),
          // _buildNavItem(Icons.person_outline, 4),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    bool isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: CircleAvatar(
        radius: 25,
        backgroundColor: isSelected
            ? const Color(0xFF257BF4)
            : Colors.transparent,
        child: Icon(
          icon,
          color: isSelected ? const Color(0xFFffffff) : Colors.grey,
          size: 28,
        ),
      ),
    );
  }
}
