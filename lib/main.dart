import 'package:calculator_project/blocs/calculator_info/calculator_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:string_validator/string_validator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Calculator', home: MyHomePage());
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key}) {
    _calculatorInfoBloc.add(InitCalculatorInfo());
  }

  final CalculatorInfoBloc _calculatorInfoBloc = CalculatorInfoBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white70),
        ),
        child: BlocBuilder(
          bloc: _calculatorInfoBloc,
          builder: (context, state) {
            if (state is CalculatorInfoLoaded) {
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 8),
                      child: Text(
                        state.lastResult,
                        style: TextStyle(color: Colors.white70, fontSize: 18.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 8),
                      child: Text(
                        state.userInput,
                        style: TextStyle(color: Colors.white, fontSize: 28.0),
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                        ),
                        itemBuilder:
                            (_, index) => InkWell(
                              onTap: () {
                                _calculatorInfoBloc.add(
                                  OnClickItemEvent(index: index),
                                );
                              },
                              child: Container(
                                height: 50,
                                width: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(1000),
                                  //color: buttonColor,
                                  color: getButtonColor(index),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    //buttonInput,
                                    state.buttons[index],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                        itemCount: 20,
                        shrinkWrap: true,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  Color getButtonColor(index) {
    if (index <= 0 || index <= 2) {
      return Colors.grey;
    } else if (index == 3 ||
        index == 7 ||
        index == 11 ||
        index == 15 ||
        index == 19) {
      return Colors.orange;
    }
    return Colors.grey.shade500;
  }
}
