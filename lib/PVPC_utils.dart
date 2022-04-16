import 'dart:math';

import 'pvpc.dart';

List<int> calculateSelectedHours(
    List<PVPC>? data, double hoursNumber, int currentHour) {
  if (data == null ||
      data.length < 23 ||
      hoursNumber == 0 ||
      currentHour + hoursNumber.ceil() >= 24) return [-1];
  List<double> pricesSumList =
      calculatePricesSumList(data, hoursNumber, currentHour);
  var bestIndex = pricesSumList.indexOf(pricesSumList.reduce(min));
  return [
    for (var i = bestIndex; i <= bestIndex + hoursNumber.ceil() - 1; i++) i
  ];
}

List<double> calculatePricesSumList(
    List<PVPC> data, double hoursNumber, int currentHour) {
  List<double> pricesSumList = initializeExcludingPassedHours(currentHour);
  for (var i = currentHour + 1; i <= data.length - hoursNumber.ceil(); i++) {
    pricesSumList.add(calculateSum(i, hoursNumber, data));
  }
  return pricesSumList;
}

List<double> initializeExcludingPassedHours(int currentHour) {
  return Iterable<double>.generate(currentHour + 1, (_) => double.maxFinite)
      .toList();
}

double calculateSum(int i, double hoursNumber, List<PVPC> data) {
  return data
      .skip(i)
      .take(hoursNumber.ceil())
      .fold<double>(0.0, (value, element) => element.PCB + value);
}

int calculateCurrentHour(DateTime currentDate, DateTime selectedDate) {
  if (!isTheSameDay(currentDate, selectedDate)) {
    return 0;
  }
  return currentDate.hour;
}

bool isTheSameDay(DateTime currentDate, DateTime selectedDate) {
  return DateTime(currentDate.year, currentDate.month, currentDate.day)
          .difference(
              DateTime(selectedDate.year, selectedDate.month, selectedDate.day))
          .inDays ==
      0;
}
