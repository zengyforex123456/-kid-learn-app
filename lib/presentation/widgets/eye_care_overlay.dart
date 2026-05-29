import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class EyeCareOverlay extends StatefulWidget {
  final Widget child;

  const EyeCareOverlay({super.key, required this.child});

  @override
  State<EyeCareOverlay> createState() => _EyeCareOverlayState();
}

class _EyeCareOverlayState extends State<EyeCareOverlay> {
  Timer? _timer;
  bool _showRest = false;
  int _countdown = 30;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted && !_showRest) {
        setState(() { _showRest = true; _countdown = 30; });
        _runCountdown();
      }
    });
    Future.delayed(const Duration(minutes: 15), () {
      if (mounted && !_showRest) {
        setState(() { _showRest = true; _countdown = 30; });
        _runCountdown();
      }
    });
  }

  void _runCountdown() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) { timer.cancel(); return; }
      if (_countdown <= 1) {
        timer.cancel();
        setState(() { _showRest = false; _countdown = 30; });
        _startTimer();
      } else {
        setState(() => _countdown--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_showRest)
          Positioned.fill(
            child: Container(
              color: const Color(0xFFFFF8E1).withValues(alpha: 0.97),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text('👀', style: TextStyle(fontSize: 80)),
                const SizedBox(height: 24),
                const Text('休息一下吧！', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: AppColors.text)),
                const SizedBox(height: 12),
                const Text('看看远处，保护小眼睛', style: TextStyle(fontSize: 18, color: AppColors.textLight)),
                const SizedBox(height: 32),
                Text('${_countdown}s', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w700, color: AppColors.primary)),
                const SizedBox(height: 24),
                SizedBox(
                  width: 200, height: 56,
                  child: ElevatedButton(
                    onPressed: () => setState(() { _showRest = false; _countdown = 30; _startTimer(); }),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28))),
                    child: const Text('我休息好了', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                  ),
                ),
              ]),
            ),
          ),
      ],
    );
  }
}
