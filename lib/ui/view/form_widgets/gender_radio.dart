import 'package:flutter/material.dart';
import 'package:flutter_application_2/ui/view_model/user_form_vm.dart';
import 'package:provider/provider.dart';

class GenderRadio extends StatefulWidget {
  final int stepPage;
  const GenderRadio({super.key, required this.stepPage});

  static const List<String> _radioOptions = ["Male", "Female", "Other"];

  @override
  State<GenderRadio> createState() => _GenderRadioState();
}

class _GenderRadioState extends State<GenderRadio> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<UserFormVm>().getGenderState(widget.stepPage);
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<UserFormVm>().getGenderState(widget.stepPage);
    });
    super.didChangeDependencies();
  }

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
                context.read<UserFormVm>().getGenderState(widget.stepPage);
              },

              groupValue: data,

              child: Column(
                children: [
                  RadioListTile(
                    value: GenderRadio._radioOptions[0],
                    title: Text(GenderRadio._radioOptions[0]),
                  ),
                  SizedBox(height: 20),
                  RadioListTile(
                    value: GenderRadio._radioOptions[1],
                    title: Text(GenderRadio._radioOptions[1]),
                  ),
                  SizedBox(height: 20),
                  RadioListTile(
                    value: GenderRadio._radioOptions[2],
                    title: Text(GenderRadio._radioOptions[2]),
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
