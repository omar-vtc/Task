import 'package:dartz/dartz.dart';
import 'package:feeds_app/domain/entities/feed.dart';
import 'package:feeds_app/domain/failures/failures.dart';
import 'package:image_picker/image_picker.dart';

abstract class FeedsRepo {
  Future<Either<Failure, List<Feed>>> getFeedsFromDataSource();

  Future<void> uploadMedia(XFile file);
}
