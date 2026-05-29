import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioService _instance = AudioService._();
  factory AudioService() => _instance;
  AudioService._();

  final FlutterTts _tts = FlutterTts();
  final AudioPlayer _sfx = AudioPlayer();
  bool _ready = false;

  Future<void> init() async {
    if (_ready) return;
    await _tts.setLanguage('zh-CN');
    await _tts.setSpeechRate(0.4);
    await _tts.setVolume(0.8);
    await _tts.setPitch(1.1);
    _ready = true;
  }

  Future<void> speakChinese(String text) async {
    await _tts.setLanguage('zh-CN');
    await _tts.speak(text);
  }

  Future<void> speakEnglish(String text) async {
    await _tts.setLanguage('en-US');
    await _tts.speak(text);
  }

  Future<void> speakWord(String chinese, String english) async {
    await speakChinese(chinese);
    await Future.delayed(const Duration(milliseconds: 400));
    await speakEnglish(english);
  }

  Future<void> playCorrect() async {
    try { await _sfx.play(AssetSource('audio/correct.wav')); } catch (_) {}
  }

  Future<void> playWrong() async {
    try { await _sfx.play(AssetSource('audio/wrong.wav')); } catch (_) {}
  }

  Future<void> playCelebration() async {
    try { await _sfx.play(AssetSource('audio/celebration.wav')); } catch (_) {}
  }

  Future<void> stop() async {
    await _tts.stop();
    await _sfx.stop();
  }

  void dispose() {
    _tts.stop();
    _sfx.dispose();
  }
}
