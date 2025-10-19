import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:string_validator/string_validator.dart';

import 'calculator_info.dart';

class CalculatorInfoBloc
    extends Bloc<CalculatorInfoEvent, CalculatorInfoState> {
  CalculatorInfoBloc() : super(CalculatorInfoLoading()) {
    on<InitCalculatorInfo>((event, emit) async {
      String userInput = "";
      String lastResult = "";
      bool didCalculate = false;
      final List<String> buttons = [
        'AC',
        '+/-',
        '%',
        '/',
        '7',
        '8',
        '9',
        'x',
        '4',
        '5',
        '6',
        '-',
        '1',
        '2',
        '3',
        '+',
        "",
        '0',
        '.',
        '=',
      ];

      emit(
        CalculatorInfoLoaded(
          userInput: userInput,
          lastResult: lastResult,
          buttons: buttons,
          didCalculate: didCalculate,
        ),
      );
    });
    on<OnClickItemEvent>((event, emit) async {
      if (state is CalculatorInfoLoaded) {
        String userInput = (state as CalculatorInfoLoaded).userInput;
        String lastResult = (state as CalculatorInfoLoaded).lastResult;
        List<String> buttons = (state as CalculatorInfoLoaded).buttons;
        bool didCalculate = (state as CalculatorInfoLoaded).didCalculate;

        {
          if (event.index == 0) {
            userInput = "0";
            lastResult = "";
          } else if (event.index == 1) {
            if (userInput[0] == "-") {
              userInput = userInput.substring(1);
              if (int.parse(userInput) < 0) {
                userInput = "+$userInput";
              }
            } else if (int.parse(userInput) > 0) {
              userInput = "-$userInput";
            }
          } else if (event.index == 19) {
            if (userInput.contains("%")) {
              userInput = calculatePercentage(userInput);
            }
            try {
              userInput = calculate(
                userInput,
                event.index,
                didCalculate,
                lastResult,
              );
              didCalculate = !didCalculate;
              print(didCalculate);
            } catch (e) {
              userInput = "Wrong Input";
            }
          } else if (didCalculate == true && isNumeric(buttons[event.index])) {
            userInput = buttons[event.index];
            didCalculate = !didCalculate;
            lastResult = "";
          } else if (didCalculate == true && !isNumeric(buttons[event.index])) {
            userInput += buttons[event.index];
            didCalculate = !didCalculate;
          } else if (userInput == "Wrong Input") {
            userInput = buttons[event.index];
          } else if (userInput == "0") {
            userInput = buttons[event.index];
          } else {
            if (userInput.isNotEmpty &&
                !isNumeric(userInput[userInput.length - 1]) &&
                !isNumeric(buttons[event.index])) {
              userInput = userInput.substring(0, userInput.length - 1);
              userInput += buttons[event.index];
              // 7 * /
            } else {
              userInput += buttons[event.index];
            }
          }
        }
        ;
        emit(
          CalculatorInfoLoaded(
            userInput: userInput,
            lastResult: lastResult,
            buttons: buttons,
            didCalculate: didCalculate,
          ),
        );
      }
    });
  }

  String calculate(
    String button,
    int index,
    bool didCalculate,
    String lastResult,
  ) {
    String finalUserInput = button;
    finalUserInput = button.replaceAll('x', '*');

    GrammarParser p = GrammarParser();
    Expression exp = p.parse(finalUserInput);
    ContextModel cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);
    var answer = eval.toString();
    didCalculate = !didCalculate;
    lastResult = button;
    print(answer);
    return answer;
  }

  String calculatePercentage(String input) {
    final regex = RegExp(r'(\d+)\s*([-+*/])\s*(\d+)%');
    final match = regex.firstMatch(input);
    late String value;
    late double percentValue;

    if (match != null) {
      double base = double.parse(match.group(1)!); // 7
      String operator = match.group(2)!; // -
      double percent = double.parse(match.group(3)!); // 4

      percentValue = (percent / 100) * base;
      value = base.toString() + operator + percentValue.toString();
      base = percent = percentValue = 0;
      operator = "";
    }
    return value;
  }
}
