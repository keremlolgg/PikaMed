class PastInsulinDose {
  PastInsulinDose({required this.type, required this.dose, required this.unit});

  String type;
  int dose;
  String unit;
}

class PastInsulinListData {
  PastInsulinListData({
    required this.imagePath,
    required this.titleTxt,
    required this.insulinDoses,
    required this.startColor,
    required this.endColor,
  });

  String imagePath;
  String titleTxt;
  List<PastInsulinDose> insulinDoses;
  String startColor;
  String endColor;

  static List<PastInsulinListData> insulinList = <PastInsulinListData>[
    PastInsulinListData(
      imagePath: 'assets/fitness_app/insulin.png',
      titleTxt: 'Sabah (08:00)',
      insulinDoses: [
        PastInsulinDose(type: 'Aspart (Hızlı etkili)', dose: 5, unit: 'U'),
        PastInsulinDose(type: 'Glargin (Bazal)', dose: 5, unit: 'U'),
      ],
      startColor: '#FA7D82',
      endColor: '#FFB295',
    ),
    PastInsulinListData(
      imagePath: 'assets/fitness_app/insulin.png',
      titleTxt: 'Öğle (12:30)',
      insulinDoses: [
        PastInsulinDose(type: 'Lispro (Hızlı etkili)', dose: 8, unit: 'U'),
      ],
      startColor: '#738AE6',
      endColor: '#5C5EDD',
    ),
  ];

  void addInsulinDose(String type, int dose,String unit) {
    insulinDoses.add(PastInsulinDose(type: type, dose: dose,unit: unit));
  }
}
