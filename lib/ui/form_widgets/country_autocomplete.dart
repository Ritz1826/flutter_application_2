import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_2/ui/view_model/user_form_vm.dart';
import 'package:provider/provider.dart';

class CountryAutocomplete extends StatefulWidget {
  const CountryAutocomplete({super.key});

  static const List<String> _countries = [
    "India",
    "US",
    "Canada",
    "Australia",
    "Pakistan",
    "Iran",
    "Iraq",
    "Afghanistan",
  ];

  @override
  State<CountryAutocomplete> createState() => _CountryAutocompleteState();
}

class _CountryAutocompleteState extends State<CountryAutocomplete> {
  final FocusNode focusNode = FocusNode();

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.read<UserFormVm>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 50),

        Autocomplete(
          textEditingController: vm.countryController,
          focusNode: focusNode,

          onSelected: (option) {
            vm.userCountry = option;
          },

          optionsBuilder: (textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return Iterable<String>.empty();
            }
            return CountryAutocomplete._countries.where(
              (element) => element.toLowerCase().contains(
                textEditingValue.text.toLowerCase(),
              ),
            );
          },

          fieldViewBuilder:
              (context, textEditingController, focusNode, onFieldSubmitted) {
                return TextFormField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  onChanged: (value) {
                    // focusNode.requestFocus();
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'[0-9]')),
                  ],

                  // controller: nameController,
                  decoration: InputDecoration(
                    hintText: "Enter here",
                    hintStyle: TextStyle(color: Colors.grey),
                    contentPadding: EdgeInsets.all(10),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(style: BorderStyle.solid),
                    ),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 238, 231, 251),
                    prefixIcon: Icon(Icons.map),
                    prefixIconColor: Colors.deepPurple,
                  ),
                );
              },
        ),

        SizedBox(height: 150),
      ],
    );
  }
}
