// import 'package:just_audio/just_audio.dart';
// import 'package:just_audio_background/just_audio_background.dart';

// /// Handle audio playback using the AudioPlayer package.
// class AudioPlayerHandler {
//   // Initialize an instance of AudioPlayer.
//   final _player = AudioPlayer();

//   AudioPlayerHandler() {
//     // Listen to playback events and broadcast the state.
//     _player.playbackEventStream.listen(_broadcastState);

//     // Set the loop mode to off by default.
//     _player.setLoopMode(LoopMode.off);
//   }

//   /// Returns a Future that completes when the audio starts playing.
//   Future<void> play() => _player.play();

//   /// Returns a Future that completes when the audio is paused.
//   Future<void> pause() => _player.pause();

//   /// Returns a Future that completes when the audio is seeked. Takes [position] The position to seek to.
//   Future<void> seek(Duration position) => _player.seek(position);

//   /// Returns a Future that completes when the audio is stopped.
//   Future<void> stop() => _player.stop();

//   /// Set the audio source from a URL and optional metadata.
//   /// [url] The URL of the audio.
//   /// [title] The title of the audio.
//   /// [artist] The artist of the audio (optional).
//   /// [album] The album of the audio (optional).
//   /// [artUri] The URI of the album art (optional).
//   /// Returns a Future that completes when the audio source is set.
//   Future<void> setUrl(
//     String url, {
//     required String title,
//     String? artist,
//     String? album,
//     String? artUri,
//   }) async {
//     await _player.setAudioSource(
//       AudioSource.uri(
//         Uri.parse(url),
//         tag: MediaItem(
//           id: url,
//           title: title,
//           artist: artist,
//           album: album,
//           artUri: artUri != null ? Uri.parse(artUri) : null,
//         ),
//       ),
//     );
//   }

//   /// Get the stream of playback events. Returns a Stream of PlaybackEvent objects.
//   Stream<PlaybackEvent> get playbackEventStream => _player.playbackEventStream;

//   /// Get the stream of player states. Returns a Stream of PlayerState objects.
//   Stream<PlayerState> get playerStateStream => _player.playerStateStream;

//   /// Broadcast the playback state when an event occurs. [event] The PlaybackEvent that occurred.
//   void _broadcastState(PlaybackEvent event) {
//     // Currently empty, but can be used to notify listeners of state changes.
//   }

//   /// Dispose of the audio player when no longer needed.
//   void dispose() {
//     _player.dispose();
//   }
// }
