import 'dart:io';

// Calculates profit/loss on a single trade, including brokerage.

double readNumber(String label) {
  while (true) {
    stdout.write('$label: ');
    final input = stdin.readLineSync();
    final value = double.tryParse(input ?? '');
    if (value != null && value > 0) return value;
    print('Please enter a valid positive number.');
  }
}

void main() {
  print('--- Trade P&L Calculator ---');

  final buyPrice = readNumber('Buy price per share');
  final sellPrice = readNumber('Sell price per share');
  final quantity = readNumber('Quantity');
  final brokeragePercent = readNumber('Brokerage % (per side)');

  final invested = buyPrice * quantity;
  final sellValue = sellPrice * quantity;

  // brokerage is charged on both buy and sell
  final brokerage = (invested + sellValue) * brokeragePercent / 100;
  final netPnl = sellValue - invested - brokerage;
  final returnPercent = (netPnl / invested) * 100;

  print('\nInvested      : ${invested.toStringAsFixed(2)}');
  print('Sell value    : ${sellValue.toStringAsFixed(2)}');
  print('Brokerage     : ${brokerage.toStringAsFixed(2)}');
  print('Net P&L       : ${netPnl.toStringAsFixed(2)}');
  print('Return        : ${returnPercent.toStringAsFixed(2)}%');
  print(netPnl >= 0 ? 'Result: PROFIT' : 'Result: LOSS');
}
