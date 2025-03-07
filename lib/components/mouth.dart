import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class Mouth extends StatelessWidget {
  final AnimationController emotionController;
  const Mouth({super.key, required this.emotionController});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: emotionController,
      builder: (context, child) {
        double happyHeight = 54;
        double confusedHeight = 30;
        double sadHeight = 30;
        double happyWidth = 36;
        double confusedWidth = 80;
        double sadWidth = 90;
        double height;
        double width;

        if (emotionController.value < 0.5) {
          // happy and confused
          double t = emotionController.value * 2;
          height = lerpDouble(happyHeight, confusedHeight, t)!;
          width = lerpDouble(happyWidth, confusedWidth, t)!;
        } else {
          // confused and sad
          double t = (emotionController.value - 0.5) * 2;
          height = lerpDouble(confusedHeight, sadHeight, t)!;
          width = lerpDouble(confusedWidth, sadWidth, t)!;
        }
        return Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 3,
                offset: Offset(0, 0),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 10,
                spreadRadius: 1,
                offset: Offset(4, 4),
              ),
            ],
          ),
          child: Center(
            child: AnimatedBuilder(
              animation: emotionController,
              builder: (context, child) {
                // inner mouth shape
                double innerHeight;
                double innerWidth;

                if (emotionController.value < 0.5) {
                  // happy and confused
                  double t = emotionController.value * 2;
                  innerHeight = lerpDouble(40, 20, t)!;
                  innerWidth = lerpDouble(24, 70, t)!;
                } else {
                  // confused and sad
                  double t = (emotionController.value - 0.5) * 2;
                  innerHeight = lerpDouble(20, 20, t)!;
                  innerWidth = lerpDouble(70, 80, t)!;
                }

                // border radius for different mouth shapes
                double borderRadius;
                if (emotionController.value < 0.5) {
                  borderRadius =
                      lerpDouble(26, 13, emotionController.value * 2)!;
                } else {
                  if (emotionController.value > 0.8) {
                    borderRadius =
                        lerpDouble(
                          13,
                          26,
                          (emotionController.value - 0.8) * 5,
                        )!;
                  } else {
                    borderRadius = 13;
                  }
                }

                return Container(
                  height: innerHeight,
                  width: innerWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(borderRadius),
                    color: Colors.black.withValues(alpha: 0.7),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pink.withValues(alpha: 0.1),
                        blurRadius: 3,
                        offset: Offset(0, 0),
                      ),
                      BoxShadow(
                        color: Colors.pink.withValues(alpha: 0.4),
                        blurRadius: 10,
                        spreadRadius: 1,
                        offset: Offset(4, 4),
                      ),
                    ],
                  ),
                  child:
                      emotionController.value > 0.67
                          ? LayoutBuilder(
                            builder: (context, constraints) {
                              //  helps prevent overflow by adapting to available space
                              final bool hasEnoughSpace =
                                  constraints.maxHeight > 16;

                              if (!hasEnoughSpace) {
                                return Container(); // return empty container if not enough space :)
                              }

                              // calculate teeth size based on available space
                              final double teethHeight =
                                  constraints.maxHeight > 25
                                      ? 8
                                      : constraints.maxHeight * 0.36;
                              final double teethWidth =
                                  constraints.maxWidth > 50
                                      ? 10
                                      : constraints.maxWidth * 0.15;

                              return Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: List.generate(
                                      constraints.maxWidth ~/ (teethWidth + 4) >
                                              4
                                          ? 4
                                          : constraints.maxWidth ~/
                                              (teethWidth + 4),
                                      (index) {
                                        final delay = (index * 60).ms;
                                        return Container(
                                          height: teethHeight,
                                          width: teethWidth,
                                          margin: EdgeInsets.symmetric(
                                            horizontal: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                index == 1
                                                    ? Colors.black
                                                    : Colors.white,
                                            borderRadius: BorderRadius.vertical(
                                              bottom: Radius.circular(2),
                                            ),
                                          ),
                                        ).animate().scale(delay: delay);
                                      },
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: List.generate(
                                      constraints.maxWidth ~/ (teethWidth + 4) >
                                              4
                                          ? 4
                                          : constraints.maxWidth ~/
                                              (teethWidth + 4),
                                      (index) {
                                        final delay = (index * 60).ms;
                                        return Container(
                                          height: teethHeight,
                                          width: teethWidth,
                                          margin: EdgeInsets.symmetric(
                                            horizontal: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(2),
                                            ),
                                          ),
                                        ).animate().scale(delay: delay);
                                      },
                                    ),
                                  ),
                                ],
                              );
                            },
                          )
                          : Container(),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
