import 'package:flutter/material.dart';
import 'package:narravo/models/ui/story_list_tile.dart';

import '../models/data/story.dart';


class StoryCatalogScreen extends StatelessWidget {
  static const routeName = '/story-catalog';

  const StoryCatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieve the list of stories passed as an argument
    final List<Story> storyList = ModalRoute.of(context)!.settings.arguments as List<Story>;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Story Catalog'),
      ),
      body: ListView.builder(
        itemCount: storyList.length,
        itemBuilder: (context, index) {
          final story = storyList[index];
          return StoryListTile(story: story);
        },
      ),
    );
  }
}
