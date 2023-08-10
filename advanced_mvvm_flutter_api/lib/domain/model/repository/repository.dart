import 'package:advanced_mvvm_flutter_api/data/network/requstes.dart';
import 'package:advanced_mvvm_flutter_api/domain/model/models.dart';
import 'package:dartz/dartz.dart';

import '../../../data/network/failure.dart';

abstract class Repository{
  Future<Either<Failure,Authentication>> login(LoginRequest loginRequest);
  Future<Either<Failure,Authentication>> register(RegisterRequest registerRequest);
  Future<Either<Failure,HomeObject>> getHomeData();
  Future<Either<Failure,String>> forgotPassword(String email);
  Future<Either<Failure, StoreDetails>> getStoreDetails();
}