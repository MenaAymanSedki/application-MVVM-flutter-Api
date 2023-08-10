import 'dart:async';
import 'dart:ffi';

import 'package:advanced_mvvm_flutter_api/domain/model/models.dart';
import 'package:advanced_mvvm_flutter_api/domain/usecase/home_usecase.dart';
import 'package:advanced_mvvm_flutter_api/presentation/base/baseviewmodel.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../common/state_rendrer/state_renderer.dart';
import '../../../../common/state_rendrer/state_rendrer_impl.dart';

class HomeViewModel extends BaseViewModel
    with HomeViewModelInput, HomeViewModelOutput {
  final _dataStreamController = BehaviorSubject<HomeViewObject>();

  final HomeUsecase _homeUsecase;
  HomeViewModel(this._homeUsecase);

  // -- inputs

  @override
  void start() {
    _getHomeData();
  }

  _getHomeData() async {
    inputState.add(LoadingState(
        stateRendererType: StateRendererType.popupLoadingState));
    (await _homeUsecase.execute(Void)).fold(
        (failure) => {
              // left -> failure
              inputState.add(ErrorState(
                  StateRendererType.fullScreenErrorState, failure.message))
            }, (homeObject) {
              inputState.add(ContentState());
              inputHomeData.add(HomeViewObject(homeObject.data.stores,homeObject.data.services,homeObject.data.banners));
      // right -> data (success)
      // content

      // navigate to main screen
    });
  }

  @override
  void dispose() {
    _dataStreamController.close();
    super.dispose();
  }

  @override
  Sink get inputHomeData => _dataStreamController.sink;

  @override
  Stream<HomeViewObject> get outputHomeData =>
      _dataStreamController.stream.map((data) => data);

  // outputs
}

abstract class HomeViewModelInput {
  Sink get inputHomeData;
}

abstract class HomeViewModelOutput {
  Stream<HomeViewObject> get outputHomeData;
}

class HomeViewObject {
  List<Store> stores;
  List<Service> services;
  List<BannerAd> banners;

  HomeViewObject(this.stores, this.services, this.banners);
}
