class PVPC {
  final String hour;
  final double PCB;

  const PVPC({
    required this.hour,
    required this.PCB,
  });

  factory PVPC.fromJson(Map<String, dynamic> json) {
    return PVPC(
      hour: json['Hora'].toString().split('-')[0],
      PCB: (double.parse(json['PCB'].toString().replaceAll(',', '.')) / 1000),
    );
  }
}