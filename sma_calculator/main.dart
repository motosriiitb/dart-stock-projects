import 'dart:io';

// Simple moving average calculator with a basic crossover signal.

List<double> movingAverage(List<double> prices, int window) {
  final result = <double>[];
  for (int i = 0; i + window <= prices.length; i++) {
    double sum = 0;
    for (int j = i; j < i + window; j++) {
      sum += prices[j];
    }
    result.add(sum / window);
  }
  return result;
}

void main() {
  print('--- SMA Calculator ---');
  stdout.write('Enter closing prices (comma separated): ');
  final line = stdin.readLineSync() ?? '';

  final prices = line
      .split(',')
      .map((s) => double.tryParse(s.trim()))
      .whereType<double>()
      .toList();

  if (prices.length < 3) {
    print('Need at least 3 prices.');
    return;
  }

  stdout.write('Short window (e.g. 3): ');
  final shortWindow = int.tryParse(stdin.readLineSync() ?? '') ?? 3;
  stdout.write('Long window (e.g. 5): ');
  final longWindow = int.tryParse(stdin.readLineSync() ?? '') ?? 5;

  if (longWindow > prices.length || shortWindow >= longWindow) {
    print('Windows are invalid for this much data.');
    return;
  }

  final shortSma = movingAverage(prices, shortWindow);
  final longSma = movingAverage(prices, longWindow);

  print('\nShort SMA ($shortWindow): '
      '${shortSma.map((e) => e.toStringAsFixed(2)).join(', ')}');
  print('Long SMA ($longWindow): '
      '${longSma.map((e) => e.toStringAsFixed(2)).join(', ')}');

  // compare the latest values of both averages
  final latestShort = shortSma.last;
  final latestLong = longSma.last;

  if (latestShort > latestLong) {
    print('\nSignal: BULLISH (short SMA is above long SMA)');
  } else if (latestShort < latestLong) {
    print('\nSignal: BEARISH (short SMA is below long SMA)');
  } else {
    print('\nSignal: NEUTRAL');
  }
}
