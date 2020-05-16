import 'dart:math';

import 'package:dashboard_template/entities/transaction.dart';
import 'package:fl_chart/fl_chart.dart';

Random random = Random();
List<FlSpot> totalReceived = List.generate(
    7, (index) => FlSpot(index.toDouble(), random.nextInt(10) * 100.0));
List<FlSpot> totalRedeem = List.generate(
    7, (index) => FlSpot(index.toDouble(), random.nextInt(10) * 100.0));

List<Transaction> transactions = List.generate(20, (index) {
  bool isRedeem = random.nextBool();
  String name = isRedeem ? "Redeem PS" : "Awarded Point";
  double point = isRedeem ? -140000.0 : (random.nextInt(9) + 1) * 100.0;
  return Transaction(
      name: name,
      point: point,
      createdMillis: DateTime.now()
          .add(Duration(
            days: -random.nextInt(7),
            hours: -random.nextInt(23),
            minutes: -random.nextInt(59),
          ))
          .millisecondsSinceEpoch);
})
  ..sort((v1, v2) => v2.createdMillis - v1.createdMillis);
