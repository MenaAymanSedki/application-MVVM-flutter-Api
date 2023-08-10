import 'package:advanced_mvvm_flutter_api/data/network/failure.dart';
import 'package:advanced_mvvm_flutter_api/domain/model/models.dart';
import 'package:advanced_mvvm_flutter_api/domain/model/repository/repository.dart';
import 'package:advanced_mvvm_flutter_api/domain/usecase/base_usecase.dart';
import 'package:dartz/dartz.dart';

class HomeUsecase implements BaseuseCase <void,HomeObject>{
  final Repository _repository;
  HomeUsecase(this._repository);
  @override
  Future<Either<Failure, HomeObject>> execute(void input) async{
    return await _repository.getHomeData();
  }

}
