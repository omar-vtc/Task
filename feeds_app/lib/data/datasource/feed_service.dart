import 'dart:convert';

import 'package:feeds_app/data/models/feed_dto.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

abstract class FeedService {
  /// return [feedDto].
  Future<List<FeedDto>> fetchFeeds({required int page, required int limit});
  Future<FeedDto> uploadMediaToDatasource(XFile file, String token);
  Future<void> toggleLike(String feedId, String token);
  Future<List<FeedDto>> fetchLikedFeeds(String token);
}

class FeedServiceImpl implements FeedService {
  final client = http.Client();
  final String baseUrl = 'http://localhost:8080/api/media';

  @override
  Future<List<FeedDto>> fetchFeeds({int page = 1, int limit = 5}) async {
    final uri = Uri.parse('$baseUrl/feed?page=$page&limit=$limit');
    final response = await client.get(uri);
    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      final List data = jsonBody['data'];
      return data.map((item) => FeedDto.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load feeds: ${response.statusCode}');
    }
  }

  @override
  Future<FeedDto> uploadMediaToDatasource(XFile file, String token) async {
    final uri = Uri.parse('$baseUrl/upload');
    final request = http.MultipartRequest('POST', uri);

    request.headers['Authorization'] = 'Bearer $token';

    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    final streamedResponse = await request.send();

    if (streamedResponse.statusCode != 201) {
      throw Exception('Failed to upload');
    }

    final responseBody = await streamedResponse.stream.bytesToString();
    final jsonData = jsonDecode(responseBody);

    return FeedDto.fromJson(jsonData);
  }

  @override
  Future<void> toggleLike(String feedId, String token) async {
    final uri = Uri.parse('$baseUrl/feed/$feedId/like');

    final response = await client.post(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to like/unlike feed');
    }
  }

  @override
  Future<List<FeedDto>> fetchLikedFeeds(String token) async {
    final response = await client.get(
      Uri.parse('$baseUrl/feed/liked'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      final List data = jsonBody['data'];
      return data.map((item) => FeedDto.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load feeds: ${response.statusCode}');
    }
  }
}
