import 'package:flutter/services.dart';

class FieldInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    print("newValue:${newValue.text}");
    int startIndex = newValue.text.indexOf("[b]");
    int endIndex = newValue.text.indexOf("[/b]");
    if (startIndex != -1 && endIndex != -1) {
      String rawText = newValue.text;
      String field = rawText.substring(startIndex, endIndex + 1);
      String treatedText = rawText.replaceFirst(field, "字段$field");
      treatedText = treatedText.replaceFirst("[b]", "");
      treatedText = treatedText.replaceFirst("[/b]", "");
      return TextEditingValue(text: treatedText);
      ;
    }
    return newValue;
  }
}
