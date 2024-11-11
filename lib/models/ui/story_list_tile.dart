import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:narravo/models/data/story.dart';
import 'package:narravo/providers/state_providers.dart';
import 'package:narravo/screens/story_screen.dart';
import 'package:narravo/styles.dart';

class StoryListTile extends ConsumerWidget {
  final Story story;

  const StoryListTile({super.key, required this.story});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: 200,
      child: Card(
        child: SizedBox(
            width: 600,
            child: InkWell(
              onTap: () {
                ref.read(currentStoryProvider.notifier).state = story;
                Navigator.pushNamed(
                  context,
                  StoryScreen.routeName,
                );
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.only(topLeft: Radius.circular(06), bottomLeft: Radius.circular(06)),
                    child: Image.network(
                      story.thumbnailUrl,
                      height: 80,
                      width: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            story.title,
                            style: AppTextStyles.headline3,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            story.description,
                            style: AppTextStyles.captionText,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
