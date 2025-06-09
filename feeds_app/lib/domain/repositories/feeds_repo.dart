import 'package:dartz/dartz.dart';
import 'package:feeds_app/domain/entities/feed.dart';
import 'package:feeds_app/domain/failures/failures.dart';

abstract class FeedsRepo {
  Future<Either<Failure, List<Feed>>> getFeedsFromDataSource();
}
