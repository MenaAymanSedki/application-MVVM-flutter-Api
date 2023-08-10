import 'package:advanced_mvvm_flutter_api/app/app_prefs.dart';
import 'package:advanced_mvvm_flutter_api/app/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

const String APPLICATION_JSON = 'application/json';
const String CONTENT_TYPE = 'content-type';
const String ACCEPT = 'accept';
const String DEFAULT_LANGUAGE = 'langauge';
const String AUTHORIZATION = 'langauge';

class DioFactory {
  final AppPreferences _appPreferences;
  DioFactory(this._appPreferences);
  Future<Dio> getDio() async {
    Dio dio = Dio();
    String langauge = await _appPreferences.getAppLanguage();
    // ignore: no_leading_underscores_for_local_identifiers
    int _timeOut = Constants.apitimeout; // a minute time out
    Map<String, String> headers = {
      CONTENT_TYPE: APPLICATION_JSON,
      ACCEPT: APPLICATION_JSON,
      AUTHORIZATION: Constants.token,
      DEFAULT_LANGUAGE: langauge
    };
    dio.options = BaseOptions(
      baseUrl: Constants.baseUrl,
      headers: headers,
      receiveTimeout: Constants.apitimeout,
      sendTimeout: Constants.apitimeout,
    );

    if (kReleaseMode) {
      print('no log in release mode');
    } else {
      dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
      ));
    }

    return dio;
  }
}
