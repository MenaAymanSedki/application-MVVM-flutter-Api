import 'package:advanced_mvvm_flutter_api/presentation/resources/assets_manager.dart';
import 'package:advanced_mvvm_flutter_api/presentation/resources/color_manager.dart';
import 'package:advanced_mvvm_flutter_api/presentation/resources/font_manager.dart';
import 'package:advanced_mvvm_flutter_api/presentation/resources/strings_manager.dart';
import 'package:advanced_mvvm_flutter_api/presentation/resources/styles_manager.dart';
import 'package:advanced_mvvm_flutter_api/presentation/resources/values_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

enum StateRendererType {
  // POPUP STATES (DIALOG)
  popupLoadingState,
  popupErrorState,
  popupSuccess,

  // FULL  SCEREEN STATES

  fullScreenLoadingState,
  fullScreenErrorState,
  fullScreenEmptyState,

  // general
  contentState,
}

// ignore: must_be_immutable
class StateRenderer extends StatelessWidget {
  StateRendererType stateRendererType;
  String message;
  String title;
  Function retryActionFunction;
  StateRenderer(
      {required this.stateRendererType,
      this.message = AppStrings.loading,
      this.title = "",
      required this.retryActionFunction});

  @override
  Widget build(BuildContext context) {
    return _getStateWidget(context);
  }

  Widget _getStateWidget(BuildContext context) {
    switch (stateRendererType) {
      case StateRendererType.popupLoadingState:
        return _getPopUpDialog(context,[_getAnimatedImage(JsonAssets.loading)]);
      case StateRendererType.popupErrorState:
    return  _getDialogContent(context, [_getItemsColumn([_getAnimatedImage(JsonAssets.error), _getMessage(message),_getRetryButton(AppStrings.retryAgain.tr(),context)])]);
      case StateRendererType.fullScreenLoadingState:
        return _getItemsColumn([_getAnimatedImage(JsonAssets.loading), _getMessage(message)]);
      case StateRendererType.fullScreenErrorState:
       return _getItemsColumn([_getAnimatedImage(JsonAssets.error), _getMessage(message),_getRetryButton(AppStrings.ok,context)]);
      case StateRendererType.fullScreenEmptyState:
               return _getItemsColumn([_getAnimatedImage(JsonAssets.empty), _getMessage(message)]);

      case StateRendererType.contentState:
       return  Container();
      case StateRendererType.popupSuccess:
      return _getPopUpDialog(context,[
        _getAnimatedImage(JsonAssets.success),
        _getMessage(title),
        _getMessage(message),
        _getRetryButton(AppStrings.ok, context)
      ]);

        default: return Container();
    }
  }

  Widget _getPopUpDialog(BuildContext context,List<Widget> children){
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSize.s14),),
      elevation: AppSize.s1_5,
      backgroundColor:Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: ColorManager.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(AppSize.s14),
          boxShadow: [BoxShadow(
            color: Colors.black38,

          )],
        ),
        child: _getDialogContent(context,children),
      ),
    );

  }
  Widget _getDialogContent(BuildContext context,List<Widget> children){

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children:children,
    );

  }

  Widget _getItemsColumn(List<Widget> children) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }

  Widget _getAnimatedImage(String animationName){
    return SizedBox(
      height: AppSize.s100,
      width: AppSize.s100,
      child: Lottie.asset(animationName) // todo add json image here
    );
  }

  Widget _getMessage(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p8),
        child: Text(
          message,
          style: getRegularStyle(color: ColorManager.black, fontSize: FontSize.s18),
        ),
      ),
    );
  }
  Widget _getRetryButton(String buttonTitle,BuildContext context){
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p18),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(onPressed: (){
            if(stateRendererType == StateRendererType.fullScreenErrorState){
              // call retry function
              retryActionFunction.call();
            }else{ // popup error state
            Navigator.of(context).pop();

            }
          }, child:Text(buttonTitle),)),
      ),
    );
  }
}
