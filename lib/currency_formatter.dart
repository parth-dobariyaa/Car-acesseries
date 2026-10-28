/// Indian Rupee (INR) Currency Formatter
/// Formats numbers according to the Indian numbering system (Lakhs, Crores) with the ₹ symbol.
String formatINR(num amount, {bool showDecimals = false}) {
  final isNegative = amount < 0;
  final absAmount = amount.abs();
  final integerPart = absAmount.floor().toString();
  final decimalPart = (absAmount - absAmount.floor()).toStringAsFixed(2).substring(1);

  String formattedInt;
  if (integerPart.length <= 3) {
    formattedInt = integerPart;
  } else {
    final lastThree = integerPart.substring(integerPart.length - 3);
    final remaining = integerPart.substring(0, integerPart.length - 3);
    final buffer = StringBuffer();
    for (int i = 0; i < remaining.length; i++) {
      if (i > 0 && (remaining.length - i) % 2 == 0) {
        buffer.write(',');
      }
      buffer.write(remaining[i]);
    }
    formattedInt = '${buffer.toString()},$lastThree';
  }

  final prefix = isNegative ? '-₹' : '₹';
  return showDecimals ? '$prefix$formattedInt$decimalPart' : '$prefix$formattedInt';
}
