import 'package:flutter/material.dart';

class SliderLabel extends StatelessWidget {
  const SliderLabel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Text.rich(TextSpan(children: [
          TextSpan(
              text: "Arrastra para seleccionar el número de horas necesarias:",
              style: TextStyle(fontSize: 20, height: 1)),
          WidgetSpan(
              child: Tooltip(
            message: "Por ejemplo lavadora: 2.5h",
            triggerMode: TooltipTriggerMode.tap,
            child: Icon(IconData(0xe309,
                fontFamily: 'MaterialIcons', matchTextDirection: true)),
          ))
        ])));
  }
}
