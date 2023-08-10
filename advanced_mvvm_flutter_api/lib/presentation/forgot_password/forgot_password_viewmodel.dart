
import 'dart:async';

import 'package:advanced_mvvm_flutter_api/domain/usecase/forgot_passowrd_usecase.dart';
import 'package:advanced_mvvm_flutter_api/presentation/base/baseviewmodel.dart';
import 'package:advanced_mvvm_flutter_api/presentation/common/state_rendrer/state_renderer.dart';
import 'package:advanced_mvvm_flutter_api/presentation/common/state_rendrer/state_rendrer_impl.dart';

import 'functions.dart';

class ForgotPasswordViewModel extends BaseViewModel with ForgotPasswordViewModelInput,ForgotPasswordViewModelOutput{
  final StreamController _emailStreamController = StreamController<String>.broadcast();
  final StreamController _isAllInputvalidateStreamController = StreamController<void>.broadcast();

  final ForgotPasswordUsecase  _forgotPasswordUsecase;
  ForgotPasswordViewModel(this._forgotPasswordUsecase);

  var email = '';
  
  @override
  void start() {
    inputState.add(ContentState());
  }

  forgotPassword()async{
    inputState.add(
      LoadingState(stateRendererType: StateRendererType.popupLoadingState));
    (await _forgotPasswordUsecase.execute(email)).fold((failure){
      inputState.add(
        ErrorState(StateRendererType.popupErrorState, failure.message));
     
    },(supportMessage){
        inputState.add(SuccessState(supportMessage));
    });
  }
  @override
  setEmail(String email){
    _validate();

  }
  @override
  void dispose() {
    _emailStreamController.close();
    _isAllInputvalidateStreamController.close();
    super.dispose();
  }

  
  @override
  Sink get inputEmail => _emailStreamController.sink;

  
  @override
  Sink get inputIsAlInputValid => _isAllInputvalidateStreamController.sink;
  
  @override
  Stream<bool> get outputIsAllInputValid => _isAllInputvalidateStreamController.stream.map((isAllInputValid) =>_isAllInputValid());
  _isAllInputValid(){
    return isEmailValid(email);
  }
  _validate(){
    inputIsAlInputValid.add(null);
  }
  @override
  Stream<bool> get outputIsEmailValid => _emailStreamController.stream.map((email) =>isEmailValid(email));
  



}

abstract class ForgotPasswordViewModelInput{
  setEmail(String email);
  Sink get inputEmail;
  Sink get inputIsAlInputValid;
}

abstract class ForgotPasswordViewModelOutput{
  
  Stream<bool> get outputIsEmailValid;

  Stream<bool> get outputIsAllInputValid;
}


