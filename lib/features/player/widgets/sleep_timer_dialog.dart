import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/providers/sleep_timer_provider.dart';

class SleepTimerDialog extends ConsumerWidget {
  const SleepTimerDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(sleepTimerProvider);

    return AlertDialog(
      backgroundColor: Colors.grey.shade900,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Icon(Icons.timer, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          const Expanded(
            child: Text('Temporizador de sueño'),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (timerState.isActive) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withAlpha(25),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.timer, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    _formatRemaining(timerState.remaining),
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => ref.read(sleepTimerProvider.notifier).cancel(),
                    child: const Text('Cancelar'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
          ..._buildOptions(context, ref),
        ],
      ),
    );
  }

  List<Widget> _buildOptions(BuildContext context, WidgetRef ref) {
    final options = [
      (SleepTimerOption.min15, '15 minutos'),
      (SleepTimerOption.min30, '30 minutos'),
      (SleepTimerOption.min45, '45 minutos'),
      (SleepTimerOption.min60, '60 minutos'),
      (SleepTimerOption.endOfSong, 'Al finalizar la canción'),
    ];

    return options.map((opt) {
      final isSelected = ref.watch(sleepTimerProvider).option == opt.$1;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: SizedBox(
          width: double.infinity,
          child: Material(
            color: isSelected
                ? Theme.of(context).colorScheme.primary.withAlpha(30)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                ref.read(sleepTimerProvider.notifier).start(opt.$1);
                Navigator.of(context).pop();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Row(
                  children: [
                    Icon(
                      opt.$1 == SleepTimerOption.endOfSong
                          ? Icons.music_note
                          : Icons.timer_outlined,
                      size: 20,
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey.shade300,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      opt.$2,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey.shade300,
                      ),
                    ),
                    if (isSelected) ...[
                      const Spacer(),
                      Icon(Icons.check, size: 18, color: Theme.of(context).colorScheme.primary),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  String _formatRemaining(Duration? d) {
    if (d == null) return 'Finalizando canción...';
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '${d.inHours > 0 ? '${d.inHours}:' : ''}$minutes:$seconds restantes';
  }
}
