import 'package:dartz/dartz.dart';
import 'package:feeds_app/data/datasource/feed_service.dart';
import 'package:feeds_app/domain/entities/feed.dart';
import 'package:feeds_app/domain/failures/failures.dart';
import 'package:feeds_app/domain/repositories/feeds_repo.dart';
import 'package:cross_file/cross_file.dart';

class FeedsRepoImpl implements FeedsRepo {
  final int page;
  final int limit;
  final FeedService feedService = FeedServiceImpl();

  FeedsRepoImpl({required this.page, required this.limit});

  FeedsRepoImpl.initial() : page = 1, limit = 10;
  @override
  Future<Either<Failure, List<Feed>>> getFeedsFromDataSource() async {
    final result = await feedService.fetchFeeds(page: page, limit: limit);

    return right(result);
  }

  @override
  Future<Feed> uploadMedia(XFile file, String token) async {
    return feedService.uploadMediaToDatasource(file, token);
  }

  @override
  Future<void> toggleLike(String feedId, String token) {
    return feedService.toggleLike(feedId, token);
  }

  @override
  Future<List<Feed>> fetchUserLikedFeeds(String token) {
    return feedService.fetchLikedFeeds(token);
  }
}
