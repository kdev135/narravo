import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:narravo/components/play_button_with_state.dart';

class AudioPlayerControls extends ConsumerStatefulWidget {
  final AudioPlayer audioPlayer;
  final String audioUrl;

  const AudioPlayerControls({
    super.key,
    required this.audioPlayer,
    required this.audioUrl,
  });

  @override
  ConsumerState<AudioPlayerControls> createState() => _AudioPlayerControlsState();
}

class _AudioPlayerControlsState extends ConsumerState<AudioPlayerControls> {
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = widget.audioPlayer;
  }


@override
  void dispose() {
    
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Playback speed adjustment
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    final newSpeed = (_audioPlayer.speed - 0.10).clamp(0.5, 1.5);
                    _audioPlayer.setSpeed(newSpeed);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: StreamBuilder<double>(
                    stream: _audioPlayer.speedStream,
                    builder: (context, snapshot) {
                      final speed = snapshot.data ?? 1.0;
                      return Text('${speed.toStringAsFixed(2)}x',
                          style: Theme.of(context).textTheme.titleMedium);
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    final newSpeed = (_audioPlayer.speed + 0.10).clamp(0.5, 1.5);
                    _audioPlayer.setSpeed(newSpeed);
                  },
                ),
              ],
            ),
          ),

          // Progress indicator
          StreamBuilder<Duration?>(
            stream: _audioPlayer.durationStream,
            builder: (context, snapshot) {
              final duration = snapshot.data ?? Duration.zero;

              return StreamBuilder<Duration>(
                stream: _audioPlayer.positionStream,
                builder: (context, positionSnapshot) {
                  final position = positionSnapshot.data ?? Duration.zero;

                  var currentPlayValue =
                      (duration.inSeconds > 0) ? position.inSeconds.toDouble() / duration.inSeconds.toDouble() : 0.0;

                  return Column(
                    children: [
                      Slider.adaptive(
                        value: currentPlayValue,
                        onChanged: (value) {
                          final seekPosition = Duration(seconds: (value * duration.inSeconds).toInt());
                          _audioPlayer.seek(seekPosition);
                        },
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_formatDuration(position)),
                          Text(duration > Duration.zero ? "-${_formatDuration(duration - position)}" : '--:--'),
                        ],
                      ),
                    ],
                  );
                },
              );
            },
          ),

          const SizedBox(height: 16),
          // Playback controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.replay_10),
                onPressed: () {
                  final newPosition = _audioPlayer.position - const Duration(seconds: 10);
                  _audioPlayer.seek(newPosition);
                },
              ),
              PlayButtonWithState(audioPlayer: _audioPlayer),
              IconButton(
                icon: const Icon(Icons.forward_10),
                onPressed: () {
                  final newPosition = _audioPlayer.position + const Duration(seconds: 10);
                  _audioPlayer.seek(newPosition);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    String hours = duration.inHours > 0 ? "${twoDigits(duration.inHours)}:" : "";
    return "$hours$twoDigitMinutes:$twoDigitSeconds";
  }
}