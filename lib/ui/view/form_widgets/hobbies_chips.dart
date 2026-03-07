import 'package:flutter/material.dart';
import 'package:flutter_application_2/ui/view_model/user_form_vm.dart';
import 'package:provider/provider.dart';

class HobbiesChips extends StatefulWidget {
  final int stepPage;
  const HobbiesChips({super.key, required this.stepPage});

  static const List<String> _hobbies = [
    "painting",
    "singing",
    "dancing",
    "cooking",
    "hunting",
    "sketching",
    "coding",
    "travelling",
    "driving",
    "writing",
  ];

  @override
  State<HobbiesChips> createState() => _HobbiesChipsState();
}

class _HobbiesChipsState extends State<HobbiesChips> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<UserFormVm>().getHobbiesState(widget.stepPage);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 50),

        Wrap(
          runSpacing: 10,
          spacing: 10,

          children: HobbiesChips._hobbies.map((x) {
            return Selector<UserFormVm, List<String>?>(
              selector: (context, x) => x.userHobbies,
              builder: (context, data, child) {
                return InputChip(
                  avatar: SizedBox(width: 25),
                  checkmarkColor: Colors.deepPurple,
                  labelPadding: EdgeInsets.only(right: 25, left: 5),
                  selectedColor: Color.fromARGB(255, 193, 165, 244),
                  label: Text(x),
                  pressElevation: 20,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.deepPurple),
                    borderRadius: BorderRadiusGeometry.all(Radius.circular(20)),
                  ),
                  backgroundColor: Color.fromARGB(255, 238, 231, 251),
                  selected: data?.contains(x) ?? false,
                  labelStyle: TextStyle(
                    color: data?.contains(x) ?? false
                        ? Colors.deepPurple
                        : Colors.black,
                  ),
                  onSelected: (value) {
                    if (value) {
                      context.read<UserFormVm>().addUserHobbies = x;
                    } else {
                      context.read<UserFormVm>().removeUserHobbies = x;
                    }
                    context.read<UserFormVm>().getHobbiesState(widget.stepPage);
                  },
                );
              },
            );
          }).toList(),
        ),

        SizedBox(height: 50),
      ],
    );
  }
}
