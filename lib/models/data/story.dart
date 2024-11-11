class Story {
  String id; // ObjectBox uses integers for IDs
  String title;
  String storyText;
  String artUrl;
  String description;
  String genre;
  int likes;
  int duration; // ObjectBox doesn't support `Duration` directly

  DateTime createdAt;
  List<String> tags;
  int shares;
  String thumbnailUrl;
  String audioUrl;
  bool isPremium;

  Story({
    required this.id,
    required this.title,
    required this.storyText,
    required this.artUrl,
    required this.description,
    required this.genre,
    required this.likes,
    required this.duration,
    required this.createdAt,
    this.tags = const [],
    this.shares = 0,
    this.thumbnailUrl = '',
    this.audioUrl = '',
    this.isPremium = false,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json['id'],
      title: json['title'],
      storyText: json['storyText'],
      artUrl: json['artUrl'],
      description: json['description'],
      genre: json['genre'],
      likes: json['likes'],
      duration: json['duration'],
      createdAt: DateTime.parse(json['createdAt']),
      tags: List<String>.from(json['tags']),
      shares: json['shares'],
      thumbnailUrl: json['thumbnailUrl'],
      audioUrl: json['audioUrl'],
      isPremium: json['isPremium'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'storyText': storyText,
      'artUrl': artUrl,
      'description': description,
      'genre': genre,
      'likes': likes,
      'duration': duration,
      'createdAt': createdAt.toIso8601String(),
      'tags': tags,
      'shares': shares,
      'thumbnailUrl': thumbnailUrl,
      'audioUrl': audioUrl,
      'isPremium': isPremium,
    };
  }

  @override
  String toString() {
    return 'Story{id: $id, title: $title, storyText: $storyText, artUrl: $artUrl, description: $description, genre: $genre, likes: $likes, duration: $duration, createdAt: $createdAt, tags: $tags, shares: $shares, thumbnailUrl: $thumbnailUrl, audioUrl: $audioUrl, isPremium: $isPremium}';
  }
}
