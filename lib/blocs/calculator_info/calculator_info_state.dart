import 'package:flutter/cupertino.dart';

@immutable
abstract class CalculatorInfoState {
  const CalculatorInfoState() : super();
}

class CalculatorInfoLoading extends CalculatorInfoState {
  @override
  String toString() => 'CalculatorInfoLoading';
}

class CalculatorInfoLoaded extends CalculatorInfoState {
  String userInput;
  String lastResult;
  List<String> buttons;
  bool didCalculate;

  CalculatorInfoLoaded({
    required this.userInput,
    required this.lastResult,
    required this.buttons,
    required this.didCalculate,
  });

  @override
  String toString() => 'CalculatorInfoLoaded';
}

class CalculatorInfoFailed extends CalculatorInfoState {
  @override
  String toString() => 'CalculatorInfoFailed';
}
