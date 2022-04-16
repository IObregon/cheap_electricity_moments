import 'package:flutter/material.dart';

import 'pvpc.dart';

class RowPVPC extends StatelessWidget {
  const RowPVPC({Key? key, required this.pvpc, required this.isSelected})
      : super(key: key);
  final PVPC pvpc;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    var cheapestIcon = pvpc.isCheapest
        ? const WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Icon(
              IconData(0xe156, fontFamily: 'MaterialIcons'),
              color: Colors.blue,
            ))
        : const WidgetSpan(child: Text(""));
    return Container(
        height: 30,
        color: isSelected ? Colors.green : Colors.white,
        child: Center(
            child: Text.rich(
          TextSpan(children: [
            cheapestIcon,
            TextSpan(
                text: "${pvpc.hour} => ${pvpc.PCB.toStringAsFixed(5)} €/kWh")
          ]),
        )));
  }
}
