import 'package:flutter/material.dart';

class TabIconData {
  TabIconData({
    this.imagePath = '',
    this.index = 0,
    this.selectedImagePath = '',
    this.isSelected = false,
    this.animationController,
  });

  String imagePath;
  String selectedImagePath;
  bool isSelected;
  int index;

  AnimationController? animationController;

  static List<TabIconData> tabIconsList = <TabIconData>[
    TabIconData(
      imagePath: 'assets/fitness_app/insulin.png',
      selectedImagePath: 'assets/fitness_app/insulin.png',
      index: 0,
      isSelected: true,
      animationController: null,
    ),
    TabIconData(
      imagePath: 'assets/fitness_app/glass.png',
      selectedImagePath: 'assets/fitness_app/glass.png',
      index: 1,
      isSelected: false,
      animationController: null,
    ),
    TabIconData(
      imagePath: 'assets/fitness_app/bosluk.png',
      selectedImagePath: 'assets/fitness_app/bosluk.png',
      index: 2,
      isSelected: false,
      animationController: null,
    ),
    TabIconData(
      imagePath: 'assets/fitness_app/profile.png',
      selectedImagePath: 'assets/fitness_app/profile.png',
      index: 3,
      isSelected: false,
      animationController: null,
    ),
  ];
}
