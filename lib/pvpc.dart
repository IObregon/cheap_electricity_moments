class PVPC {
  final String hour;
  final double pcb;
  bool isCheapest = false;

  PVPC({
    required this.hour,
    required this.pcb,
  });

  factory PVPC.fromJson(Map<String, dynamic> json) {
    return PVPC(
      hour: json['Hora'].toString().split('-')[0],
      pcb: (double.parse(json['PCB'].toString().replaceAll(',', '.')) / 1000),
    );
  }
}