import 'package:advanced_mvvm_flutter_api/data/network/failure.dart';
import 'package:dartz/dartz.dart';

abstract class BaseuseCase<In,Out>{
  Future<Either<Failure,Out>> execute(In input);
}