
enum EmotionState { good, bad, veryBad }

String getFormattedEmotionText(EmotionState emotion) {
  // Get the raw text from the enum
  String rawText = emotion.toString().split('.').last;

  if (rawText == 'veryBad') {
    // Split 'veryBad' into 'VERY BAD'
    return 'VERY BAD';
  } else {
    // Just uppercase the other emotions
    return rawText.toUpperCase();
  }
}