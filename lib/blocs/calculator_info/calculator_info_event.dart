import 'package:flutter/cupertino.dart';

@immutable
abstract class CalculatorInfoEvent {
  const CalculatorInfoEvent([props = const []]) : super();
}

class InitCalculatorInfo extends CalculatorInfoEvent {
  @override
  String toString() => 'InitCalculatorInfo';
}

class OnClickItemEvent extends CalculatorInfoEvent {
  final int index;

  const OnClickItemEvent({required this.index});
  @override
  String toString() => 'OnClickItemEvent';
}
