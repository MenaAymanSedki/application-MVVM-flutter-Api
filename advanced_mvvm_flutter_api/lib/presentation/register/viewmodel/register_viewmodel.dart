import 'dart:async';
import 'dart:io';

import 'package:advanced_mvvm_flutter_api/domain/usecase/register_usecase.dart';
import 'package:advanced_mvvm_flutter_api/presentation/base/baseviewmodel.dart';
import 'package:advanced_mvvm_flutter_api/presentation/common/freezed_data_classes.dart';
import 'package:advanced_mvvm_flutter_api/presentation/common/state_rendrer/state_renderer.dart';
import 'package:advanced_mvvm_flutter_api/presentation/common/state_rendrer/state_rendrer_impl.dart';
import 'package:advanced_mvvm_flutter_api/presentation/forgot_password/functions.dart';
import 'package:advanced_mvvm_flutter_api/presentation/resources/strings_manager.dart';
import 'package:easy_localization/easy_localization.dart';

class RegisterViewModel extends BaseViewModel
    with RegisterViewModelInput, RegisterViewModelOutput {
  StreamController userNameStreamController =
      StreamController<String>.broadcast();
  StreamController mobileNumberStreamController =
      StreamController<String>.broadcast();
  StreamController emailStreamController = StreamController<String>.broadcast();
  StreamController passwordStreamController =
      StreamController<String>.broadcast();
  StreamController profilePictureStreamController =
      StreamController<File>.broadcast();
  StreamController areAllInputsValidStreamController =
      StreamController<void>.broadcast();

      StreamController isUserRegisteredSuccefullyStreamController = StreamController<bool>();

  // ignore: unused_field
  final RegisterUsecase _registerUsecase;
  var registerObject = RegisterObject("", "", "", "", "", "");
  RegisterViewModel(this._registerUsecase);

  // inputs
  @override
  void start() {
    inputState.add(ContentState());
  }

  @override
  void dispose() {
    userNameStreamController.close();
    mobileNumberStreamController.close();
    emailStreamController.close();
    passwordStreamController.close();
    profilePictureStreamController.close();
    areAllInputsValidStreamController.close();
    isUserRegisteredSuccefullyStreamController.close();
    super.dispose();
  }

  // inputs
  @override
  Sink get inputEmail => emailStreamController.sink;

  @override
  Sink get inputMobileNumber => mobileNumberStreamController.sink;

  @override
  Sink get inputPassword => passwordStreamController.sink;

  @override
  Sink get inputProfilePicture => profilePictureStreamController.sink;

  @override
  Sink get inputUserName => userNameStreamController.sink;

   @override
  Sink get inputAllInputsValid => areAllInputsValidStreamController.sink;

  @override
  setUserName(String userName) {
    inputUserName.add(userName);
    if (_isUsernameValid(userName)) {
      // update resgister view object
      registerObject = registerObject.copyWith(userName: userName);
    } else {
      // reset username value in register view object
      registerObject = registerObject.copyWith(userName: "");
    }
        validate();

  }

  @override
  register() async{
    inputState.add(LoadingState(stateRendererType:StateRendererType.popupLoadingState));
    (await _registerUsecase.execute(
      RegisterUsecaseInput(
        registerObject.userName,
        registerObject.countryMobileCode,
        registerObject.mobileNumber,
        registerObject.email,
        registerObject.password,
        registerObject.profilePicture,
      )
    ))
    .fold((failure) =>{
      inputState.add(ErrorState(StateRendererType.popupErrorState, failure.message))
    },(data){
      inputState.add(ContentState());
      isUserRegisteredSuccefullyStreamController.add(true);
    });
  }

  @override
  setCountryCode(String countryCode) {

    if (countryCode.isNotEmpty) {
      // update resgister view object
      registerObject = registerObject.copyWith(countryMobileCode: countryCode);
    } else {
      // reset username value in register view object
      registerObject = registerObject.copyWith(countryMobileCode: "");
    }
    validate();
  }

  @override
  setEmail(String email) {
    inputEmail.add(email);
    if (isEmailValid(email)) {
      // update resgister view object
      registerObject = registerObject.copyWith(email: email);
    } else {
      // reset username value in register view object
      registerObject = registerObject.copyWith(email: "");
    }
    validate();
  }

  @override
  setMobileNumber(String mobileNumber) {
    inputMobileNumber.add(mobileNumber);
    if (isMobileNumberValid(mobileNumber)) {
      // update resgister view object
      registerObject = registerObject.copyWith(mobileNumber: mobileNumber);
    } else {
      // reset mobileNumber value in register view object
      registerObject = registerObject.copyWith(mobileNumber: "");
    }
        validate();

  }

  @override
  setPassword(String password) {
    inputPassword.add(password);
    if (_isPasswordValid(password)) {
      // update resgister view object
      registerObject = registerObject.copyWith(password: password);
    } else {
      // reset password value in register view object
      registerObject = registerObject.copyWith(password: "");
    }
        validate();

  }

  @override
  setProfilePicture(File profilePicture) {
    inputProfilePicture.add(profilePicture);
    if (profilePicture.path.isNotEmpty) {
      // update resgister view object
      registerObject =
          registerObject.copyWith(profilePicture: profilePicture.path);
    } else {
      // reset password value in register view object
      registerObject = registerObject.copyWith(profilePicture: "");
    }
        validate();

  }

  // outputs

  @override
  Stream<bool> get outputIsUserNameValid => userNameStreamController.stream
      .map((userName) => _isUsernameValid(userName));

  @override
  Stream<String?> get outputErrorUserNameValid => outputIsUserNameValid
      .map((isUserName) => isUserName ? null : AppStrings.usernameInValid.tr());

  @override
  Stream<bool> get outputIsEmailValid =>
      emailStreamController.stream.map((email) => isEmailValid(email));

  @override
  Stream<String?> get outputErrorEmail => outputIsEmailValid
      .map((isEmailValid) => isEmailValid ? null : AppStrings.emailInValid.tr());

  @override
  Stream<bool> get outputIsMobileNumberValid =>
      mobileNumberStreamController.stream
          .map((mobileNumber) => isMobileNumberValid(mobileNumber));

  @override
  Stream<String?> get outputErrorMobileNumber =>
      outputIsMobileNumberValid.map((isMobileNumberValid) =>
          isMobileNumberValid ? null : AppStrings.mobileNumberInValid.tr());

  @override
  Stream<bool> get outputIsPasswordValid => passwordStreamController.stream
      .map((password) => _isPasswordValid(password));
  @override
  Stream<String?> get outputErrorPassword => outputIsPasswordValid.map(
      (isPasswordValid) => isPasswordValid ? null : AppStrings.passwordInValid.tr());

  @override
  Stream<File> get outputIsProfilePicture =>
      profilePictureStreamController.stream.map((file) => file);


  @override
  Stream<bool> get outputAreAllInputsValid =>areAllInputsValidStreamController.stream.map((_) => _areAllInputsValid());

  // -- private fuctions

  bool _isUsernameValid(String userName) {
    return userName.length >= 8;
  }

  bool isMobileNumberValid(String mobileNumber) {
    return mobileNumber.length >= 10;
  }

  bool _isPasswordValid(String password) {
    return password.length >= 6;
  }
  bool _areAllInputsValid(){
    return
     registerObject.countryMobileCode.isNotEmpty && 
     registerObject.mobileNumber.isNotEmpty && 
     registerObject.userName.isNotEmpty && 
     registerObject.email.isNotEmpty&&
     registerObject.password.isNotEmpty&&
     registerObject.profilePicture.isNotEmpty;
     
  }
  validate(){
    inputAllInputsValid.add(null);
  }
}

abstract class RegisterViewModelInput {
  Sink get inputUserName;
  Sink get inputMobileNumber;
  Sink get inputEmail;
  Sink get inputPassword;
  Sink get inputProfilePicture;
  Sink get inputAllInputsValid;

  setUserName(String userName);
  setMobileNumber(String mobileNumber);
  setCountryCode(String countryCode);
  setEmail(String email);
  setPassword(String password);
  setProfilePicture(File profilePicture);

  register();
}

abstract class RegisterViewModelOutput {
  Stream<bool> get outputIsUserNameValid;

  Stream<String?> get outputErrorUserNameValid;

  Stream<bool> get outputIsMobileNumberValid;
  Stream<String?> get outputErrorMobileNumber;

  Stream<bool> get outputIsEmailValid;
  Stream<String?> get outputErrorEmail;

  Stream<bool> get outputIsPasswordValid;
  Stream<String?> get outputErrorPassword;

  Stream<File> get outputIsProfilePicture;
  Stream<bool> get outputAreAllInputsValid;
}
