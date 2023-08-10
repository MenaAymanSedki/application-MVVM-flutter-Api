import 'dart:async';

import 'package:advanced_mvvm_flutter_api/domain/usecase/login_usecase.dart';
import 'package:advanced_mvvm_flutter_api/presentation/base/baseviewmodel.dart';
import 'package:advanced_mvvm_flutter_api/presentation/common/state_rendrer/state_renderer.dart';
import 'package:advanced_mvvm_flutter_api/presentation/common/state_rendrer/state_rendrer_impl.dart';

import '../../common/freezed_data_classes.dart';

class LoginViewModel extends BaseViewModel
    with LoginViewModelInputs, LoginViewModelOutputs {
  final StreamController _userNameStreamController =
      StreamController<String>.broadcast();
  final StreamController _passwordStreamController =
      StreamController<String>.broadcast();
  final StreamController _areAllInputsValidStreamController =
      StreamController<void>.broadcast();

      // logged User
      StreamController isUserLoggedInSuccefullyStreamController = StreamController<bool>();

  var loginObject = LoginObject('', '');
  final LoginUsecase _loginUsecase;
  LoginViewModel(this._loginUsecase);

  @override
  // inputs
  void dispose() {
    super.dispose();
    _userNameStreamController.close();
    _passwordStreamController.close();
    _areAllInputsValidStreamController.close();
    isUserLoggedInSuccefullyStreamController.close();
  }

  @override
  void start() {
    inputState.add(ContentState());
  }

  @override
  Sink get inptuPassword => _passwordStreamController.sink;

  @override
  Sink get inputUserName => _userNameStreamController.sink;

  @override
  Sink get inputsAreAllDataValid => _areAllInputsValidStreamController.sink;

  @override
  login() async {
    inputState.add(LoadingState(stateRendererType: StateRendererType.popupLoadingState));
    (await _loginUsecase.execute(
            LoginUseCaseInput(loginObject.userName, loginObject.password)))
        .fold(
            (failure) => {
                  // left -> failure
                  inputState.add(ErrorState(StateRendererType.popupErrorState,failure.message))

                },
            (data) {
                  // right -> data (success) 
                  // content
                  inputState.add(ContentState());
                  // navigate to main screen
                  isUserLoggedInSuccefullyStreamController.add(true);

                });
  }

  // outputs
  @override
  Stream<bool> get outIsPasswordValid => _passwordStreamController.stream
      .map((password) => _isPasswordValid(password));

  @override
  Stream<bool> get outIsUserNameValid => _userNameStreamController.stream
      .map((userName) => _isUserNameValid(userName));

  bool _isPasswordValid(String password) {
    return password.isNotEmpty;
  }

  bool _isUserNameValid(String userName) {
    return userName.isNotEmpty;
  }

  bool _areAllInputsValid() {
    return _isPasswordValid(loginObject.password) &&
        _isUserNameValid(loginObject.userName);
  }

  @override
  setPassword(String password) {
    inptuPassword.add(password);
    loginObject = loginObject.copyWith(password: password);
    inputsAreAllDataValid.add(null);
  }

  @override
  setUserName(String userName) {
    inputUserName.add(userName);
    loginObject = loginObject.copyWith(userName: userName);
    inputsAreAllDataValid.add(null);
  }

  @override
  Stream<bool> get outAreAllInputsValid =>
      _areAllInputsValidStreamController.stream
          .map((_) => _areAllInputsValid());
           
}

abstract class LoginViewModelInputs {
  setUserName(String userName);
  setPassword(String password);
  login();

  Sink get inputUserName;
  Sink get inptuPassword;
  Sink get inputsAreAllDataValid;
}

abstract class LoginViewModelOutputs {
  Stream<bool> get outIsUserNameValid;
  Stream<bool> get outIsPasswordValid;
  Stream<bool> get outAreAllInputsValid;
}
