import 'dart:convert';

import 'package:feeds_app/data/models/feed_dto.dart';
import 'package:http/http.dart' as http;

abstract class FeedService {
  /// return [feedDto].
  Future<List<FeedDto>> fetchFeeds({required int page, required int limit});
}

class FeedServiceImpl implements FeedService {
  final client = http.Client();
  final String baseUrl = 'http://localhost:8080/api/media/feed';

  @override
  Future<List<FeedDto>> fetchFeeds({int page = 1, int limit = 5}) async {
    final uri = Uri.parse('$baseUrl?page=$page&limit=$limit');
    final response = await client.get(uri);
    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      final List data = jsonBody['data'];
      return data.map((item) => FeedDto.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load feeds: ${response.statusCode}');
    }
  }
}
