import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import 'pvpc.dart';
import 'list_pvpcs.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DateTime _selectedDate = DateTime.now();
  late Future<List<PVPC>> _futurePVPCs;
  double _hoursNumber = 0.0;

  @override
  void initState() {
    super.initState();
    _futurePVPCs = fetchPVPCs(_selectedDate);
  }

  Future<DateTime?> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(2022),
        lastDate: DateTime.now().add(const Duration(days: 1)),
        locale: const Locale('es'),
        helpText: "Seleccione  fecha");
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _futurePVPCs = fetchPVPCs(picked);
      });
    }
    return picked;
  }

  Future<List<PVPC>> fetchPVPCs(DateTime pickedDate) async {
    final formatter = DateFormat('yyyy/MM/dd');
    final response = await get(Uri.parse(
        'https://api.esios.ree.es/archives/70/download_json?locale=en&date=${formatter.format(pickedDate)}'));
    if (response.statusCode == 200) {
      var pvpcs = jsonDecode(response.body)['PVPC'];
      if (pvpcs == null) return List<PVPC>.from([]);
      return List<PVPC>.from(pvpcs.map((e) => PVPC.fromJson(e)).toList());
    } else {
      throw Exception('Something went wrong.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Cheapest electricity moments'),
          actions: [
            FloatingActionButton(
                child:
                    const Icon(IconData(0xf06bb, fontFamily: 'MaterialIcons')),
                tooltip: "Cambia la fecha:",
                onPressed: () => _selectDate(context)),
          ],
        ),
        body: Container(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                const Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Text("Arrastra para seleccionar el numero de horas necesarias:",
                        style: TextStyle(fontSize: 22))),
                Slider(
                    activeColor: Colors.green,
                    value: _hoursNumber,
                    min: 0.0,
                    max: 20.0,
                    divisions: 40,
                    label: _hoursNumber.toStringAsFixed(1),
                    onChanged: (double value) {
                      setState(() {
                        _hoursNumber = value;
                      });
                    }),
                Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Text(
                        "Fecha Seleccionada: ${printDate(_selectedDate)}",
                        style: const TextStyle(fontSize: 22))),
                Expanded(
                  child: ListPVPCs(
                    futurePVPCs: _futurePVPCs,
                    hoursNumber: _hoursNumber,
                  ),
                )
              ],
            )));
  }

  String printDate(DateTime selectedDate) {
    return DateFormat('dd/MM/yyyy').format(selectedDate);
  }
}
