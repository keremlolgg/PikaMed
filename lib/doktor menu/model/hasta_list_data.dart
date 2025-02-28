class PatientListData {
  PatientListData({
    this.imagePath = '',
    this.name = '',
    this.age = 0,
    this.weight = 0.0,
    this.height = 0.0,
    this.disease = '',
  });

  String imagePath;
  String name;
  int age;
  double weight; // Kilo
  double height; // Boy
  String disease; // Hastalık

  static List<PatientListData> patientsList = <PatientListData>[
    PatientListData(
      imagePath: 'assets/hasta/hasta_1.png',
      name: 'John Doe',
      age: 45,
      weight: 75.0,
      height: 1.80,
      disease: 'Diyabet',
    ),
    PatientListData(
      imagePath: 'assets/hasta/hasta_2.png',
      name: 'Jane Smith',
      age: 32,
      weight: 65.0,
      height: 1.65,
      disease: 'Hipertansiyon',
    ),
    PatientListData(
      imagePath: 'assets/hasta/hasta_3.png',
      name: 'Michael Johnson',
      age: 61,
      weight: 85.0,
      height: 1.75,
      disease: 'Astım',
    ),
    PatientListData(
      imagePath: 'assets/hasta/hasta_4.png',
      name: 'Emily Davis',
      age: 28,
      weight: 55.0,
      height: 1.68,
      disease: 'Yok',
    ),
    PatientListData(
      imagePath: 'assets/hasta/hasta_5.png',
      name: 'William Brown',
      age: 50,
      weight: 95.0,
      height: 1.80,
      disease: 'Artrit',
    ),
    PatientListData(
      imagePath: 'assets/hasta/hasta_6.png',
      name: 'Olivia Taylor',
      age: 36,
      weight: 60.0,
      height: 1.72,
      disease: 'Yok',
    ),
    PatientListData(
      imagePath: 'assets/hasta/hasta_7.png',
      name: 'Liam Wilson',
      age: 24,
      weight: 70.0,
      height: 1.78,
      disease: 'Migren',
    ),
    PatientListData(
      imagePath: 'assets/hasta/hasta_8.png',
      name: 'Sophia Moore',
      age: 41,
      weight: 80.0,
      height: 1.65,
      disease: 'Yüksek Kolesterol',
    ),
    PatientListData(
      imagePath: 'assets/hasta/hasta_9.png',
      name: 'James Anderson',
      age: 54,
      weight: 92.0,
      height: 1.77,
      disease: 'Kalp Hastalığı',
    ),
    PatientListData(
      imagePath: 'assets/hasta/hasta_10.png',
      name: 'Mia Thomas',
      age: 30,
      weight: 58.0,
      height: 1.70,
      disease: 'Yok',
    ),
  ];
}
