class InsulinDose {
  InsulinDose({required this.type, required this.dose});

  String type;
  int dose;
}

class InsulinListData {
  InsulinListData({
    required this.imagePath,
    required this.titleTxt,
    required this.insulinDoses,
    required this.startColor,
    required this.endColor,
    required this.kacl,
  });

  String imagePath;
  String titleTxt;
  List<InsulinDose> insulinDoses;
  String startColor;
  String endColor;
  int kacl;

  static List<InsulinListData> insulinList = <InsulinListData>[
    InsulinListData(
      imagePath: 'assets/fitness_app/breakfast.png',
      titleTxt: 'Sabah',
      insulinDoses: [
        InsulinDose(type: 'Hızlı Etkili', dose: 5),
        InsulinDose(type: 'Bazal', dose: 5),
      ],
      startColor: '#FA7D82',
      endColor: '#FFB295',
      kacl: 0,
    ),
    InsulinListData(
      imagePath: 'assets/fitness_app/lunch.png',
      titleTxt: 'Öğle',
      insulinDoses: [
        InsulinDose(type: 'Hızlı Etkili', dose: 8),
      ],
      startColor: '#738AE6',
      endColor: '#5C5EDD',
      kacl: 0,
    ),
    InsulinListData(
      imagePath: 'assets/fitness_app/dinner.png',
      titleTxt: 'Akşam',
      insulinDoses: [
        InsulinDose(type: 'Hızlı Etkili', dose: 6),
        InsulinDose(type: 'Bazal', dose: 6),
      ],
      startColor: '#FE95B6',
      endColor: '#FF5287',
      kacl: 0,
    ),
    InsulinListData(
      imagePath: 'assets/fitness_app/snack.png',
      titleTxt: 'Gece',
      insulinDoses: [
        InsulinDose(type: 'Bazal', dose: 6),
      ],
      startColor: '#6F72CA',
      endColor: '#1E1466',
      kacl: 0,
    ),
  ];

  void addInsulinDose(String type, int dose) {
    insulinDoses.add(InsulinDose(type: type, dose: dose));
  }
}
