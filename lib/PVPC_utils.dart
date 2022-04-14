import 'dart:math';

import 'pvpc.dart';

List<int> calculateSelectedHours(List<PVPC>? data, double hoursNumber) {
  if (data == null || data.length < 23 || hoursNumber == 0) return [-1];
  List<double> pricesSumList = calculatePricesSumList(data, hoursNumber);
  var bestIndex = pricesSumList.indexOf(pricesSumList.reduce(min));
  return [
    for (var i = bestIndex; i <= bestIndex + hoursNumber.ceil() - 1; i++) i
  ];
}

List<double> calculatePricesSumList(List<PVPC> data, double hoursNumber) {
  List<double> pricesSumList = [];
  for (var i = 0; i < data.length - hoursNumber.ceil(); i++) {
    pricesSumList.add(calculateSum(i, hoursNumber, data));
  }
  return pricesSumList;
}

double calculateSum(int i, double hoursNumber, List<PVPC> data) {
  return data
      .skip(i)
      .take(hoursNumber.ceil())
      .fold<double>(0.0, (value, element) => element.PCB + value);
}
