import 'package:feeds_app/data/repositories/feeds_repo_impl.dart';
import 'package:feeds_app/domain/entities/feed.dart';
import 'package:feeds_app/domain/entities/feed_poster.dart';

class FeedUseCase {
  Future<List<Feed>> getFeeds({int page = 1, int limit = 5}) async {
    final feedsRepo = FeedsRepoImpl(page: page, limit: limit);

    final dtos = await feedsRepo.feedService.fetchFeeds(
      page: page,
      limit: limit,
    );

    return dtos
        .map(
          (dto) => Feed(
            id: dto.id,
            url: dto.url,
            fileName: dto.fileName,
            publicId: dto.publicId,
            mediaType: dto.mediaType,
            uploadedAt: dto.uploadedAt,
            feedPoster: FeedPoster(
              id: dto.feedPoster.id,
              firstName: dto.feedPoster.firstName,
              lastName: dto.feedPoster.lastName,
            ),
          ),
        )
        .toList();
  }
}
