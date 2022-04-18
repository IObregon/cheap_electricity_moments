import 'package:flutter/material.dart';
import 'pvpc.dart';
import 'PVPC_utils.dart';
import 'row_pvpc.dart';

class ListPVPCs extends StatefulWidget {
  final Future<List<PVPC>> futurePVPCs;
  final double hoursNumber;
  final DateTime selectedDate;

  const ListPVPCs(
      {Key? key,
      required this.futurePVPCs,
      required this.hoursNumber,
      required this.selectedDate})
      : super(key: key);

  @override
  State<ListPVPCs> createState() => _ListPVPCsState();
}

class _ListPVPCsState extends State<ListPVPCs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<List<PVPC>>(
      future: widget.futurePVPCs,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.isEmpty) {
            return const Center(
                child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Text("No hay datos todavía.",
                        style: TextStyle(fontSize: 22))));
          }
          var selectedHours = calculateSelectedHours(
              snapshot.data,
              widget.hoursNumber,
              calculateCurrentHour(DateTime.now(), widget.selectedDate));
          var firstList = ListView.builder(
              itemCount: (snapshot.data!.length / 2).ceil(),
              itemBuilder: (context, index) {
                return RowPVPC(
                    isSelected: selectedHours.contains(index),
                    pvpc: snapshot.data![index]);
              });
          var secondList = ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                if (index < 12) return Container();
                return RowPVPC(
                    isSelected: selectedHours.contains(index),
                    pvpc: snapshot.data![index]);
              });
          return Row(
            children: <Widget>[
              Flexible(
                child: Container(child: firstList),
              ),
              Flexible(
                child: Container(child: secondList),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const CircularProgressIndicator();
      },
    ));
  }
}
