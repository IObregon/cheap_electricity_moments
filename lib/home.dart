import 'dart:convert';
import 'dart:math';

import 'package:cheap_electricity_moments/pvpc_utils.dart';
import 'package:cheap_electricity_moments/slider_label.dart';
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
  static const int maxHourNumber = 23;
  DateTime _selectedDate = DateTime.now();
  late Future<List<PVPC>> _futurePVPCs;
  double _hoursNumber = 0.0;
  late int _remainingHours;

  @override
  void initState() {
    super.initState();
    _futurePVPCs = fetchPVPCs(_selectedDate);
    _remainingHours = _calculateRemainingHours(DateTime.now(), DateTime.now());
  }

  int _calculateRemainingHours(DateTime currentDate, DateTime selectedDate) {
    var currentHour = calculateCurrentHour(currentDate, selectedDate);
    return currentHour > -1 ? min((maxHourNumber - currentHour), 20) : 0;
  }

  Future<DateTime?> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(2022),
        lastDate: DateTime.now().add(const Duration(days: 1)),
        locale: const Locale('es'),
        helpText: "Selecciona fecha");
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _hoursNumber = 0;
        _selectedDate = picked;
        _futurePVPCs = fetchPVPCs(picked);
        _remainingHours = _calculateRemainingHours(DateTime.now(), picked);
      });
    }
    return picked;
  }

  Future<List<PVPC>> fetchPVPCs(DateTime pickedDate) async {
    final formatter = DateFormat('yyyy/MM/dd');
    final response = await get(Uri.parse(
        'https://api.esios.ree.es/archives/70/download_json?locale=en&date=${formatter.format(pickedDate)}'));
    if (response.statusCode == 200) {
      var decodedPvpcs = jsonDecode(response.body)['PVPC'];
      if (decodedPvpcs == null) return List<PVPC>.from([]);
      var pvpcs = createListPVPCs(decodedPvpcs);
      return pvpcs;
    } else {
      throw Exception('Something went wrong.');
    }
  }

  List<PVPC> createListPVPCs(decodedPvpcs) {
    var list = List<PVPC>.from(decodedPvpcs.map((e) => PVPC.fromJson(e)));
    var onlyPricesList = list.map((e) => e.pcb).toList();
    var cheapestIndex = onlyPricesList.indexOf(onlyPricesList.reduce(min));
    list[cheapestIndex].isCheapest = true;
    return list;
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
                const SliderLabel(),
                Slider(
                    activeColor: Colors.green,
                    value: _hoursNumber,
                    min: 0.0,
                    max: _remainingHours.toDouble(),
                    divisions: _remainingHours * 2,
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
                    selectedDate: _selectedDate,
                  ),
                )
              ],
            )));
  }

  String printDate(DateTime selectedDate) {
    return DateFormat('dd/MM/yyyy').format(selectedDate);
  }
}
