import 'package:money_formatter/money_formatter.dart';

class Formatter {
  String converter(double amount) {
    MoneyFormatter fmf = MoneyFormatter(amount: amount);
    MoneyFormatterOutput fo = fmf.output;
    return fo.nonSymbol; // keeps decimals like 3.50
  }
}

