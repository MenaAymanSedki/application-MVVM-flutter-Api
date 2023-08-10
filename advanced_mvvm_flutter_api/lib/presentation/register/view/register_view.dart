import 'dart:io';

import 'package:advanced_mvvm_flutter_api/app/app_prefs.dart';
import 'package:advanced_mvvm_flutter_api/app/constants.dart';
import 'package:advanced_mvvm_flutter_api/presentation/common/state_rendrer/state_rendrer_impl.dart';
import 'package:advanced_mvvm_flutter_api/presentation/register/viewmodel/register_viewmodel.dart';
import 'package:advanced_mvvm_flutter_api/presentation/resources/color_manager.dart';
import 'package:advanced_mvvm_flutter_api/presentation/resources/values_manager.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../../app/di.dart';
import '../../resources/assets_manager.dart';
import '../../resources/routes_manager.dart';
import '../../resources/strings_manager.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final RegisterViewModel _viewModel = instance<RegisterViewModel>();
  final ImagePicker _imagePicker = instance<ImagePicker>();
  final AppPreferences _appPreferences = instance<AppPreferences>();
  final _formkey = GlobalKey<FormState>();

  final TextEditingController _usernameEditingController =
      TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();
  final TextEditingController _mobileEditingController =
      TextEditingController();

  _bind() {
    _viewModel.start();
    _usernameEditingController.addListener(() {
      _viewModel.setUserName(_usernameEditingController.text);
    });
    _emailEditingController.addListener(() {
      _viewModel.setEmail(_emailEditingController.text);
    });
    _passwordEditingController.addListener(() {
      _viewModel.setPassword(_passwordEditingController.text);
    });
    _mobileEditingController.addListener(() {
      _viewModel.setMobileNumber(_mobileEditingController.text);
    });

    _viewModel.isUserRegisteredSuccefullyStreamController.stream.listen((isLoggedIn) {
          if(isLoggedIn){
            // navigate to main screen
            SchedulerBinding.instance.addPostFrameCallback((_) { 
              _appPreferences.setUserLoggedIn();
               Navigator.of(context).pushReplacementNamed(Routes.mainRoute);
            });
           
          } 

        });
  }

  @override
  void initState() {
    _bind();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        elevation: AppSize.s0,
        backgroundColor: ColorManager.white,
        iconTheme: IconThemeData(color: ColorManager.primary),
      ),
      body: StreamBuilder<FlowState>(
        stream: _viewModel.outputState,
        builder: (context, snapshot) {
          return snapshot.data?.getScreenWidget(context, _getContentWidget(),
                  () {
                _viewModel.register();
              }) ??
              _getContentWidget();
        },
      ),
    );
  }

  Widget _getContentWidget() {
    return Container(
      padding: const EdgeInsets.only(top: AppPadding.p20), 
      child: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              const Center(
                child: Image(image: AssetImage(ImageAssets.splashLogo)),
              ),
              // text form field username
              const SizedBox(
                height: AppSize.s28,
              ),
              // user name
              Padding(
                padding: const EdgeInsets.only(
                    left: AppPadding.p12, right: AppPadding.p28),
                child: StreamBuilder<String?>(
                    stream: _viewModel.outputErrorUserNameValid,
                    builder: (context, snapshot) {
                      return TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _usernameEditingController,
                          decoration: InputDecoration(
                            hintText: AppStrings.username.tr(),
                            labelText: AppStrings.username.tr(),
                            errorText: snapshot.data,
                          ));
                    }),
              ),
               const SizedBox(
                height: AppSize.s28,
              ),
              Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: CountryCodePicker(
                        onChanged: (country) {
                          _viewModel
                              .setCountryCode(country.dialCode?? Constants.token);
                        },
                        initialSelection: '+20',
                        favorite: const ['+20'],
                        showCountryOnly: true,
                        showOnlyCountryWhenClosed: true,
                        hideMainText: true,
                      )),
                  Expanded(
                    flex: 3,
                    child: StreamBuilder<String?>(
                      stream: _viewModel.outputErrorMobileNumber,
                      builder: (context, snapshot) {
                        return TextFormField(
                          keyboardType: TextInputType.phone,
                          controller: _mobileEditingController,
                          decoration: InputDecoration(
                              hintText: AppStrings.mobile.tr(),
                              labelText: AppStrings.mobile.tr(),
                              errorText: snapshot.data),
                        );
                      },
                    ),
                  ),
                ],
              ),
               const SizedBox(
                height: AppSize.s28,
              ),
              // email register
              Padding(
                padding: const EdgeInsets.only(
                    left: AppPadding.p12, right: AppPadding.p28),
                child: StreamBuilder<String?>(
                    stream: _viewModel.outputErrorEmail,
                    builder: (context, snapshot) {
                      return TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailEditingController,
                        decoration: InputDecoration(
                            hintText: AppStrings.email.tr(),
                            labelText: AppStrings.email.tr(),
                            errorText: snapshot.data),
                      );
                    }),
              ),

              const SizedBox(
                height: AppSize.s28,
              ),
              // text from field Passwords
              Padding(
                padding: const EdgeInsets.only(
                    left: AppPadding.p12, right: AppPadding.p28),
                child: StreamBuilder<String?>(
                    stream: _viewModel.outputErrorPassword,
                    builder: (context, snapshot) {
                      return TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        controller: _passwordEditingController,
                        decoration: InputDecoration(
                            hintText: AppStrings.password.tr(),
                            labelText: AppStrings.password.tr(),
                            errorText: snapshot.data),
                      );
                    }),
              ),
              const SizedBox(
                height: AppSize.s20,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: AppPadding.p28, right: AppPadding.p28),
                child: Container(
                  width: AppSize.s40,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(AppSize.s8)),
                      border: Border.all(color: ColorManager.grey)),
                  child: GestureDetector(
                    child: _getMediaWidget(),
                    onTap: () {
                      _showPicker(context);
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: AppPadding.p12, right: AppPadding.p28),
                child: StreamBuilder<bool>(
                    stream: _viewModel.outputAreAllInputsValid,
                    builder: (context, snapshot) {
                      return SizedBox(
                        width: double.infinity,
                        height: AppSize.s40,
                        child: ElevatedButton(
                          onPressed: (snapshot.data ?? false)
                              ? () {
                                  _viewModel.register();
                                }
                              : null,
                          child:  Text(AppStrings.register.tr()),
                        ),
                      );
                    }),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: AppPadding.p28, right: AppPadding.p28),
                child: TextButton(
                  onPressed: () {
                    // Navigator.pushNamed(context, Routes.forgotPasswordRoute);
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    AppStrings.alreadyaccount.tr(),
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _showPicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
              child: Wrap(
            children: [
              ListTile(
                trailing: const Icon(Icons.arrow_forward),
                leading: const Icon(Icons.camera),
                title: Text(AppStrings.photoGallery.tr()),
                onTap: () {
                  _imageFromGallery();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                trailing: const Icon(Icons.arrow_forward),
                leading: const Icon(Icons.camera_alt_outlined),
                title:  Text(AppStrings.photoCamera.tr()),
                onTap: () {
                  _imageFromCamera();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ));
        });
  }
  _imageFromCamera()async{
  var image = await _imagePicker.pickImage(source: ImageSource.camera);
    _viewModel.setProfilePicture(File(image?.path?? ""));
  }

  _imageFromGallery() async{
    var image = await _imagePicker.pickImage(source: ImageSource.gallery);
    _viewModel.setProfilePicture(File(image?.path?? ""));
    
  }

  Widget _getMediaWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: AppPadding.p8, right: AppPadding.p8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
            Flexible(child: Text(
             AppStrings.profilepicture.tr()),
          ),
          Flexible(
            child: StreamBuilder<File>(
            stream: _viewModel.outputIsProfilePicture,
            builder: (context, snapshot) {
              return _imagePickedByUser(snapshot.data);
            },
          )),
          Flexible(child: SvgPicture.asset(ImageAssets.photocameraIc))
        ],
      ),
    );
  }

  Widget _imagePickedByUser(File? image) {
    if (image != null && image.path.isNotEmpty) {
      // return image
      return Image.file(image);
    } else {
      return Container();
    }
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _usernameEditingController.dispose();
    _emailEditingController.dispose();
    _passwordEditingController.dispose();
    _mobileEditingController.dispose();
    super.dispose();
  }

  void _onCountryChange(String countryCode) {
    //TODO : manipulate the selected country code here
    print("New Country selected: " + countryCode.toString());
    _viewModel.setCountryCode(countryCode);
  }
}
