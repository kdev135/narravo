import 'package:flutter/material.dart';
import 'package:narravo/models/data/story.dart';
import 'package:narravo/models/ui/story_list_tile.dart';

class FeaturedStories extends StatelessWidget {
  const FeaturedStories({super.key, required this.storyList});
  final List storyList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: storyList.length,
      itemBuilder: (context, index) {
        final Story story = storyList[index];
        return StoryListTile(
          story: story,
        );
      },
    );
  }
}
