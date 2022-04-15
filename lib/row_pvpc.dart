import 'package:flutter/material.dart';

import 'pvpc.dart';

class RowPVPC extends StatelessWidget {
  const RowPVPC({Key? key, required this.pvpc, required this.isSelected})
      : super(key: key);
  final PVPC pvpc;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 30,
        color: isSelected ? Colors.green : Colors.white,
        child: Center(
          child: Text("${pvpc.hour} => ${pvpc.PCB.toStringAsFixed(5)} €/kWh"),
        ));
  }
}
