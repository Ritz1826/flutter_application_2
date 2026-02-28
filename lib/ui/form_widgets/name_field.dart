import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_2/ui/view_model/user_form_vm.dart';
import 'package:provider/provider.dart';

class NameField extends StatefulWidget {
  const NameField({super.key});

  @override
  State<NameField> createState() => _NameFieldState();
}

class _NameFieldState extends State<NameField> {
  @override
  Widget build(BuildContext context) {
    final vm = context.read<UserFormVm>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 50),

        TextFormField(
          onChanged: (value) {
            vm.userName = value;
          },
          inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'[0-9]'))],
          controller: vm.nameController,
          maxLength: 10,
          validator: (value) {
            if ((value?.length ?? 0) <= 2) {
              vm.isNameValid = false;
              return "Enter valid name";
            } else {
              vm.isNameValid = true;
              return null;
            }
          },
          decoration: InputDecoration(
            hintText: "Enter here",
            hintStyle: TextStyle(color: Colors.grey),
            contentPadding: EdgeInsets.all(10),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(style: BorderStyle.solid),
            ),
            filled: true,
            fillColor: const Color.fromARGB(255, 238, 231, 251),
            prefixIcon: Icon(Icons.person),
            prefixIconColor: Colors.deepPurple,
          ),
          buildCounter:
              (
                context, {
                required currentLength,
                required isFocused,
                required maxLength,
              }) {
                if (currentLength > 2 && currentLength < 5) {
                  return Text(
                    "$currentLength / $maxLength",
                    style: TextStyle(color: Colors.orange),
                  );
                } else if (currentLength > 4) {
                  return Text(
                    "$currentLength / $maxLength",
                    style: TextStyle(color: Colors.red),
                  );
                } else {
                  return Text(
                    "$currentLength / $maxLength",
                    style: TextStyle(color: Colors.black),
                  );
                }
              },
        ),

        Selector<UserFormVm, String?>(
          builder: (context, value, child) {
            return Text(value.toString());
          },
          selector: (x, y) => y.userName,
        ),

        SizedBox(height: 50),
      ],
    );
  }
}
