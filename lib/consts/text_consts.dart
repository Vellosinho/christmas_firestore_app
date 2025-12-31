import 'package:flutter/material.dart';

abstract class TextStyles {
  TextStyles._();

  static const TextStyle giantTimerText = TextStyle(
    fontFamily: 'PoorStory',
    fontSize: 200,
    color: Colors.white,
    height: 1,
  );

  static const TextStyle giantTimerTextDesktop = TextStyle(
    fontFamily: 'PoorStory',
    fontSize: 200,
    color: Colors.black,
    height: 1,
  );

  static const TextStyle bigText = TextStyle(
    fontFamily: 'PoorStory',
    fontSize: 80,
    color: Colors.black,
    height: 1,
  );

  static const TextStyle roundNumber = TextStyle(
    fontFamily: 'PoorStory',
    fontSize: 120,
    color: Colors.black,
    height: 1,
  );

  static const TextStyle playerNameTextBlack = TextStyle(
    fontFamily: 'PoorStory',
    fontSize: 42,
    color: Colors.black,
    height: 1,
  );

  static const TextStyle playerNameText = TextStyle(
    fontFamily: 'PoorStory',
    fontSize: 64,
    color: Colors.white,
    height: 1,
  );

  static const TextStyle commonText = TextStyle(
    fontFamily: 'PoorStory',
    fontSize: 40,
    height: 1,
  );

  static const TextStyle phoneCommonText = TextStyle(
    fontFamily: 'PoorStory',
    fontSize: 32,
  );

  static const TextStyle phoneButtonText = TextStyle(
    fontFamily: 'PoorStory',
    color: Colors.white,
    fontSize: 32,
  );

  static const TextStyle commonUrlText = TextStyle(
    decoration: TextDecoration.underline,
    fontFamily: 'PoorStory',
    fontSize: 24,
    height: 1,
  );
  
}