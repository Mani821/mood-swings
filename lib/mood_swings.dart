import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mood_swings/components/eye.dart';
import 'package:mood_swings/components/mouth.dart';
import 'helpers.dart';

class MoodSwings extends StatefulWidget {
  const MoodSwings({super.key});

  @override
  State<MoodSwings> createState() => _MoodSwingsState();
}

class _MoodSwingsState extends State<MoodSwings> with TickerProviderStateMixin {
  late AnimationController emotionController;
  late AnimationController _blinkController;
  bool isBlinking = false;
  EmotionState currentEmotion = EmotionState.good;
  double sliderValue = 0.0;

  void _startRandomBlinking() {
    _blinkController.value = 1.0;
    Future.delayed(Duration(milliseconds: 2000 + Random().nextInt(3000)), () {
      if (!mounted) return;
      setState(() => isBlinking = true);
      _blinkController
          .animateTo(
            0.0,
            duration: Duration(milliseconds: 80),
            curve: Curves.easeIn,
          )
          .then((_) {
            _blinkController
                .animateTo(
                  1.0,
                  duration: Duration(milliseconds: 120),
                  curve: Curves.easeOut,
                )
                .then((_) {
                  setState(() => isBlinking = false);
                  if (Random().nextDouble() < 0.3) {
                    Future.delayed(Duration(milliseconds: 120), () {
                      if (!mounted) return;
                      setState(() => isBlinking = true);
                      _blinkController
                          .animateTo(
                            0.0,
                            duration: Duration(milliseconds: 80),
                            curve: Curves.easeIn,
                          )
                          .then((_) {
                            _blinkController
                                .animateTo(
                                  1.0,
                                  duration: Duration(milliseconds: 120),
                                  curve: Curves.easeOut,
                                )
                                .then((_) {
                                  setState(() => isBlinking = false);
                                  _startRandomBlinking();
                                });
                          });
                    });
                  } else {
                    _startRandomBlinking();
                  }
                });
          });
    });
  }

  @override
  void initState() {
    emotionController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
      value: 0,
    );
    emotionController.addListener(() {
      setState(() {
        sliderValue = emotionController.value;
      });
    });

    _blinkController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
      value: 1.0,
    );
    _startRandomBlinking();

    super.initState();
  }

  // current emotion based on controller value
  EmotionState getCurrentEmotion() {
    if (emotionController.value < 0.33) {
      return EmotionState.good;
    } else if (emotionController.value < 0.67) {
      return EmotionState.bad;
    } else {
      return EmotionState.veryBad;
    }
  }

  // handle slider changes
  void onSliderChanged(double value) {
    setState(() {
      sliderValue = value;
      emotionController.value = value;
      currentEmotion = getCurrentEmotion();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
      ),
      child: Scaffold(
        body: AnimatedBuilder(
          animation: emotionController,
          builder: (context, child) {
            final currentEmotion = getCurrentEmotion();

            // gradient colors based on emotion
            final Color gradientStart;
            final Color gradientEnd;

            if (emotionController.value < 0.5) {
              gradientStart =
                  Color.lerp(
                    Colors.greenAccent, // Good gradient start
                    Colors.orangeAccent, // Bad gradient start
                    emotionController.value * 2,
                  )!;

              gradientEnd =
                  Color.lerp(
                    Colors.green, // Good gradient end
                    Colors.orange, // Bad gradient end
                    emotionController.value * 2,
                  )!;
            } else {
              gradientStart =
                  Color.lerp(
                    Colors.orangeAccent, // Bad gradient start
                    Colors.deepPurpleAccent, // Very Bad gradient start
                    (emotionController.value - 0.5) * 2,
                  )!;

              gradientEnd =
                  Color.lerp(
                    Colors.orange, // Bad gradient end
                    Colors.deepPurple, // Very Bad gradient end
                    (emotionController.value - 0.5) * 2,
                  )!;
            }

            final Color sliderColor;
            if (emotionController.value < 0.5) {
              sliderColor =
                  Color.lerp(
                    Colors.white,
                    Colors.white.withValues(alpha: 0.7),
                    emotionController.value * 2,
                  )!;
            } else {
              sliderColor =
                  Color.lerp(
                    Colors.white.withValues(alpha: 0.7),
                    Colors.white.withValues(alpha: 0.5),
                    (emotionController.value - 0.5) * 2,
                  )!;
            }

            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [gradientStart, gradientEnd],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedSwitcher(
                        duration: 260.ms,
                        transitionBuilder: (child, animation) {
                          return ScaleTransition(
                            scale: animation,
                            child: child,
                          );
                        },
                        child: ShaderMask(
                          key: ValueKey(currentEmotion),
                          shaderCallback: (bounds) {
                            return LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.white,
                                Colors.white,
                                Colors.white.withValues(alpha: 0.1),
                              ],
                            ).createShader(bounds);
                          },
                          child: Text(
                            getFormattedEmotionText(currentEmotion),
                            key: ValueKey(currentEmotion),
                            style: TextStyle(
                              fontSize: 54,
                              fontFamily: 'Cherry',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  offset: Offset(2, 2),
                                  blurRadius: 5.0,
                                  color: Colors.black.withValues(alpha: 0.5),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 80),
                      // Face
                      Container(
                        height: 250,
                        color: Colors.transparent,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Left Eye
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0,
                                  ),
                                  child: Eye(
                                    blinkController: _blinkController,
                                    emotionController: emotionController,
                                    isLeftEye: true,
                                  ),
                                ),

                                // Right Eye
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0,
                                  ),
                                  child: Eye(
                                    blinkController: _blinkController,
                                    emotionController: emotionController,
                                    isLeftEye: false,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 40),
                            Mouth(emotionController: emotionController),
                          ],
                        ),
                      ),
                      SizedBox(height: 60),
                      SliderTheme(
                        data: SliderThemeData(
                          trackHeight: 10,
                          activeTrackColor: sliderColor,
                          inactiveTrackColor: Colors.white.withValues(
                            alpha: 0.3,
                          ),
                          thumbColor: Colors.white,
                          thumbShape: RoundSliderThumbShape(
                            enabledThumbRadius: 15,
                          ),
                          overlayShape: RoundSliderOverlayShape(
                            overlayRadius: 25,
                          ),
                        ),
                        child: Slider(
                          value: sliderValue,
                          onChanged: onSliderChanged,
                          min: 0.0,
                          max: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    emotionController.dispose();
    super.dispose();
  }
}
