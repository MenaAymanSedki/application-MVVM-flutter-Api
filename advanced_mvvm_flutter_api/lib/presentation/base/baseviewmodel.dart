import 'dart:async';

import 'package:advanced_mvvm_flutter_api/presentation/common/state_rendrer/state_rendrer_impl.dart';

abstract class BaseViewModel extends BaseViewModelInputs with BaseViewModelOutputs{
  // shared variables and functions that will be used through any view model.
  final StreamController _inputStreamController = StreamController<FlowState>.broadcast();

  @override
  // TODO: implement inputState
  Sink get inputState => _inputStreamController.sink;

  @override
  // TODO: implement outputState
  Stream<FlowState> get outputState => _inputStreamController.stream.map((flowState) => flowState);

  @override
  void dispose() {
    _inputStreamController.close();
  }
  


}

abstract class BaseViewModelInputs{
  void start(); // start view model job
  void dispose(); // will be called when view model dies.

  Sink get inputState;

}

abstract class BaseViewModelOutputs{
  Stream<FlowState>get outputState;

}