import 'dart:io';
import 'dart:math';

// SIP (Systematic Investment Plan) future value calculator.

void main() {
  print('--- SIP Calculator ---');

  stdout.write('Monthly investment (Rs): ');
  final monthly = double.tryParse(stdin.readLineSync() ?? '') ?? 0;
  stdout.write('Expected annual return (%): ');
  final annualRate = double.tryParse(stdin.readLineSync() ?? '') ?? 0;
  stdout.write('Time period (years): ');
  final years = int.tryParse(stdin.readLineSync() ?? '') ?? 0;

  if (monthly <= 0 || annualRate <= 0 || years <= 0) {
    print('Please enter positive values.');
    return;
  }

  final r = annualRate / 12 / 100; // monthly rate
  final n = years * 12; // total months

  // FV = P * [((1 + r)^n - 1) / r] * (1 + r)
  final futureValue = monthly * ((pow(1 + r, n) - 1) / r) * (1 + r);
  final invested = monthly * n;
  final gain = futureValue - invested;

  print('\nTotal invested : Rs ${invested.toStringAsFixed(0)}');
  print('Estimated gain : Rs ${gain.toStringAsFixed(0)}');
  print('Future value   : Rs ${futureValue.toStringAsFixed(0)}');
}
