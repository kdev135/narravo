import 'package:appwrite/appwrite.dart';

import '../../appwrite_client.dart';

Future<List<dynamic>> getStories() async {
  Databases databases = Databases(client);

  try {
    final response = await databases.listDocuments(
      databaseId: '66fbb32d0013b07964ac',
      collectionId: '66fbb364003063411777',
    );
    for (var story  in response.documents) {
      
    }
    
    return response.documents;
  } catch (e) {
    print('Error fetching stories: $e');
    return [];
  }
}




Future<List<dynamic>> getFilteredStories({
  String? genre,
  bool? isPremium,
  int? minLikes,
  List<String>? includeTags,
  DateTime? afterDate,
}) async {
  Databases databases = Databases(client);

  try {
    List<String> queries = [];

    if (genre != null) {
      queries.add(Query.equal('genre', genre));
    }

    if (isPremium != null) {
      queries.add(Query.equal('isPremium', isPremium));
    }

    if (minLikes != null) {
      queries.add(Query.greaterThan('likes', minLikes));
    }

    if (includeTags != null && includeTags.isNotEmpty) {
      queries.add(Query.search('tags', includeTags.join(' ')));
    }

    if (afterDate != null) {
      queries.add(Query.greaterThan('createdAt', afterDate.toIso8601String()));
    }

    
   final response = await databases.listDocuments(
      databaseId: '66fbb32d0013b07964ac',
      collectionId: '66fbb364003063411777',  queries: queries,
    );
 

    return response.documents;
  } catch (e) {
    print('Error fetching stories: $e');
    return [];
  }
}