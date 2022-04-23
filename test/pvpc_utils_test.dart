import 'dart:convert';

import 'package:cheap_electricity_moments/pvpc.dart';
import 'package:cheap_electricity_moments/pvpc_utils.dart';
import 'package:flutter_test/flutter_test.dart';

import 'pvpc_json.dart';

void main() {
  group("calculateSelectedHours", () {
    test('When no data is provided "[-1]" should be returned', () {
      expect(calculateSelectedHours(null, 5, -1), [-1]);
    });
    test('When data is empty "[-1]" should be returned', () {
      expect(calculateSelectedHours([], 5, -1), [-1]);
    });
    test('When data is correct but hourNumber is 0 "[-1]" should be returned',
        () {
      expect(calculateSelectedHours(getValidPVPCs(), 0, 0), [-1]);
    });

    group('CalculateSelectedHours positive cases', () {
      var testCaseInputs = [
        {
          'hours': 0.5,
          'currentHour': 1,
          'expected': [2]
        },
        {
          'hours': 1.0,
          'currentHour': 3,
          'expected': [6]
        },
        {
          'hours': 1.5,
          'currentHour': 1,
          'expected': [2, 3]
        },
        {
          'hours': 3.0,
          'currentHour': 14,
          'expected': [15, 16, 17]
        },
        {
          'hours': 7.5,
          'currentHour': 1,
          'expected': [2, 3, 4, 5, 6, 7, 8, 9]
        },
        {
          'hours': 1.0,
          'currentHour': 22,
          'expected': [23]
        },
        {
          'hours': 2.0,
          'currentHour': 22,
          'expected': [-1]
        },
      ];
      for (var testCase in testCaseInputs) {
        test(
            'When data is correct and numberHours is ${testCase["hours"]} result size should be ${(testCase["expected"].toString())}',
            () {
          var result = calculateSelectedHours(
              getValidPVPCs(),
              (testCase["hours"]! as double).toDouble(),
              testCase['currentHour'] as int);
          expect(result.length, (testCase["expected"] as List).length);
          expect(result, testCase["expected"]);
        });
      }
    });
  });
  group("calculateCurrentHour", () {
    test("When selectedDate is tomorrow returns 0", () {
      expect(
          calculateCurrentHour(
              DateTime.now(), DateTime.now().add(const Duration(days: 1))),
          0);
    });

    test("When selectedDate is yesterday returns 0", () {
      expect(
          calculateCurrentHour(
              DateTime.now(), DateTime.now().subtract(const Duration(days: 1))),
          0);
    });

    test("When selectedDate is today returns the current hour", () {
      expect(calculateCurrentHour(DateTime.now(), DateTime.now()),
          DateTime.now().hour);
    });
  });
}

List<PVPC> getValidPVPCs() {
  return List<PVPC>.from(
      jsonDecode(json).map((e) => PVPC.fromJson(e)).toList());
}
