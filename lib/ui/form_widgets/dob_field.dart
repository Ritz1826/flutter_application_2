import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_2/ui/view_model/user_form_vm.dart'
    show UserFormVm;
import 'package:provider/provider.dart';

class DOBField extends StatefulWidget {
  const DOBField({super.key});

  @override
  State<DOBField> createState() => _DOBFieldState();
}

class _DOBFieldState extends State<DOBField> {
  bool isValid = false;
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
          },

          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
            FilteringTextInputFormatter.deny(RegExp(r'//')),
            LengthLimitingTextInputFormatter(10),
          ],
          controller: vm.dobController,

          validator: (value) {
            if (!isValidDate(value)) {
              vm.isDobValid = false;
              return "Enter valid date";
            } else {
              vm.isDobValid = true;

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
