import 'package:advanced_mvvm_flutter_api/app/app_prefs.dart';
import 'package:advanced_mvvm_flutter_api/data/data_source/local_data_source.dart';
import 'package:advanced_mvvm_flutter_api/data/data_source/remote_data_source.dart';
import 'package:advanced_mvvm_flutter_api/data/network/app_api.dart';
import 'package:advanced_mvvm_flutter_api/data/network/dio_factory.dart';
import 'package:advanced_mvvm_flutter_api/data/network/network_info.dart';
import 'package:advanced_mvvm_flutter_api/data/repository/repository_impl.dart';
import 'package:advanced_mvvm_flutter_api/domain/model/repository/repository.dart';
import 'package:advanced_mvvm_flutter_api/domain/usecase/forgot_passowrd_usecase.dart';
import 'package:advanced_mvvm_flutter_api/domain/usecase/home_usecase.dart';
import 'package:advanced_mvvm_flutter_api/domain/usecase/login_usecase.dart';
import 'package:advanced_mvvm_flutter_api/domain/usecase/register_usecase.dart';
import 'package:advanced_mvvm_flutter_api/presentation/forgot_password/forgot_password_viewmodel.dart';
import 'package:advanced_mvvm_flutter_api/presentation/login/viewmodel/login_viewmodel.dart';
import 'package:advanced_mvvm_flutter_api/presentation/main/pages/home/viewmodel/home_viewmodel.dart';
import 'package:advanced_mvvm_flutter_api/presentation/register/viewmodel/register_viewmodel.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/usecase/store_details_usecase.dart';
import '../presentation/store_details/store_details_viewmodel.dart';

final instance = GetIt.instance;

Future<void> initAppModule() async {
  // app module , its a module where we put all generic dependinces

  // shared prefs instance
  final sharedPrefs = await SharedPreferences.getInstance();

  instance.registerLazySingleton<SharedPreferences>(() => sharedPrefs);

  // app prefs instance
  instance
      .registerLazySingleton<AppPreferences>(() => AppPreferences(instance()));
  // network info
  instance.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(InternetConnectionChecker()));

  // dio factory
  instance.registerLazySingleton<DioFactory>(() => DioFactory(instance()));

  Dio dio = await instance<DioFactory>().getDio();  
  // app service client
  instance.registerLazySingleton<AppServiceClient>(() => AppServiceClient(dio));

  // remote data source
  instance.registerLazySingleton<RemoteDataSource>(
      () => RemoteDataSourceImpl(instance<AppServiceClient>()));
  // local data source
  instance.registerLazySingleton<LocalDataSource>(
      () => LocalDataSourceImpl());

  // repository
  instance.registerLazySingleton<Repository>(
      () => RepositoryImpl(instance(), instance(),instance()));
}

initLoginModule() {
  if (!GetIt.I.isRegistered<LoginUsecase>()) {
    instance.registerFactory<LoginUsecase>(() => LoginUsecase(instance()));
    instance.registerFactory<LoginViewModel>(() => LoginViewModel(instance()));
  }
}
// forgotPassword
  initForgotPasswordModule(){
    if(!GetIt.I.isRegistered<ForgotPasswordUsecase>()){
      instance.registerFactory<ForgotPasswordUsecase>(() =>ForgotPasswordUsecase(instance()));
      instance.registerFactory<ForgotPasswordViewModel>(() =>ForgotPasswordViewModel(instance()));
    }
  }
  initRegisterModule(){
    if(!GetIt.I.isRegistered<RegisterUsecase>()){
      instance.registerFactory<RegisterUsecase>(() =>RegisterUsecase(instance()));
      instance.registerFactory<RegisterViewModel>(() =>RegisterViewModel(instance()));
       instance.registerFactory<ImagePicker>(() =>ImagePicker());
    }
  }
  initHomeModule(){
    if(!GetIt.I.isRegistered<HomeUsecase>()){
      instance.registerFactory<HomeUsecase>(() =>HomeUsecase(instance()));
      instance.registerFactory<HomeViewModel>(() =>HomeViewModel(instance()));
    }
  }

  initStoreDetailsModule() {
  if (!GetIt.I.isRegistered<StoreDetailsUseCase>()) {
    instance.registerFactory<StoreDetailsUseCase>(
        () => StoreDetailsUseCase(instance()));
    instance.registerFactory<StoreDetailsViewModel>(
        () => StoreDetailsViewModel(instance()));
  }
}
  