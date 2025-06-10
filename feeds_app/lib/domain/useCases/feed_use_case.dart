import 'package:feeds_app/data/repositories/feeds_repo_impl.dart';
import 'package:feeds_app/domain/entities/feed.dart';
import 'package:feeds_app/domain/entities/feed_poster.dart';
import 'package:image_picker/image_picker.dart';

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
            likes: dto.likes,
          ),
        )
        .toList();
  }

  Future<Feed> uploadFeed(XFile file, String token) async {
    final feedsRepoImpl = FeedsRepoImpl.initial();
    final dto = await feedsRepoImpl.uploadMedia(file, token);

    return Feed(
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
      likes: dto.likes,
    );
  }

  Future<void> toggleLike(String feedId, String token) async {
    final feedsRepo = FeedsRepoImpl.initial();
    await feedsRepo.toggleLike(feedId, token);
  }

  Future<List<Feed>> getUserLikedFeeds(String token) async {
    final feedsRepo = FeedsRepoImpl.initial();

    final dtos = await feedsRepo.fetchUserLikedFeeds(token);

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
            likes: dto.likes,
          ),
        )
        .toList();
  }
}
