import 'dart:convert';
import 'dart:io';

// Portfolio tracker. Holdings are saved in portfolio.json
// so they stay between runs.

class Holding {
  String symbol;
  int quantity;
  double buyPrice;
  double currentPrice;

  Holding(this.symbol, this.quantity, this.buyPrice, this.currentPrice);

  double get invested => quantity * buyPrice;
  double get currentValue => quantity * currentPrice;
  double get pnl => currentValue - invested;
  double get pnlPercent => (pnl / invested) * 100;

  Map<String, dynamic> toJson() => {
        'symbol': symbol,
        'quantity': quantity,
        'buyPrice': buyPrice,
        'currentPrice': currentPrice,
      };

  factory Holding.fromJson(Map<String, dynamic> json) => Holding(
        json['symbol'],
        json['quantity'],
        (json['buyPrice'] as num).toDouble(),
        (json['currentPrice'] as num).toDouble(),
      );
}

final file = File('portfolio.json');
List<Holding> holdings = [];

void loadData() {
  if (!file.existsSync()) return;
  final data = jsonDecode(file.readAsStringSync()) as List;
  holdings = data.map((e) => Holding.fromJson(e)).toList();
}

void saveData() {
  file.writeAsStringSync(jsonEncode(holdings.map((h) => h.toJson()).toList()));
}

String ask(String label) {
  stdout.write('$label: ');
  return stdin.readLineSync()?.trim() ?? '';
}

void addHolding() {
  final symbol = ask('Symbol (e.g. RELIANCE)').toUpperCase();
  final qty = int.tryParse(ask('Quantity'));
  final buy = double.tryParse(ask('Buy price'));
  final current = double.tryParse(ask('Current price'));

  if (symbol.isEmpty || qty == null || buy == null || current == null) {
    print('Invalid input, nothing added.');
    return;
  }

  holdings.add(Holding(symbol, qty, buy, current));
  saveData();
  print('Added $symbol.');
}

void updatePrice() {
  final symbol = ask('Symbol to update').toUpperCase();
  final index = holdings.indexWhere((h) => h.symbol == symbol);
  if (index == -1) {
    print('$symbol not found.');
    return;
  }
  final price = double.tryParse(ask('New current price'));
  if (price == null) {
    print('Invalid price.');
    return;
  }
  holdings[index].currentPrice = price;
  saveData();
  print('Updated.');
}

void showPortfolio() {
  if (holdings.isEmpty) {
    print('Portfolio is empty.');
    return;
  }

  double totalInvested = 0;
  double totalValue = 0;

  print('\nSYMBOL      QTY    BUY      NOW      P&L');
  for (final h in holdings) {
    totalInvested += h.invested;
    totalValue += h.currentValue;
    print('${h.symbol.padRight(10)}  '
        '${h.quantity.toString().padRight(5)}  '
        '${h.buyPrice.toStringAsFixed(2).padRight(7)}  '
        '${h.currentPrice.toStringAsFixed(2).padRight(7)}  '
        '${h.pnl.toStringAsFixed(2)} (${h.pnlPercent.toStringAsFixed(1)}%)');
  }

  final totalPnl = totalValue - totalInvested;
  print('\nInvested : ${totalInvested.toStringAsFixed(2)}');
  print('Value    : ${totalValue.toStringAsFixed(2)}');
  print('Total P&L: ${totalPnl.toStringAsFixed(2)}');
}

void main() {
  loadData();

  while (true) {
    print('\n1. Add holding');
    print('2. Update current price');
    print('3. Show portfolio');
    print('4. Exit');
    final choice = ask('Choose');

    if (choice == '1') {
      addHolding();
    } else if (choice == '2') {
      updatePrice();
    } else if (choice == '3') {
      showPortfolio();
    } else if (choice == '4') {
      print('Bye!');
      break;
    } else {
      print('Invalid choice.');
    }
  }
}
