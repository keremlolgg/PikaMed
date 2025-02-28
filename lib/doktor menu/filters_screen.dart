import 'package:flutter/material.dart';
import 'doktor_app_thema.dart';
import 'model/hasta_list_data.dart';

class FiltersScreen extends StatefulWidget {
  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  List<PatientListData> patientListData = PatientListData.patientsList;

  // Filtreleme için değişkenler
  RangeValues _ageRange = const RangeValues(20, 60);
  RangeValues _weightRange = const RangeValues(50, 100);
  String selectedDisease = 'All';

  @override
  Widget build(BuildContext context) {
    return Container(
      color: HotelAppTheme.buildLightTheme().scaffoldBackgroundColor,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: <Widget>[
            getAppBarUI(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    ageFilter(),
                    const Divider(height: 1),
                    weightFilter(),
                    const Divider(height: 1),
                    diseaseFilter(),
                    const Divider(height: 1),
                    filteredPatientsList()
                  ],
                ),
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: HotelAppTheme.buildLightTheme().primaryColor,
                  borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 8,
                      offset: const Offset(4, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                    highlightColor: Colors.transparent,
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Center(
                      child: Text(
                        'Apply',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Yaş filtresi
  Widget ageFilter() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Age Range',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.grey,
                fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                fontWeight: FontWeight.normal),
          ),
        ),
        RangeSlider(
          values: _ageRange,
          min: 0,
          max: 100,
          divisions: 100,
          labels: RangeLabels(
            _ageRange.start.round().toString(),
            _ageRange.end.round().toString(),
          ),
          onChanged: (RangeValues values) {
            setState(() {
              _ageRange = values;
              filterPatients();
            });
          },
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  // Kilo filtresi
  Widget weightFilter() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Weight Range',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.grey,
                fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                fontWeight: FontWeight.normal),
          ),
        ),
        RangeSlider(
          values: _weightRange,
          min: 0,
          max: 200,
          divisions: 100,
          labels: RangeLabels(
            _weightRange.start.round().toString(),
            _weightRange.end.round().toString(),
          ),
          onChanged: (RangeValues values) {
            setState(() {
              _weightRange = values;
              filterPatients();
            });
          },
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  // Hastalık filtresi
  Widget diseaseFilter() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Disease Filter',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.grey,
                fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                fontWeight: FontWeight.normal),
          ),
        ),
        DropdownButton<String>(
          value: selectedDisease,
          onChanged: (String? newValue) {
            setState(() {
              selectedDisease = newValue!;
              filterPatients();
            });
          },
          items: <String>['All', 'Diabetes', 'Hypertension', 'Asthma', 'Arthritis', 'None']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  // Filtrelenmiş hasta listesi
  Widget filteredPatientsList() {
    return Column(
      children: patientListData.map((patient) {
        return Visibility(
          visible: patient.age >= _ageRange.start &&
              patient.age <= _ageRange.end &&
              patient.weight >= _weightRange.start &&
              patient.weight <= _weightRange.end &&
              (selectedDisease == 'All' || patient.disease == selectedDisease),
          child: ListTile(
            title: Text(patient.name),
            subtitle: Text('${patient.age} years old, ${patient.disease}'),
          ),
        );
      }).toList(),
    );
  }

  // Hastaları filtreleme
  void filterPatients() {
    setState(() {});
  }

  Widget getAppBarUI() {
    return Container(
      decoration: BoxDecoration(
        color: HotelAppTheme.buildLightTheme().scaffoldBackgroundColor,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              offset: const Offset(0, 2),
              blurRadius: 4.0),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top, left: 8, right: 8),
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(32.0),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.close),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Filters',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
            Container(
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
            ),
          ],
        ),
      ),
    );
  }
}
