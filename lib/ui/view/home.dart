import 'package:flutter/material.dart';
import 'package:flutter_application_2/ui/view/form_widgets/country_autocomplete.dart';
import 'package:flutter_application_2/ui/view/form_widgets/dob_field.dart';
import 'package:flutter_application_2/ui/view/form_widgets/gender_radio.dart';
import 'package:flutter_application_2/ui/view/form_widgets/height_slider.dart';
import 'package:flutter_application_2/ui/view/form_widgets/hobbies_chips.dart';
import 'package:flutter_application_2/ui/view/form_widgets/main_controls_button.dart';
import 'package:flutter_application_2/ui/view/form_widgets/name_field.dart';
import 'package:flutter_application_2/ui/view/form_widgets/widget_helpers/home_helper.dart';
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
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(title: Text("Home")),
            body: Column(
              children: [
                Container(
                  height: 200,
                  width: 200,
                  color: Colors.yellow,
                  child: CustomPaint(
                    size: Size(200, 200),
                    painter: MyPainter(),
                  ),
                ),

                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "doneeee jdsh kfjhsk hfkjshd kfjhs kdfhkdshjf kjhd fkjsh ",
                        ),
                        dismissDirection: DismissDirection.horizontal,
                        showCloseIcon: true,
                        behavior: SnackBarBehavior.floating,
                        actionOverflowThreshold: 0.9,
                        action: SnackBarAction(
                          label: "check",
                          onPressed: () {},
                        ),
                      ),
                    );
                  },
                  child: Text("show"),
                ),

                Expanded(
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Stepper(
                      currentStep: _stepPage,
                      onStepContinue: () {
                        if (_stepPage < 5) {
                          /// avoid setstate in long widget tree
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
                        if (context.read<UserFormVm>().tapAndValidate(
                          _stepPage,
                        )) {
                          setState(() {
                            _stepPage = value;
                            context.read<UserFormVm>().validateAndContinue(
                              value - 1,
                              _formKey,
                            );
                          });
                        }
                      },
                      connectorColor: WidgetStateProperty.all(
                        Colors.deepPurple,
                      ),
                      controlsBuilder: (context, details) {
                        return MainControlsButton(
                          details: details,
                          stepPage: _stepPage,
                          formKey: _formKey,
                        );
                      },

                      steps: [
                        ///name
                        Step(
                          title: Text("Enter your name"),
                          state: context.select<UserFormVm, StepState>(
                            (value) => value.nameState,
                          ),

                          content: NameField(stepPage: _stepPage),
                        ),

                        ///dob
                        Step(
                          title: Text("Enter your date of birth"),
                          content: DOBField(stepPage: _stepPage),
                          state: context.select<UserFormVm, StepState>(
                            (value) => value.dobState,
                          ),
                        ),

                        ///gender
                        Step(
                          title: Text("Select your gender"),
                          content: GenderRadio(stepPage: _stepPage),
                          state: context.select<UserFormVm, StepState>(
                            (value) => value.genderState,
                          ),
                        ),

                        ///height
                        Step(
                          title: Text("Select your height"),
                          content: HeightSlider(stepPage: _stepPage),
                          state: context.select<UserFormVm, StepState>(
                            (value) => value.heightState,
                          ),
                        ),

                        ///hobbies
                        Step(
                          title: Text("Select your hobbies"),
                          content: HobbiesChips(stepPage: _stepPage),
                          state: context.select<UserFormVm, StepState>(
                            (value) => value.hobbiesState,
                          ),
                        ),

                        ///country
                        Step(
                          title: Text("Select your country"),
                          content: CountryAutocomplete(stepPage: _stepPage),
                          state: context.select<UserFormVm, StepState>(
                            (value) => value.countryState,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Selector<UserFormVm, bool>(
            selector: (context, x) => x.isLoading,
            builder: (context, isLoading, child) {
              print("loader called $isLoading");
              return Visibility(
                visible: isLoading,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black.withAlpha(190),
                  child: Center(
                    child: SizedBox(
                      height: 60,
                      width: 60,
                      child: CircularProgressIndicator(strokeWidth: 10),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
