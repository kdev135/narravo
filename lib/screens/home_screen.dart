import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:narravo/components/audio_player_bar.dart';
import 'package:narravo/components/featured_stories.dart';
import 'package:narravo/components/loading_indicator.dart';
import 'package:narravo/models/data/story.dart';
import 'package:narravo/models/ui/category_list_tile.dart';
import 'package:narravo/models/ui/home_screen_story_section.dart';
import 'package:narravo/screens/story_catalog_screen.dart';
import 'package:narravo/styles.dart';
import 'package:narravo/utils/services/fetch_stories.dart';


class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  static String routeName = '/';

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final String imageUrl =
      "https://cloud.appwrite.io/v1/storage/buckets/6703acc2003867d5a871/files/6703ad3c0001de9c75f6/view?project=66fbb1e8002a97631216&project=66fbb1e8002a97631216&mode=admin";

  List<Story> _getPopularStories(List<Document> documents) {
    final stories = documents.map((doc) => Story.fromJson(doc.data)).toList()
      ..sort((a, b) => b.likes.compareTo(a.likes));
    return stories.take(5).toList();
  }

  List<Story> _getRecommendedStories(List<Document> documents) {
    final stories = documents.map((doc) => Story.fromJson(doc.data)).toList()..shuffle();
    return stories.take(5).toList();
  }

  List<String> _getGenres(List<Document> documents) {
    final allGenres =
        documents.map((doc) => Story.fromJson(doc.data).genre).where((genre) => genre.isNotEmpty).toSet().toList();
    allGenres.sort();
    return allGenres;
  }

  List<Story> _getStoriesByGenre(List<Document> documents, String genre) {
    return documents
        .map((doc) => Story.fromJson(doc.data))
        .where((story) => story.genre.toLowerCase() == genre.toLowerCase())
        .toList();
  }

  IconData _getCategoryIcon(String category) {
    final iconMap = {
      'Sleep': Icons.bedtime,
      'For kids': Icons.child_care,
      'For adults': Icons.man,
    };
    return iconMap[category] ?? Icons.category;
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    // whenever your initialization is completed, remove the splash screen:
    FlutterNativeSplash.remove();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: getStories(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: kLoadingIndicator);
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            final documents = snapshot.data as List<Document>;
            final popularStories = _getPopularStories(documents);
            final recommendedStories = _getRecommendedStories(documents);
            final genres = _getGenres(documents);

            return Center(
              child: SizedBox(
                width: 800,
                child: ListView(
                  children: [
                    SizedBox(
                      height: 300,
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 10),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                              "Story Categories",
                              style: AppTextStyles.headline1,
                            ),
                          ),
                          SizedBox(
                            height: 50,
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: genres.length,
                              itemBuilder: (context, index) {
                                final String genre = genres[index];

                                return InkWell(
                                  onTap: () {
                                    List<Story> storyList = _getStoriesByGenre(documents, genre);
                                    Navigator.pushNamed(context, StoryCatalogScreen.routeName, arguments: storyList);
                                  },
                                  child: CategoryListTile(
                                    icon: _getCategoryIcon(genres[index]),
                                    title: genre,
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Padding(
                            padding: EdgeInsets.only(top: 12.0, bottom: 8),
                            child: Text(
                              "Popular stories",
                              style: AppTextStyles.headline2,
                            ),
                          ),
                          FeaturedStories(
                            storyList: popularStories,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 12.0, bottom: 8),
                            child: Text(
                              "Recommended for you",
                              style: AppTextStyles.headline2,
                            ),
                          ),
                          HomeScreenStorySection(stories: recommendedStories),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: const AudioPlayerBar(),
    );
  }
}