import 'package:flutter/material.dart';
import 'package:flutter_application_2/ui/view_model/user_form_vm.dart';
import 'package:go_router/go_router.dart';
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

  Future<bool> callDialog(BuildContext context) async {
    final shouldProceed = await showModalBottomSheet(
      backgroundColor: Theme.of(context).canvasColor,
      elevation: 50,
      enableDrag: false,
      isDismissible: false,
      showDragHandle: true,

      // scrollControlDisabledMaxHeightRatio: 0.3,
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 40),
              Text("Confirmation required"),

              SizedBox(height: 80),
              Text("Are you sure ?"),

              SizedBox(height: 10),
              Text("Are you sure you want to submit changes..."),

              SizedBox(height: 40),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextButton(
                      onPressed: () => context.pop(false),
                      child: Text("No"),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () => context.pop(true),
                      child: Text("Yes"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );

    return shouldProceed;
  }

  void callSnackBar(e, context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(e.toString())));
  }

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
                    shouldProceed: () => callDialog(context),
                    onError: (e) => callSnackBar(e, context),
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
