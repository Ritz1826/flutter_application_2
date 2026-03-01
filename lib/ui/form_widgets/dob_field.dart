import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_2/ui/view_model/user_form_vm.dart'
    show UserFormVm;
import 'package:provider/provider.dart';

class DOBField extends StatefulWidget {
  final int stepPage;
  const DOBField({super.key, required this.stepPage});

  @override
  State<DOBField> createState() => _DOBFieldState();
}

class _DOBFieldState extends State<DOBField> {
  bool isValid = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<UserFormVm>().getDobState(widget.stepPage);
    });

    super.initState();
  }

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

  // String getText(String value) {
  //   StringBuffer x = StringBuffer();

  //   print("valueee ${value.length}");

  //   if (value.length == 2) {
  //     x.write("$value/");
  //     return x.toString();
  //   } else if (value.length == 5 && !(value.length > 5)) {
  //     x.write("$value/");
  //     return x.toString();
  //   }

  //   return value;
  // }

  @override
  Widget build(BuildContext context) {
    final vm = context.read<UserFormVm>();

    // TODO: implement build
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 50),

        TextFormField(
          onChanged: (value) {
            vm.userDob = value;

            //  vm.dobController.text = getText(value);
          },

          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
            //  FilteringTextInputFormatter.deny(RegExp(r'//')),
            LengthLimitingTextInputFormatter(10),
            DateInputFormatter(),
          ],
          controller: vm.dobController,

          validator: (value) {
            if (!isValidDate(value)) {
              vm.isDobValid = false;
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                vm.getDobState(widget.stepPage);
              });
              return "Enter valid date";
            } else {
              vm.isDobValid = true;
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                vm.getDobState(widget.stepPage);
              });

              return null;
            }
          },
          decoration: InputDecoration(
            hintText: "Enter dob DD/MM/YYYY",
            hintStyle: TextStyle(color: Colors.grey),
            contentPadding: EdgeInsets.all(10),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(style: BorderStyle.solid),
            ),
            filled: true,
            fillColor: const Color.fromARGB(255, 238, 231, 251),
            prefixIcon: Icon(Icons.calendar_month),
            prefixIconColor: Colors.deepPurple,
          ),
        ),

        Selector<UserFormVm, String?>(
          selector: (context, y) => y.userDob,
          builder: (context, value, child) {
            return Text(value ?? "");
          },
        ),

        SizedBox(height: 50),
      ],
    );
  }
}

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
