import 'package:flutter/services.dart';

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text.replaceAll('/', '');

    if (text.length > 8) {
      text = text.substring(0, 8);
      print("this is text $text");
    }

    StringBuffer buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);

      // Insert slash after DD and MM
      if ((i == 1 || i == 3) && i != text.length - 1) {
        buffer.write('/');
      }
    }

    String formatted = buffer.toString();

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class DateValidator {
  bool isValidDate(String? value) {
    final regex = RegExp(
      r'^(0[1-9]|[12][0-9]|3[01])\/(0[1-9]|1[0-2])\/(19|20)\d{2}$',
    );
    if (value == null) {
      return true;
    }
    if (!regex.hasMatch(value)) {
      return false;
    }

    final parts = value.split("/");
    final day = int.parse(parts[0]);
    final month = int.parse(parts[1]);
    final year = int.parse(parts[2]);

    final date = DateTime(year, month, day);

    return date.month == month && date.day == day && date.year == year;
  }
}
