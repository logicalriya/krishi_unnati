import 'package:flutter/material.dart';
class FarmerPageHeader extends StatelessWidget implements PreferredSizeWidget {
  const FarmerPageHeader({super.key, required this.title});

  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(52);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFD0D3D7))),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: Color(0xFF2D9B57),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.eco, color: Colors.white, size: 16),
          ),

          const SizedBox(width: 10),

          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Color(0xFF172033),
            ),
          ),
        ],
      ),
    );
  }
}
class AccessibilityModeBar extends StatelessWidget {
  const AccessibilityModeBar({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
        color: Color(0xFFF0F1F3),
        border: Border(bottom: BorderSide(color: Color(0xFFD0D3D7))),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: const Color(0xFFE1E5EA),
              borderRadius: BorderRadius.circular(7),
            ),
            child: const Icon(
              Icons.hearing,
              size: 18,
              color: Color(0xFF17375E),
            ),
          ),

          const SizedBox(width: 8),

          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Accessibility Mode',
                style: TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF26303A),
                ),
              ),
              SizedBox(height: 1),
              Text(
                'ASSISTANCE TOOLS',
                style: TextStyle(
                  fontSize: 6.5,
                  letterSpacing: .4,
                  color: Color(0xFF6C7075),
                ),
              ),
            ],
          ),

          const Spacer(),

          const Icon(
            Icons.volume_up_outlined,
            size: 16,
            color: Color(0xFF596069),
          ),

          const SizedBox(width: 5),

          Switch(
            value: value,
            onChanged: onChanged,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            activeColor: const Color(0xFF0BA951),
          ),
        ],
      ),
    );
  }
}
