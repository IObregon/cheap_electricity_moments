import 'dart:convert';

import 'package:cheap_electricity_moments/pvpc.dart';
import 'package:cheap_electricity_moments/PVPC_utils.dart';
import 'package:flutter_test/flutter_test.dart';

import 'pvpc_json.dart';

void main() {
  test('When no data is provided "[-1]" should be returned', () {
    expect(calculateSelectedHours(null, 5), [-1]);
  });
  test('When data is empty "[-1]" should be returned', () {
    expect(calculateSelectedHours([], 5), [-1]);
  });
  test('When data is correct but hourNumber is 0 "[-1]" should be returned',
      () {
    expect(calculateSelectedHours(getValidPVPCs(), 0), [-1]);
  });

  group('CalculateSelectedHours positive cases', () {
    var testCaseInputs = [
      {
        'hours': 0.5,
        'expected': [2]
      },
      {
        'hours': 1.0,
        'expected': [2]
      },
      {
        'hours': 1.5,
        'expected': [2, 3]
      },
      {
        'hours': 3.0,
        'expected': [2, 3, 4]
      },
      {
        'hours': 7.5,
        'expected': [0, 1, 2, 3, 4, 5, 6, 7]
      },
    ];
    for (var testCase in testCaseInputs) {
      test(
          'When data is correct and numberHours is ${testCase["hours"]} result size should be ${(testCase["hours"]! as double).ceilToDouble()}',
          () {
        var result = calculateSelectedHours(
            getValidPVPCs(), (testCase["hours"]! as double).toDouble());
        expect(result.length, (testCase["hours"]! as double).ceilToDouble());
        expect(result, testCase["expected"]);
      });
    }
  });
}

List<PVPC> getValidPVPCs() {
  return List<PVPC>.from(
      jsonDecode(json).map((e) => PVPC.fromJson(e)).toList());
}
