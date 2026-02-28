import 'package:flutter/material.dart';
import 'package:flutter_application_2/ui/form_widgets/country_autocomplete.dart';
import 'package:flutter_application_2/ui/form_widgets/dob_field.dart';
import 'package:flutter_application_2/ui/form_widgets/gender_radio.dart';
import 'package:flutter_application_2/ui/form_widgets/height_slider.dart';
import 'package:flutter_application_2/ui/form_widgets/hobbies_chips.dart';
import 'package:flutter_application_2/ui/form_widgets/main_controls_button.dart';
import 'package:flutter_application_2/ui/form_widgets/name_field.dart';
import 'package:flutter_application_2/ui/view_model/user_form_vm.dart';
import 'package:provider/provider.dart';

enum ViewType { apple, banana, grapes }

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int _stepPage = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(title: Text("Home")),
        body: Column(
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Stepper(
                  currentStep: _stepPage,
                  onStepContinue: () {
                    if (_stepPage < 5) {
                      setState(() {
                        _stepPage++;
                      });
                    }
                  },
                  onStepCancel: () {
                    if (_stepPage > 0) {
                      setState(() {
                        _stepPage--;
                      });
                    }
                  },

                  onStepTapped: (value) {
                    setState(() {
                      _stepPage = value;
                    });
                  },
                  connectorColor: WidgetStateProperty.all(Colors.deepPurple),
                  controlsBuilder: (context, details) {
                    return MainControlsButton(
                      details: details,
                      stepPage: _stepPage,
                    );
                  },

                  steps: [
                    ///name
                    Step(
                      title: Text("Enter your name"),
                      state: _stepPage == 0
                          ? StepState.editing
                          : StepState.indexed,
                      content: NameField(),
                    ),

                    ///dob
                    Step(
                      title: Text("Enter your date of birth"),
                      content: DOBField(),
                    ),

                    ///gender
                    Step(
                      title: Text("Select your gender"),
                      content: GenderRadio(),
                    ),

                    ///height
                    Step(
                      title: Text("Select your height"),
                      content: HeightSlider(),
                    ),

                    ///hobbies
                    Step(
                      title: Text("Select your hobbies"),
                      content: HobbiesChips(),
                    ),

                    ///country
                    Step(
                      title: Text("Select your country"),
                      content: CountryAutocomplete(),
                    ),
                  ],
                ),
              ),
            ),

            ElevatedButton(
              onPressed: () {
                context.read<UserFormVm>().setUserData();
                _formKey.currentState?.validate();
                _formKey.currentState?.reset();

                context.read<UserFormVm>().clearData();
              },
              child: Text("hey"),
            ),
          ],
        ),
      ),
    );
  }
}
