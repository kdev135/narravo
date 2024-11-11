import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:narravo/screens/home_screen.dart';
import 'package:narravo/screens/story_catalog_screen.dart';
import 'package:narravo/screens/story_screen.dart';

import 'appwrite_client.dart';

void main() async {
 WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
// Local db setup

  final appWriteURL = dotenv.env['ENDPOINT']!;
  final projectId = dotenv.env['PROJECT_ID']!;
  // secure storage for auth session management
  await dotenv.load(fileName: ".env");
  // Appwrite backend setup
  client
      .setEndpoint(appWriteURL)
      .setProject(projectId)
      .setSelfSigned(status: true); // For self signed certificates, only use for development




  // just audio package initialization
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.kdev135.narravo.narravo',
    androidNotificationChannelName: 'Narravo',
    androidNotificationOngoing: true,
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'narravo',
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      themeMode: ThemeMode.dark, // Set the default theme mode
      initialRoute: HomeScreen.routeName,
      routes: {
        HomeScreen.routeName: (context) => const HomeScreen(),
        StoryScreen.routeName: (context) => const StoryScreen(),
        StoryCatalogScreen.routeName: (context) => const StoryCatalogScreen()
      },
    );
  }
}

class DrawerItem {
  final IconData icon;
  final String title;

  DrawerItem({required this.icon, required this.title});
}

ThemeData _buildTheme(Brightness brightness) {
  var baseTheme = ThemeData(brightness: brightness);

  // Define your color scheme
  const primaryColor = Color.fromARGB(255, 2, 103, 119);
  var colorScheme = ColorScheme.fromSeed(
    seedColor: primaryColor,
    brightness: brightness,
  );

  // Use DM Sans as the default font
  var textTheme = GoogleFonts.dmSansTextTheme(baseTheme.textTheme);

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      elevation: 0,
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: colorScheme.onPrimary,
        backgroundColor: colorScheme.primary,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      filled: true,
      fillColor: colorScheme.surface,
    ),
  );
}
