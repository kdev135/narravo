import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:narravo/components/loading_indicator.dart';
import 'package:narravo/providers/state_providers.dart';

class PlayButtonWithState extends ConsumerWidget {
  const PlayButtonWithState({
    super.key,
    required this.audioPlayer,
  });

final AudioPlayer audioPlayer;


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<PlayerState>(
      stream: audioPlayer.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final playing = playerState?.playing ?? false;
        final processingState = playerState?.processingState;

        if (processingState == ProcessingState.completed) {
          audioPlayer.seek(Duration.zero);
          audioPlayer.pause();
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (processingState == ProcessingState.loading || processingState == ProcessingState.buffering)
              Container(
                margin: const EdgeInsets.all(8.0),
                width: 64.0,
                height: 64.0,
                child: kLoadingIndicator,
              )
            else if (!playing)
              IconButton(
                  icon: const Icon(Icons.play_arrow),
                  iconSize: 64.0,
                  onPressed: () {
                    audioPlayer.play();
                    ref.read(playStatusProvider.notifier).state = playing;
                    ref.read(audioPlayerProvider.notifier).state = audioPlayer;
                  })
            else
              IconButton(
                icon: const Icon(Icons.pause),
                iconSize: 64.0,
                onPressed:() {
                  audioPlayer.pause();
                  ref.read(playStatusProvider.notifier).state = playing;
                },
              ),
          ],
        );
      },
    );
  }
}
