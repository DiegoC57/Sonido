import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'player_provider.dart';

enum SleepTimerOption { min15, min30, min45, min60, endOfSong }

class SleepTimerState {
  final bool isActive;
  final Duration? remaining;
  final SleepTimerOption? option;

  const SleepTimerState({
    this.isActive = false,
    this.remaining,
    this.option,
  });

  SleepTimerState copyWith({
    bool? isActive,
    Duration? remaining,
    SleepTimerOption? option,
  }) {
    return SleepTimerState(
      isActive: isActive ?? this.isActive,
      remaining: remaining ?? this.remaining,
      option: option ?? this.option,
    );
  }
}

class SleepTimerNotifier extends Notifier<SleepTimerState> {
  Timer? _timer;
  Timer? _countdownTimer;
  StreamSubscription? _songEndSubscription;

  @override
  SleepTimerState build() => const SleepTimerState();

  void start(SleepTimerOption option) {
    cancel();
    final duration = _durationForOption(option);
    if (duration == null) {
      state = SleepTimerState(isActive: true, option: option);
      _listenForSongEnd();
      return;
    }
    _timer = Timer(duration, _onComplete);
    _startCountdown(duration);
    state = SleepTimerState(isActive: true, remaining: duration, option: option);
  }

  void cancel() {
    _timer?.cancel();
    _countdownTimer?.cancel();
    _songEndSubscription?.cancel();
    _timer = null;
    _countdownTimer = null;
    _songEndSubscription = null;
    state = const SleepTimerState();
  }

  Duration? _durationForOption(SleepTimerOption option) {
    switch (option) {
      case SleepTimerOption.min15:
        return const Duration(minutes: 15);
      case SleepTimerOption.min30:
        return const Duration(minutes: 30);
      case SleepTimerOption.min45:
        return const Duration(minutes: 45);
      case SleepTimerOption.min60:
        return const Duration(minutes: 60);
      case SleepTimerOption.endOfSong:
        return null;
    }
  }

  void _onComplete() {
    _pausePlayback();
    cancel();
  }

  void _listenForSongEnd() {
    final handler = ref.read(audioHandlerProvider).asData?.value;
    if (handler == null) return;
    _songEndSubscription = handler.playbackState.listen((pState) {
      if (pState.processingState == AudioProcessingState.completed) {
        _pausePlayback();
        cancel();
      }
    });
  }

  void _pausePlayback() {
    final handler = ref.read(audioHandlerProvider).asData?.value;
    handler?.pause();
  }

  void _startCountdown(Duration duration) {
    _countdownTimer?.cancel();
    var remaining = duration;
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      remaining = remaining - const Duration(seconds: 1);
      if (remaining.isNegative) remaining = Duration.zero;
      state = state.copyWith(remaining: remaining);
    });
  }

}

final sleepTimerProvider =
    NotifierProvider<SleepTimerNotifier, SleepTimerState>(
  SleepTimerNotifier.new,
);
