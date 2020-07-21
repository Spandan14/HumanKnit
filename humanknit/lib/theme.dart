import 'package:flutter/material.dart';

class AppTheme {
  /*Order:
  Profile Page
  Friends Page
  Community Page
  Settings Page

  Sub Order:
  Background/Content
  Light
  Medium
  Dark
  */
  static var THEME_COLORS = [
    [Color(0xffc9ffc9), Color(0xff99c2a2), Color(0xff93b1a7), Color(0xff71918d)],
    [Color(0xffc1baff), Color(0xffa2d6f9), Color(0xff6c7bff), Color(0xfff25740)],
    [Color(0xffc3d1ff), Color(0xff35ce8d), Color(0xfff25740), Color(0xff7348a6)],
    [Color(0xfffeefb3), Color(0xfffbbfca), Color(0xffaa767c), Color(0xff875053)]
  ];

  static var PROFILE_THEMES = [
    [Color(0xffc9ffc9), Color(0xff99c2a2), Color(0xff93b1a7), Color(0xff71918d)],
  ];

  static const FRIENDS_THEMES = [
    [Color(0xffc1baff), Color(0xffa2d6f9), Color(0xff6c7bff), Color(0xfff25740)],
  ];

  static const COMMUNITY_THEMES = [
    [Color(0xffc3d1ff), Color(0xff35ce8d), Color(0xfff25740), Color(0xff7348a6)],
  ];

  static const SETTINGS_THEMES = [
    [Color(0xfffeefb3), Color(0xffffbfca), Color(0xffaa767c), Color(0xff875053)],
  ];
}