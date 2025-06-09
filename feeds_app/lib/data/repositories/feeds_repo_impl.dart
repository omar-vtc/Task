import 'package:dartz/dartz.dart';
import 'package:feeds_app/data/datasource/feed_service.dart';
import 'package:feeds_app/domain/entities/feed.dart';
import 'package:feeds_app/domain/failures/failures.dart';
import 'package:feeds_app/domain/repositories/feeds_repo.dart';

class FeedsRepoImpl implements FeedsRepo {
  final int page;
  final int limit;
  final FeedService feedService = FeedServiceImpl();

  FeedsRepoImpl({required this.page, required this.limit});
  @override
  Future<Either<Failure, List<Feed>>> getFeedsFromDataSource() async {
    final result = await feedService.fetchFeeds(page: page, limit: limit);

    return right(result);
  }
}
