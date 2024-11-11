 import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:narravo/models/data/story.dart';


final currentStoryProvider = StateProvider<Story?>((ref) => null);

final playStatusProvider = StateProvider<bool>((ref) {
  return false;
});
 final audioPlayerProvider = StateProvider<AudioPlayer>((ref) {
  return AudioPlayer() ;
 });
// // Provider for AudioPlayerHandler
// final audioPlayerHandlerProvider = Provider<AudioPlayerHandler>((ref) {
//   // You might want to initialize this properly based on your app's structure
//   return audioPlayerHandlerHandler as AudioPlayerHandler;
// });