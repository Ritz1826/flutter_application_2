import 'package:flutter/material.dart';
import 'package:flutter_application_2/ui/view_model/user_form_vm.dart';
import 'package:provider/provider.dart';

class HeightSlider extends StatefulWidget {
  final int stepPage;
  const HeightSlider({super.key, required this.stepPage});

  @override
  State<HeightSlider> createState() => _HeightSliderState();
}

class _HeightSliderState extends State<HeightSlider> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<UserFormVm>().getHeightState(widget.stepPage);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 50),

        Theme(
          data: Theme.of(context).copyWith(
            sliderTheme: SliderThemeData(
              showValueIndicator: ShowValueIndicator.onDrag,
            ),
          ),
          child: Selector<UserFormVm, double?>(
            selector: (contetx, x) => x.userHeight,
            builder: (context, data, child) {
              return Slider(
                value: data ?? 0,
                min: 0,
                label: "$data'ft ",
                max: 10,
                onChanged: (value) {
                  context.read<UserFormVm>().userHeight = double.parse(
                    value.toStringAsFixed(1),
                  );
                  context.read<UserFormVm>().getHeightState(widget.stepPage);
                },
              );
            },
          ),
        ),

        SizedBox(height: 50),
      ],
    );
  }
}
