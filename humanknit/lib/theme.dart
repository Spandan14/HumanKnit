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
    [Color(0xfffeefb3), Color(0xfffbbfca), Color(0xffaa767c), Color(0xff875053)],
  ];

  static const PROFILE_THEMES = [
    [Color(0xffc9ffc9), Color(0xff99c2a2), Color(0xff93b1a7), Color(0xff71918d)],
    [Color(0xfff8bdc4), Color(0xfff497da), Color(0xfff679e5), Color(0xfff65be3)],
    [Color(0xffa6fffc), Color(0xff54defd), Color(0xff49c6e5), Color(0xff00bd9d)],
  ];

  static const FRIENDS_THEMES = [
    [Color(0xffc1baff), Color(0xffa2d6f9), Color(0xff6c7bff), Color(0xfff25740)],
    [Color(0xffcbb3bf), Color(0xfff49d37), Color(0xff3f88c5), Color(0xffd72638)],
    [Color(0xffe5e7e6), Color(0xffb7b5b3), Color(0xffb80c09), Color(0xff6b2b06)],
  ];

  static const COMMUNITY_THEMES = [
    [Color(0xffc3d1ff), Color(0xff35ce8d), Color(0xfff25740), Color(0xff7348a6)],
    [Color(0xfff5ee9e), Color(0xfff49e4c), Color(0xff3b8ea5), Color(0xffab3428)],
    [Color(0xffedaf97), Color(0xffa2d729), Color(0xffde0d92), Color(0xff4d6cfa)],
  ];

  static const SETTINGS_THEMES = [
    [Color(0xfffeefb3), Color(0xffffbfca), Color(0xffaa767c), Color(0xff875053)],
    [Color(0xff92ffb0), Color(0xfff2e863), Color(0xffffb300), Color(0xff054a91)],
    [Color(0xffd9e5d6), Color(0xffeddea4), Color(0xfff7a072), Color(0xffff9b42)],
  ];

  static void setThemeColors(int themeNum) {
    var themeNumCpy = themeNum;

    THEME_COLORS[3] = SETTINGS_THEMES[themeNumCpy & 3];
    themeNumCpy >>= 2;
    THEME_COLORS[2] = COMMUNITY_THEMES[themeNumCpy & 3];
    themeNumCpy >>= 2;
    THEME_COLORS[1] = FRIENDS_THEMES[themeNumCpy & 3];
    themeNumCpy >>= 2;
    THEME_COLORS[0] = PROFILE_THEMES[themeNumCpy & 3];
  }
}