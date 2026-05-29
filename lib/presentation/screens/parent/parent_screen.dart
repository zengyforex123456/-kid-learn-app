import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../providers/game_provider.dart';
import '../../../domain/entities/user_settings.dart';

class ParentGateScreen extends ConsumerStatefulWidget {
  const ParentGateScreen({super.key});

  @override
  ConsumerState<ParentGateScreen> createState() => _ParentGateScreenState();
}

class _ParentGateScreenState extends ConsumerState<ParentGateScreen> {
  String _pin = '';
  bool _unlocked = false;

  void _enterDigit(String d) {
    if (_pin.length >= 4) return;
    setState(() => _pin += d);
    if (_pin.length == 4 && _pin == '1234') {
      setState(() => _unlocked = true);
    } else if (_pin.length == 4) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) setState(() => _pin = '');
      });
    }
  }

  void _clearPin() {
    if (_pin.isNotEmpty) setState(() => _pin = _pin.substring(0, _pin.length - 1));
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(children: [
            const SizedBox(height: 12),
            Row(children: [
              GestureDetector(child: const Text('←', style: TextStyle(fontSize: 28)), onTap: () => Navigator.pop(context)),
              const SizedBox(width: 12),
              const Text('👨‍👩‍👧 家长中心', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.text)),
            ]),
            const SizedBox(height: 20),
            if (!_unlocked) _buildGate(),
            if (_unlocked) _buildPanel(settings),
          ]),
        ),
      ),
    );
  }

  Widget _buildGate() {
    return Expanded(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text('🔐', style: TextStyle(fontSize: 48)),
        const SizedBox(height: 16),
        const Text('请输入家长密码', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.text)),
        const SizedBox(height: 24),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(4, (i) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              width: 16, height: 16,
              decoration: BoxDecoration(shape: BoxShape.circle, color: i < _pin.length ? AppColors.primary : Colors.grey.shade300),
            ))),
        const SizedBox(height: 32),
        SizedBox(
          width: 300,
          child: GridView.count(
            crossAxisCount: 3, shrinkWrap: true, mainAxisSpacing: 12, crossAxisSpacing: 12,
            children: [
              ...'123456789'.split('').map((d) => _NumKey(label: d, onTap: () => _enterDigit(d))),
              const SizedBox(),
              _NumKey(label: '0', onTap: () => _enterDigit('0')),
              _NumKey(label: '⌫', onTap: _clearPin),
            ],
          ),
        ),
      ]),
    );
  }

  Widget _buildPanel(UserSettings settings) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(children: [
          _SettingRow(label: '📊 已学汉字', value: '24 / 50'),
          _SettingRow(label: '📊 已学英文', value: '18 / 50'),
          _SettingRow(label: '🎮 游戏次数', value: '37 次'),
          _SettingRow(label: '⏱️ 每日时长限制', value: '${settings.dailyLimitMinutes} 分钟'),
          _SettingSwitch(label: '👁️ 护眼模式', value: settings.eyeCareEnabled, onChanged: (v) => ref.read(settingsProvider.notifier).update(settings.copyWith(eyeCareEnabled: v))),
          _SettingSwitch(label: '🔊 背景音乐', value: settings.bgMusicEnabled, onChanged: (v) => ref.read(settingsProvider.notifier).update(settings.copyWith(bgMusicEnabled: v))),
          _SettingSwitch(label: '🔔 每日学习提醒', value: settings.reminderEnabled, onChanged: (v) => ref.read(settingsProvider.notifier).update(settings.copyWith(reminderEnabled: v))),
          if (settings.reminderEnabled)
            _ReminderTimePicker(
              time: settings.reminderTime,
              onChanged: (t) => ref.read(settingsProvider.notifier).update(settings.copyWith(reminderTime: t)),
            ),
          _SettingSwitch(label: '📵 离线模式', value: settings.offlineMode, onChanged: (v) => ref.read(settingsProvider.notifier).update(settings.copyWith(offlineMode: v))),
        ]),
      ),
    );
  }
}

class _NumKey extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _NumKey({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 72, height: 72,
        decoration: BoxDecoration(color: AppColors.card, shape: BoxShape.circle, boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 8)]),
        alignment: Alignment.center,
        child: Text(label, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.text)),
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  final String label;
  final String value;
  const _SettingRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFF0E0D0)))),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.text)),
      ]),
    );
  }
}

class _SettingSwitch extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _SettingSwitch({required this.label, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFF0E0D0)))),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        GestureDetector(
          onTap: () => onChanged(!value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 52, height: 28,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: value ? AppColors.accent : Colors.grey.shade400),
            alignment: value ? Alignment.centerRight : Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Container(width: 24, height: 24, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white)),
          ),
        ),
      ]),
    );
  }
}

class _ReminderTimePicker extends StatelessWidget {
  final String time;
  final ValueChanged<String> onChanged;
  const _ReminderTimePicker({required this.time, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF0E0D0))),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Text('⏰ 提醒时间', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        GestureDetector(
          onTap: () async {
            final parts = time.split(':');
            final picked = await showTimePicker(
              context: context,
              initialTime: TimeOfDay(
                hour: int.tryParse(parts[0]) ?? 19,
                minute: int.tryParse(parts[1]) ?? 0,
              ),
            );
            if (picked != null) {
              onChanged('${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}');
            }
          },
          child: Text(time, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.primary)),
        ),
      ]),
    );
  }
}
