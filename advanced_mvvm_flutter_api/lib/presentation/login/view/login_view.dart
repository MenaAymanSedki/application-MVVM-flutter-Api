import 'package:advanced_mvvm_flutter_api/app/di.dart';
import 'package:advanced_mvvm_flutter_api/presentation/common/state_rendrer/state_rendrer_impl.dart';
import 'package:advanced_mvvm_flutter_api/presentation/resources/assets_manager.dart';
import 'package:advanced_mvvm_flutter_api/presentation/resources/color_manager.dart';
import 'package:advanced_mvvm_flutter_api/presentation/resources/routes_manager.dart';
import 'package:advanced_mvvm_flutter_api/presentation/resources/strings_manager.dart';
import 'package:advanced_mvvm_flutter_api/presentation/resources/values_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../../app/app_prefs.dart';
import '../viewmodel/login_viewmodel.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  LoginViewModel _viewModel = instance<LoginViewModel>();
    final AppPreferences _appPreferences = instance<AppPreferences>();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _userPasswordController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  _bind() {
    _viewModel.start(); // tell viewmodel , start yuor job
    _userNameController
        .addListener(() => _viewModel.setUserName(_userNameController.text));
    _userPasswordController.addListener(
        () => _viewModel.setPassword(_userPasswordController.text));
        _viewModel.isUserLoggedInSuccefullyStreamController.stream.listen((isLoggedIn) {
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
      body: StreamBuilder<FlowState>(
        stream: _viewModel.outputState,
        builder: (context,snapshot){
          return snapshot.data?.getScreenWidget(context,_getContentWidget(),(){
            _viewModel.login();
          })?? _getContentWidget();
          
        },
      ),
    );
  }

  Widget _getContentWidget() {
    return 
      Container(
        padding: const EdgeInsets.only(top: AppPadding.p100),
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
                  child: StreamBuilder<bool>(
                      stream: _viewModel.outIsUserNameValid,
                      builder: (context, snapshot) {
                        return TextFormField(
                          decoration: InputDecoration(
                              hintText: AppStrings.username.tr(),
                              labelText: AppStrings.username.tr(),
                              errorText: (snapshot.data ?? true)
                                  ? null
                                  : AppStrings.usernameError.tr()),
                          keyboardType: TextInputType.emailAddress,
                          controller: _userNameController,
                        );
                      }),
                ),
                const SizedBox(height: AppSize.s28,),
                // text from fiel Passwords
                Padding(
                  padding: const EdgeInsets.only(
                      left: AppPadding.p12, right: AppPadding.p28),
                  child: StreamBuilder<bool>(
                      stream: _viewModel.outIsPasswordValid,
                      builder: (context, snapshot) {
                        return TextFormField(
                          decoration: InputDecoration(
                              hintText: AppStrings.password.tr(),
                              labelText: AppStrings.password.tr(),
                              errorText: (snapshot.data ?? true)
                                  ? null
                                  : AppStrings.passwordError.tr()),
                          keyboardType: TextInputType.visiblePassword,
                          controller: _userPasswordController,
                        );
                      }),
                ),
                const SizedBox(height: AppSize.s20,),
                
                const SizedBox(
                  height: AppSize.s28,
                ),
                const SizedBox(
                  height: AppSize.s28,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: AppPadding.p12, right: AppPadding.p28),
                  child: StreamBuilder<bool>(
                      stream: _viewModel.outIsPasswordValid,
                      builder: (context, snapshot) {
                        return SizedBox(
                          width: double.infinity,
                          height: AppSize.s40,
                          child: ElevatedButton(
                            onPressed: (snapshot.data ?? false)
                                ? () {
                                    _viewModel.login();
                                  }
                                : null,
                            child:  Text(AppStrings.login.tr()),
                          ),
                        );
                      }),
                ),
                Padding(padding: const EdgeInsets.only(left: AppPadding.p28,right: AppPadding.p28),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(onPressed: (){
                      Navigator.pushNamed(context, Routes.forgotPasswordRoute);
                    }, child: Text(AppStrings.forgotPassword.tr(),
                    style: Theme.of(context).textTheme.titleMedium, 
                    textAlign: TextAlign.end,
                    
                    ),),
                    TextButton(onPressed: (){
                      Navigator.pushNamed(context, Routes.registerRoute);
                    }, child: Text(AppStrings.registerText.tr(),
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.left,
                    
                    ),),
                  ],
                ),
                
                ),
              ],
            ),
          ),
        ),
      );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}
