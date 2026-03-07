import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_2/ui/view_model/user_form_vm.dart'
    show UserFormVm;
import 'package:provider/provider.dart';
import 'package:flutter_application_2/ui/view/form_widgets/widget_helpers/dob_helpers.dart';

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
      context.read<UserFormVm>().getDobState(widget.stepPage, "");
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.read<UserFormVm>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 50),

        TextFormField(
          onChanged: (value) {
            vm.userDob = value;
            vm.getDobState(widget.stepPage, value);
          },

          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
            //  FilteringTextInputFormatter.deny(RegExp(r'//')),
            LengthLimitingTextInputFormatter(10),
            DateInputFormatter(),
          ],
          controller: vm.dobController,

          validator: (value) {
            return vm.isDobValidator(value) ? null : "Enter valid date";
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
