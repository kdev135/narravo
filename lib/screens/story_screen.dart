import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:narravo/components/audio_player_controls.dart';
import 'package:narravo/providers/state_providers.dart';
import 'package:narravo/screens/home_screen.dart';

import 'package:narravo/styles.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class StoryScreen extends ConsumerStatefulWidget {
  const StoryScreen({super.key});

  static String routeName = 'story_screen';

  @override
  ConsumerState<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends ConsumerState<StoryScreen> with RouteAware {
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
        // Fetch the shared instance of AudioPlayer
    _audioPlayer = AudioPlayerSingleton().audioPlayer;
 // Initialize the AudioPlayer instance

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      bool initialized = await _initAudioPlayer();
      if (!initialized) {
        if (mounted) {
          Navigator.of(context).popAndPushNamed(HomeScreen.routeName);
        }
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    RouteObserver<PageRoute>().subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    RouteObserver<PageRoute>().unsubscribe(this);

    // _audioPlayer.dispose(); // Dispose the AudioPlayer when the widget is destroyed
    super.dispose();
  }
Future<bool> _initAudioPlayer() async {
  final story = ref.read(currentStoryProvider);

  if (story == null) {
    return false;
  }

  try {
    // Check if the audio player is already playing this story
    final currentSource = _audioPlayer.audioSource;
    if (currentSource is UriAudioSource && currentSource.uri.toString() == story.audioUrl) {
      // The player is already set with this story, so no need to reinitialize
      return true;
    }

    // Create a MediaItem with the story's metadata
    final mediaItem = MediaItem(
      id: story.audioUrl,
      album: story.genre,
      title: story.title,
      artist: "Narravo",
      artUri: Uri.parse(story.artUrl),
      duration: Duration(seconds: story.duration),
    );

    // Set the audio source with the MediaItem as the tag
    await _audioPlayer.setAudioSource(
      AudioSource.uri(
        Uri.parse(story.audioUrl),
        tag: mediaItem,
      ),
    );

    return true;
  } catch (e) {
    print("Error initializing audio player: $e");
    return false;
  }
}


  /// Popped while playing audio
  popWhenPlaying() {
    // set the pay status as true
    ref.read(playStatusProvider.notifier).state = true;
  }

  @override
  Widget build(BuildContext context) {
    final story = ref.read(currentStoryProvider);
    

    return Scaffold(
      body: Builder(builder: (context) {
        if (story == null) {
          return const Center(
            child: Text("Go home"),
          );
        }
        return Stack(
          fit: StackFit.expand,
          children: [
            // Background image with blur
            Image.network(
              story.artUrl,
              fit: BoxFit.cover,
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
              child: Container(
                color: Colors.black.withOpacity(0.7),
              ),
            ),

            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        BackButton(
                          onPressed: () {
                            popWhenPlaying();
                            Navigator.pop(context);
                          },
                        ),
                        const Spacer(),
                        const Text(
                          "Playing now",
                          style: AppTextStyles.headline3,
                        ),
                        const Spacer(),
                      ],
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 30.0),
                            child: SizedBox(height: 250, child: Image.network(story.artUrl)),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    story.title,
                                    style: AppTextStyles.headline3.copyWith(color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.favorite_outline, color: Colors.white),
                              )
                            ],
                          ),
                         
                          AudioPlayerControls(
                            audioPlayer: _audioPlayer,
                            audioUrl: story.audioUrl,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}



class AudioPlayerSingleton {
  static final AudioPlayerSingleton _instance = AudioPlayerSingleton._internal();
  late AudioPlayer audioPlayer;

  factory AudioPlayerSingleton() {
    return _instance;
  }

  AudioPlayerSingleton._internal() {
    audioPlayer = AudioPlayer();
  }

}
