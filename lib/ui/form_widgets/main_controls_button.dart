import 'package:flutter/material.dart';
import 'package:flutter_application_2/ui/view_model/user_form_vm.dart';
import 'package:provider/provider.dart';

class MainControlsButton extends StatelessWidget {
  final ControlsDetails details;
  final int stepPage;
  const MainControlsButton({
    super.key,
    required this.details,
    required this.stepPage,
  });

  @override
  Widget build(BuildContext context) {
    print("name rebuilkd");
    context.watch<UserFormVm>().userName;

    return Column(
      children: [
        ElevatedButton(
          onPressed: context.watch<UserFormVm>().validateAndContinue(
            stepPage,
            details.onStepContinue,
          ),
          child: Text(stepPage == 5 ? "Submit" : "Save and continue"),
        ),

        TextButton(onPressed: details.onStepCancel, child: Text("Cancel")),
      ],
    );
  }
}
