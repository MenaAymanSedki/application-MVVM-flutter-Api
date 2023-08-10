import 'package:advanced_mvvm_flutter_api/data/network/failure.dart';
import 'package:advanced_mvvm_flutter_api/data/network/requstes.dart';
import 'package:advanced_mvvm_flutter_api/domain/model/models.dart';
import 'package:advanced_mvvm_flutter_api/domain/model/repository/repository.dart';
import 'package:advanced_mvvm_flutter_api/domain/usecase/base_usecase.dart';
import 'package:dartz/dartz.dart';

class LoginUsecase implements BaseuseCase <LoginUseCaseInput,Authentication>{
  final Repository _repository;
  LoginUsecase(this._repository);
  @override
  Future<Either<Failure, Authentication>> execute(LoginUseCaseInput input) async{
    return await _repository.login(LoginRequest(input.email, input.password));
  }

}
class LoginUseCaseInput{
  String email;
  String password;

  LoginUseCaseInput(this.email,this.password); 

}