class FutureInsulinDose {
  FutureInsulinDose({required this.type, required this.dose, required this.unit});

  String type;
  int dose;
  String unit;
}

class FutureInsulinListData {
  FutureInsulinListData({
    required this.imagePath,
    required this.titleTxt,
    required this.insulinDoses,
    required this.startColor,
    required this.endColor,
  });

  String imagePath;
  String titleTxt;
  List<FutureInsulinDose> insulinDoses;
  String startColor;
  String endColor;

  static List<FutureInsulinListData> insulinList = <FutureInsulinListData>[
    FutureInsulinListData(
      imagePath: 'assets/fitness_app/insulin.png',
      titleTxt: 'Akşam (18:30)',
      insulinDoses: [
        FutureInsulinDose(type: 'Aspart (Hızlı etkili)', dose: 6, unit: 'U'),
        FutureInsulinDose(type: 'Detemir (Bazal)', dose: 6, unit: 'U'),
      ],
      startColor: '#FE95B6',
      endColor: '#FF5287',
    ),
    FutureInsulinListData(
      imagePath: 'assets/fitness_app/insulin.png',
      titleTxt: 'Gece (22:00)',
      insulinDoses: [
        FutureInsulinDose(type: 'Glargin (Bazal)', dose: 6, unit: 'U'),
      ],
      startColor: '#6F72CA',
      endColor: '#1E1466',
    ),
  ];

  void addInsulinDose(String type, int dose,String unit) {
    insulinDoses.add(FutureInsulinDose(type: type, dose: dose,unit: unit));
  }
}
