// ignore_for_file: ant_identifier_names

import 'package:advanced_mvvm_flutter_api/data/network/failure.dart';
import 'package:advanced_mvvm_flutter_api/presentation/resources/strings_manager.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

class ErrorHandler implements Exception {
  late Failure failure;

  ErrorHandler.handle(dynamic error) {
    if (error is DioError) {
      // dio error so its an error from response of the API or from dio itself
      failure = _handlerError(error);
    } else {
      // default error
      failure = DataSource.DEFAULT.getFailure();
    }
  }
}

Failure _handlerError(DioError error) {
  switch (error.type) {
    case DioErrorType.connectTimeout:
     return DataSource.CONNECT_TIMEOUT.getFailure();
    case DioErrorType.sendTimeout:
     return DataSource.SEND_TIMEOUT.getFailure();

    case DioErrorType.receiveTimeout:
     return DataSource.RECIEVE_TIMEOUT.getFailure();

    case DioErrorType.response:
    if(error.response!=null && error.response?.statusCode!= null && error.response?.statusMessage!= null ){
      return Failure(error.response?.statusCode ?? 0, error.response?.statusMessage?? "");
    }else{
      return DataSource.DEFAULT.getFailure();
    }
  
    case DioErrorType.cancel:
    return  DataSource.CANCEL.getFailure();

    case DioErrorType.other:
     return DataSource.DEFAULT.getFailure();
  }
}

enum DataSource {
  SUCCESS,
  NO_CONTENT,
  BAD_REQUEST,
  FORBIDDEN,
  UNAUTORISED,
  INTERNAL_SERVER_ERROR,
  CONNECT_TIMEOUT,
  CANCEL,
  RECIEVE_TIMEOUT,
  SEND_TIMEOUT,
  CACHE_ERROR,
  NO_INTERNET_CONNECTION,
  DEFAULT
}

extension DataSourceExtention on DataSource {
  Failure getFailure() {
    switch (this) {
      case DataSource.SUCCESS:
        return Failure(ResponseCode.SUCCESS, ResponseMessage.SUCCESS);

      case DataSource.NO_CONTENT:
        return Failure(ResponseCode.NO_CONTENT, ResponseMessage.NO_CONTENT);
      case DataSource.BAD_REQUEST:
        return Failure(ResponseCode.BAD_REQUEST, ResponseMessage.BAD_REQUEST);

      case DataSource.FORBIDDEN:
        return Failure(ResponseCode.FORBIDDEN, ResponseMessage.FORBIDDEN);

      case DataSource.UNAUTORISED:
        return Failure(ResponseCode.UNAUTORISED, ResponseMessage.UNAUTORISED);

      case DataSource.INTERNAL_SERVER_ERROR:
        return Failure(ResponseCode.INTERNAL_SERVER_ERROR,
            ResponseMessage.INTERNAL_SERVER_ERROR);

      case DataSource.CONNECT_TIMEOUT:
        return Failure(
            ResponseCode.CONNECT_TIMEOUT, ResponseMessage.CONNECT_TIMEOUT);

      case DataSource.CANCEL:
        return Failure(ResponseCode.CANCEL, ResponseMessage.CANCEL);

      case DataSource.RECIEVE_TIMEOUT:
        return Failure(
            ResponseCode.RECIEVE_TIMEOUT, ResponseMessage.RECIEVE_TIMEOUT);

      case DataSource.SEND_TIMEOUT:
        return Failure(ResponseCode.SEND_TIMEOUT, ResponseMessage.SEND_TIMEOUT);

      case DataSource.CACHE_ERROR:
        return Failure(ResponseCode.CACHE_ERROR, ResponseMessage.CACHE_ERROR);

      case DataSource.NO_INTERNET_CONNECTION:
        return Failure(ResponseCode.NO_INTERNET_CONNECTION,
            ResponseMessage.NO_INTERNET_CONNECTION);
      case DataSource.DEFAULT:
        return Failure(ResponseCode.DEFAULT, ResponseMessage.DEFAULT);
    }
  }
}

class ResponseCode {
  static  int SUCCESS = 200; // success with data
  static  int NO_CONTENT = 201; // success with no data (no content)
  static  int BAD_REQUEST = 400; // failure, API rejected request
  static  int FORBIDDEN = 403; //  // failure , user is not request
  static  int UNAUTORISED = 401; // failure , user is not authorised
  static  int INTERNAL_SERVER_ERROR = 500;
  static  int NOT_FOUND = 401;
  // failure , crash in server side

  // local status code
  static  int CONNECT_TIMEOUT = -1;
  static  int CANCEL = -2;
  static  int RECIEVE_TIMEOUT = -3;
  static  int SEND_TIMEOUT = -4;
  static  int CACHE_ERROR = -5;
  static  int NO_INTERNET_CONNECTION = -6;
  static  int DEFAULT = -7;
}

class ResponseMessage {
  // ignore: ant_identifier_names
  static  String SUCCESS =AppStrings.Success.tr(); // success with data
  static  String NO_CONTENT =
      AppStrings.Success.tr(); // success with no data (no content)
  static String BAD_REQUEST =
      AppStrings.badRequestError.tr(); // failure, API rejected request
  static  String FORBIDDEN =
      AppStrings.forbiddenError.tr(); //  // failure , user is not request
  static  String UNAUTORISED =
     AppStrings.unauthorizedError.tr(); // failure , user is not authorised
  static  String INTERNAL_SERVER_ERROR =
      AppStrings.internalServerError.tr(); // failure , crash in server side

  // local status code
  static  String CONNECT_TIMEOUT = AppStrings.timeoutError.tr();
  static  String CANCEL = AppStrings.defaultError.tr();
  static  String RECIEVE_TIMEOUT = AppStrings.timeoutError.tr();
  static  String SEND_TIMEOUT = AppStrings.defaultError.tr();
  static  String CACHE_ERROR = AppStrings.cacheError.tr();
  static  String NO_INTERNET_CONNECTION =
      AppStrings.noInternetError.tr();
  static  String UNKNOWN = 'Some thing went wrong , Try again later';
  static  String DEFAULT = AppStrings.defaultError.tr();
}

class ApiInternalStatus{
  static  int SUCCESS =0;
  static  int FAILURE =1;

}
