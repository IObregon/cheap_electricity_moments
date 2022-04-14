import 'package:flutter/material.dart';
import 'pvpc.dart';
import 'PVPC_utils.dart';

class ListPVPCs extends StatefulWidget {
  final Future<List<PVPC>> futurePVPCs;
  final double hoursNumber;

  const ListPVPCs(
      {Key? key, required this.futurePVPCs, required this.hoursNumber})
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
                    child: Text("No hay datos todavia.",
                        style: TextStyle(fontSize: 22))));
          }
          var selectedHours =
              calculateSelectedHours(snapshot.data, widget.hoursNumber);
          return GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 8 / 1,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10),
              shrinkWrap: true,
              itemCount: snapshot.data?.length,
              itemBuilder: (BuildContext context, int index) {
                var data = snapshot.data![index];
                return Container(
                  height: 10,
                  color: selectedHours.contains(index)
                      ? Colors.green
                      : Colors.white,
                  child: Center(
                    child: Text(
                        "${data.hour} => ${data.PCB.toStringAsFixed(5)} €/kWh"),
                  ),
                );
              });
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const CircularProgressIndicator();
      },
    ));
  }
}
