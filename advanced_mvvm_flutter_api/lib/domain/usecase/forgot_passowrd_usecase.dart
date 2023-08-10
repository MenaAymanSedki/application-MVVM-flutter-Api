import 'package:advanced_mvvm_flutter_api/domain/model/repository/repository.dart';
import 'package:dartz/dartz.dart';

import 'package:advanced_mvvm_flutter_api/data/network/failure.dart';

import 'base_usecase.dart';

class ForgotPasswordUsecase implements BaseuseCase<String,String>{
  final Repository _repository;
  ForgotPasswordUsecase(this._repository);
  @override
  Future<Either<Failure, String>> execute(String input) async{
   return await _repository.forgotPassword(input);
  }

}