import 'package:flutter/material.dart';
import 'package:flutter_application_2/ui/view_model/user_form_vm.dart';
import 'package:provider/provider.dart';

class MainControlsButton extends StatelessWidget {
  final ControlsDetails details;
  final int stepPage;
  final GlobalKey<FormState> formKey;

  const MainControlsButton({
    super.key,
    required this.details,
    required this.stepPage,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: context.watch<UserFormVm>().tapAndValidate(stepPage)
              ? () {
                  context.read<UserFormVm>().validateAndContinue(
                    stepPage,
                    formKey,
                  );

                  details.onStepContinue?.call();
                }
              : null,

          child: Text(stepPage == 5 ? "Submit" : "Save and continue"),
        ),

        TextButton(onPressed: details.onStepCancel, child: Text("Cancel")),
      ],
    );
  }
}
