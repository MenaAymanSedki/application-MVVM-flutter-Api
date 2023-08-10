import 'package:advanced_mvvm_flutter_api/app/constants.dart';
import 'package:advanced_mvvm_flutter_api/presentation/common/state_rendrer/state_renderer.dart';
import 'package:advanced_mvvm_flutter_api/presentation/resources/strings_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

abstract class FlowState {
  StateRendererType getStateRendererType();
  String _getMessage();
}
// loading state (POPUP,FULL SCREEN)

class LoadingState extends FlowState {
  StateRendererType stateRendererType;
  String? message;

  LoadingState(
      {required this.stateRendererType, String message = AppStrings.loading});
  @override
  String _getMessage() => message ?? AppStrings.loading.tr();

  @override
  StateRendererType getStateRendererType() => stateRendererType;
}
// error state (POPUP,FULL SCREEN)

class ErrorState extends FlowState {
  StateRendererType stateRendererType;
  String message;

  ErrorState(this.stateRendererType, this.message);
  @override
  String _getMessage() => message;

  @override
  StateRendererType getStateRendererType() => stateRendererType;
}

// content state

class ContentState extends FlowState {
  ContentState();
  @override
  String _getMessage() => Constants.empty;

  @override
  StateRendererType getStateRendererType() => StateRendererType.contentState;
}

// EMPTY STATE

class EmptyState extends FlowState {
  String message;

  EmptyState(this.message);
  @override
  String _getMessage() => message;

  @override
  StateRendererType getStateRendererType() =>
      StateRendererType.fullScreenEmptyState;
}
class SuccessState extends FlowState {
  String message;

  SuccessState(this.message);
  @override
  String _getMessage() => message;

  @override
  StateRendererType getStateRendererType() =>
      StateRendererType.popupSuccess;
}

extension FlowStateExtension on FlowState {
  Widget getScreenWidget(BuildContext context, Widget contentScreenWidget,
      Function retryActionFunction) {
    switch (runtimeType) {
      case LoadingState:
        {
          if (getStateRendererType() == StateRendererType.popupLoadingState) {
            // show popup loading
            showPopup(context, getStateRendererType(), _getMessage());
            // show content ui of the screen
            return contentScreenWidget;
          } else {
            // full screen state loading
            return StateRenderer(
              message: _getMessage(),
              stateRendererType: getStateRendererType(),
              retryActionFunction: retryActionFunction,
            );
          }
        }
      case ErrorState:
        {
          dismissDialog(context);

          if (getStateRendererType() == StateRendererType.popupErrorState) {
            // show popup loading
            showPopup(context, getStateRendererType(), _getMessage());
            // show content ui of the screen
            return contentScreenWidget;
          } else {
            // full screen state loading
            return StateRenderer(
              message: _getMessage(),
              stateRendererType: getStateRendererType(),
              retryActionFunction: retryActionFunction,
            );
          }
        }
      case EmptyState:
        {
          return StateRenderer(
              stateRendererType: getStateRendererType(),
              message: _getMessage(),
              retryActionFunction: retryActionFunction);
        }
      case ContentState:
        {
          dismissDialog(context);

          return contentScreenWidget;
        }
        case SuccessState:
        {
          dismissDialog(context);
          showPopup(context, StateRendererType.popupSuccess,_getMessage(),
              title: AppStrings.Success.tr()
          );
          return contentScreenWidget;
        }
      default:
        {
          dismissDialog(context);
          return contentScreenWidget;
        }
    }
  }

  _isCurrentDialogShowing(BuildContext context) =>
      ModalRoute.of(context)?.isCurrent != true;
  dismissDialog(BuildContext context) {
    if (_isCurrentDialogShowing(context)) {
      Navigator.of(context, rootNavigator: true).pop(true);
    }
  }

  showPopup(BuildContext context, StateRendererType stateRendererType,
      String message,{String title = Constants.empty}) {
    WidgetsBinding.instance.addPostFrameCallback((_) => showDialog(
        context: context,
        builder: (BuildContext context) => StateRenderer(
            stateRendererType: stateRendererType,
            message: message,
            title: title,
            retryActionFunction: () {})));
  }
}
