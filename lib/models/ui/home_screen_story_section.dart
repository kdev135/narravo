import 'package:flutter/material.dart';
import 'package:narravo/models/data/story.dart';
import 'package:narravo/models/ui/story_card.dart';

class HomeScreenStorySection extends StatelessWidget {
  final List<Story> stories;

  const HomeScreenStorySection({super.key, required this.stories});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: stories.length,
        itemBuilder: (context, index) {
          return StoryCard(story: stories[index]);
        },
      ),
    );
  }
}
