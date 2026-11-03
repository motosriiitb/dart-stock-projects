import 'dart:convert';
import 'dart:io';

// Stock watchlist with a target price for each symbol.
// Data is stored in watchlist.json.

final file = File('watchlist.json');
Map<String, double> watchlist = {};

void loadData() {
  if (!file.existsSync()) return;
  final data = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
  watchlist = data.map((k, v) => MapEntry(k, (v as num).toDouble()));
}

void saveData() {
  file.writeAsStringSync(jsonEncode(watchlist));
}

String ask(String label) {
  stdout.write('$label: ');
  return stdin.readLineSync()?.trim() ?? '';
}

void main() {
  loadData();

  while (true) {
    print('\n1. Add / update stock');
    print('2. Remove stock');
    print('3. Show watchlist');
    print('4. Check against a live price');
    print('5. Exit');
    final choice = ask('Choose');

    if (choice == '1') {
      final symbol = ask('Symbol').toUpperCase();
      final target = double.tryParse(ask('Target price'));
      if (symbol.isEmpty || target == null) {
        print('Invalid input.');
        continue;
      }
      watchlist[symbol] = target;
      saveData();
      print('Saved $symbol with target $target');
    } else if (choice == '2') {
      final symbol = ask('Symbol').toUpperCase();
      if (watchlist.remove(symbol) != null) {
        saveData();
        print('Removed $symbol');
      } else {
        print('$symbol is not in the list.');
      }
    } else if (choice == '3') {
      if (watchlist.isEmpty) {
        print('Watchlist is empty.');
      } else {
        watchlist.forEach((symbol, target) {
          print('${symbol.padRight(12)} target: $target');
        });
      }
    } else if (choice == '4') {
      final symbol = ask('Symbol').toUpperCase();
      final target = watchlist[symbol];
      if (target == null) {
        print('$symbol is not in the list.');
        continue;
      }
      final price = double.tryParse(ask('Current price'));
      if (price == null) {
        print('Invalid price.');
        continue;
      }
      if (price >= target) {
        print('$symbol has reached the target!');
      } else {
        final away = ((target - price) / price * 100).toStringAsFixed(1);
        print('$symbol is $away% away from the target.');
      }
    } else if (choice == '5') {
      print('Bye!');
      break;
    } else {
      print('Invalid choice.');
    }
  }
}
