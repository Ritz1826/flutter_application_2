import 'package:flutter/material.dart';
import 'package:flutter_application_2/ui/view_model/user_form_vm.dart';
import 'package:provider/provider.dart';

class GenderRadio extends StatelessWidget {
  const GenderRadio({super.key});

  static const List<String> _radioOptions = ["Male", "Female", "Other"];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 50),

        Selector<UserFormVm, String?>(
          selector: (context, x) => x.userGender,
          builder: (context, data, child) {
            return RadioGroup<String>(
              onChanged: (value) {
                context.read<UserFormVm>().userGender = value;
              },

              groupValue: data,

              child: Column(
                children: [
                  RadioListTile(
                    value: _radioOptions[0],
                    title: Text(_radioOptions[0]),
                  ),
                  SizedBox(height: 20),
                  RadioListTile(
                    value: _radioOptions[1],
                    title: Text(_radioOptions[1]),
                  ),
                  SizedBox(height: 20),
                  RadioListTile(
                    value: _radioOptions[2],
                    title: Text(_radioOptions[2]),
                  ),
                ],
              ),
            );
          },
        ),

        SizedBox(height: 50),
      ],
    );
  }
}
