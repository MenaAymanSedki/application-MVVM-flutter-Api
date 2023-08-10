import 'dart:async';

import 'package:advanced_mvvm_flutter_api/domain/model/models.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../base/baseviewmodel.dart';
import '../../resources/assets_manager.dart';
import '../../resources/strings_manager.dart';

class OnBoardingViewModel extends BaseViewModel
    with OnBoardingViewModelInputs, OnBoardingViewModelOutputs {
  // stream controllers outputs.
  final StreamController _streamController = StreamController<SliderViewObject>();
  late final List<SliderObject> _list;
  int _currentIndex = 0;

  // OnBoarding Viewmodel Inputs
  @override
  void dispose() {
    _streamController.close();
  }

  @override
  void start() {
    // view model start your job
    _list = _getSliderData();
    _postDataToView();
    // call user API
  }

  @override
  void onPageChanged(int index) {
    _currentIndex = index;
    _postDataToView();
  }

  // onBoardig ViewModel outputs

  @override
  
  Sink get inputSliderViewobject => _streamController.sink;


  @override

   Stream<SliderViewObject> get OutputSliderViewObject =>
    
      _streamController.stream.map((SliderViewObject) => SliderViewObject);

  // onboarding private funcation
  void _postDataToView() {
    inputSliderViewobject.add(
        SliderViewObject(_list[_currentIndex], _list.length, _currentIndex));
  }

  List<SliderObject> _getSliderData() => [
        SliderObject(
            title: AppStrings.onBoaridngSubTitle1.tr(),
            SubTitle: AppStrings.onBoaridngSubTitle1.tr(),
            image: ImageAssets.onboardingLogo1),
        SliderObject(
            title: AppStrings.onBoaridngSubTitle2.tr(),
            SubTitle: AppStrings.onBoaridngSubTitle2.tr(),
            image: ImageAssets.onboardingLogo2),
        SliderObject(
            title: AppStrings.onBoaridngSubTitle3.tr(),
            SubTitle: AppStrings.onBoaridngSubTitle3.tr(),
            image: ImageAssets.onboardingLogo3),
        SliderObject(
            title: AppStrings.onBoaridngSubTitle4.tr(),
            SubTitle: AppStrings.onBoaridngSubTitle4.tr(),
            image: ImageAssets.onboardingLogo4)
      ];

  @override
  int goNext() {
    int previousIndex = --_currentIndex;
    if (previousIndex == -1) {
      previousIndex = _list.length - 1;
    }
    return previousIndex;
  }

  @override
  int goPrevious() {
    int nextIndex = ++_currentIndex;
    if (nextIndex == _list.length) {
      nextIndex = 0;
    }
    return nextIndex;
  }
}

// inputs mean that "Orders" that our view model will recive from view

abstract class OnBoardingViewModelInputs {
  int goNext(); // when user clicks on right arrow or swipe left
  int goPrevious(); // when user clicks on left arrow swipe right
  void onPageChanged(int index);
  // stream controller input
  Sink get inputSliderViewobject;
}

abstract class OnBoardingViewModelOutputs {
  // stream controlller outputs
  Stream<SliderViewObject> get OutputSliderViewObject;
}
