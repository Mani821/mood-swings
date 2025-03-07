import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class Eye extends StatelessWidget {
  final AnimationController emotionController;
  final bool isLeftEye;
  final AnimationController blinkController;
  const Eye({super.key, required this.emotionController, required this.isLeftEye, required this.blinkController});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Bahar wali eye container (gray background) (Outer eye)
        Container(
          height: 55,
          width: 55,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[200],
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
                offset: Offset(10, 12),
              ),
            ],
          ),
        ),
        AnimatedBuilder(
          animation: blinkController,
          builder: (context, child) {
            return Transform.scale(
              scaleY:
              blinkController
                  .value,
              alignment: Alignment.center,
              child: child,
            );
          },
          child: Stack(
            children: [
              // Andar ka safed hissa (white part of eye)
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.1),
                      blurRadius: 3,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
              ),
              AnimatedBuilder(
                animation: emotionController,
                builder: (context, child) {
                  Offset happyBlackPos = Offset(3, 3);
                  Offset confusedBlackPos = Offset(20, 20);
                  Offset sadBlackPos = Offset(15, 15);
                  Offset happyWhitePos = Offset(0, -5);
                  Offset confusedWhitePos = Offset(2.8, 2.8);
                  Offset sadWhitePos = Offset(0, 0);

                  double blackPupilScale;
                  if (emotionController.value < 0.5) {
                    blackPupilScale =
                    lerpDouble(1.0, 1.3, emotionController.value * 2)!;
                  } else {
                    blackPupilScale =
                    lerpDouble(
                      1.3,
                      0.9,
                      (emotionController.value - 0.5) * 2,
                    )!;
                  }

                  double whitePupilScale;
                  if (emotionController.value < 0.5) {
                    whitePupilScale =
                    lerpDouble(.6, .7, emotionController.value * 2)!;
                  } else {
                    whitePupilScale =
                    lerpDouble(
                      .7,
                      .4,
                      (emotionController.value - 0.5) * 2,
                    )!;
                  }

                  Offset blackPupilPosition;
                  if (emotionController.value < 0.5) {
                    double t = emotionController.value * 2;
                    blackPupilPosition = Offset(
                      lerpDouble(happyBlackPos.dx, confusedBlackPos.dx, t)!,
                      lerpDouble(happyBlackPos.dy, confusedBlackPos.dy, t)!,
                    );
                  } else {
                    double t = (emotionController.value - 0.5) * 2;
                    blackPupilPosition = Offset(
                      lerpDouble(confusedBlackPos.dx, sadBlackPos.dx, t)!,
                      lerpDouble(confusedBlackPos.dy, sadBlackPos.dy, t)!,
                    );
                  }

                  Offset whitePupilPosition;
                  if (emotionController.value < 0.5) {
                    double t = emotionController.value * 2;
                    whitePupilPosition = Offset(
                      lerpDouble(happyWhitePos.dx, confusedWhitePos.dx, t)!,
                      lerpDouble(happyWhitePos.dy, confusedWhitePos.dy, t)!,
                    );
                  } else {
                    double t = (emotionController.value - 0.5) * 2;
                    whitePupilPosition = Offset(
                      lerpDouble(confusedWhitePos.dx, sadWhitePos.dx, t)!,
                      lerpDouble(confusedWhitePos.dy, sadWhitePos.dy, t)!,
                    );
                  }

                  return Transform.translate(
                    offset: blackPupilPosition,
                    child: Transform.scale(
                      scale: blackPupilScale,
                      child: Container(
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black,
                        ),
                        child: Transform.translate(
                          offset: whitePupilPosition,
                          child: Transform.scale(
                            scale: whitePupilScale,
                            child: Container(
                              height: 8,
                              width: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    )
        .animate(autoPlay: false, controller: emotionController)
        .moveX(
      duration: 600.ms,
      curve: Curves.easeInOutQuint,
      begin: 0,
      end: isLeftEye ? -30 : 30,
      delay: 200.ms,
    );
  }
}
