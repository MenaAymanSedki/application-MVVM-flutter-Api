import 'package:advanced_mvvm_flutter_api/data/network/failure.dart';
import 'package:advanced_mvvm_flutter_api/data/network/requstes.dart';
import 'package:advanced_mvvm_flutter_api/domain/model/models.dart';
import 'package:advanced_mvvm_flutter_api/domain/model/repository/repository.dart';
import 'package:advanced_mvvm_flutter_api/domain/usecase/base_usecase.dart';
import 'package:dartz/dartz.dart';

class RegisterUsecase
    implements BaseuseCase<RegisterUsecaseInput, Authentication> {
  final Repository _repository;
  RegisterUsecase(this._repository);
  @override
  Future<Either<Failure, Authentication>> execute(
      RegisterUsecaseInput input) async {
    return await _repository.register(RegisterRequest(input.userName,
        input.countryMobileCode, input.mobileNumber, input.email, input.password, input.profilePicture));
  }
}

class RegisterUsecaseInput {
  String userName;
  String countryMobileCode;
  String mobileNumber;
  String email;
  String password;
  String profilePicture;

  RegisterUsecaseInput(
    this.userName,
    this.countryMobileCode,
    this.mobileNumber,
    this.email,
    this.password,
    this.profilePicture,
  );
}
