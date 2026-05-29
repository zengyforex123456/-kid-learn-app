import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class GameCard extends StatelessWidget {
  final String emoji;
  final String label;
  final String stars;
  final Color borderColor;
  final VoidCallback onTap;
  final bool disabled;

  const GameCard({
    super.key,
    required this.emoji,
    required this.label,
    required this.stars,
    required this.borderColor,
    required this.onTap,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: AnimatedScale(
        scale: 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          decoration: BoxDecoration(
            color: disabled ? Colors.grey.shade200 : AppColors.card,
            borderRadius: BorderRadius.circular(AppColors.radius),
            border: Border.all(color: disabled ? Colors.grey.shade300 : borderColor, width: 3),
            boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 16, offset: const Offset(0, 4))],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(emoji, style: const TextStyle(fontSize: 52)),
            const SizedBox(height: 10),
            Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.text)),
            const SizedBox(height: 4),
            Text(stars, style: const TextStyle(fontSize: 14, color: AppColors.star)),
          ]),
        ),
      ),
    );
  }
}

class RewardEffect extends StatefulWidget {
  final Widget child;

  const RewardEffect({super.key, required this.child});

  @override
  State<RewardEffect> createState() => _RewardEffectState();
}

class _RewardEffectState extends State<RewardEffect> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
  late final Animation<double> _scale = Tween(begin: 0.5, end: 1.0).animate(CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut));
  late final Animation<double> _opacity = Tween(begin: 0.0, end: 1.0).animate(_ctrl);

  @override
  void initState() {
    super.initState();
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, child) => Opacity(opacity: _opacity.value, child: Transform.scale(scale: _scale.value, child: child)),
      child: widget.child,
    );
  }
}
