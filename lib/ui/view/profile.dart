import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_application_2/ui/data_model/sqldb_helper.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

enum ViewType { apple, banana, grapes }

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  double _sliderValue = 10;
  RangeValues _rangeValues = RangeValues(0, 10);

  int _stepperIndex = 0;

  List<bool> _isToggled = [false, false, false];

  Set<ViewType> _isSegmented = {ViewType.apple};

  bool _isFilterSelected = true;

  List<String> chips = ["hi1", "hi2", "hi3", "hi4", "hi5"];
  String selectedChip = "hi1";

  Set<String> selectedChips = {};

  List<String> options = ["apple", "mango", "grapes", "grapesss", "grapu"];

  // Set<bool> _isSegmented = {false, false, false};

  StreamController<int> myStreamController = StreamController<int>();
  late Stream<int> myStream;
  int y = 0;
  late StreamSubscription z;

  @override
  void initState() {
    myStream = myStreamController.stream.asBroadcastStream();

    //  z = myStream.listen((onData) => print(onData.toString()));

    // StreamSubscription x = myStream.listen(
    //   (data) {
    //     print(data);
    //   },
    //   onDone: () => print("done"),
    //   onError: (x) => print("error $x"),
    // );

    Timer.periodic(Duration(seconds: 1), (x) {
      if (!myStreamController.isClosed) {
        myStreamController.add(y);
      }
      if (y > 20 && y < 22) {
        myStreamController.addError("errorrr");
      }

      if (y > 30) {
        myStreamController.close();
      }
      y++;
    });

    super.initState();
  }

  @override
  void dispose() {
    myStreamController.close();
    super.dispose();
  }

  File? imgFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  Database db = await SqldbHelper().initDB();

                  // await db.insert('test', {
                  //   "id": 1,
                  //   "name": "ritika",
                  //   "value": 18,
                  //   "num": 28,
                  // });

                  await db.update(
                    "test",
                    {"id": 2, "name": "ritika", "value": 18, "num": 28},
                    where: 'id = ?',
                    whereArgs: [1],
                  );

                  var x = await db.query("test");

                  print(x);
                },
                child: Text("Create sqlDB"),
              ),

              ElevatedButton(
                onPressed: () async {
                  final ss = FlutterSecureStorage();

                  ss.write(key: "a", value: "aaa");
                  ss.write(key: "b", value: "bbb");
                  ss.write(key: "c", value: "ccc");
                  var x = await ss.read(key: "a");
                  print(x);
                },
                child: Text("Create file"),
              ),

              ElevatedButton(
                onPressed: () async {
                  final pref = await SharedPreferences.getInstance();

                  pref.setString("token_a", "value1");
                  pref.setString("token_b", "value1");
                  pref.setString("token_c", "value1");

                  var a = pref.getString("token_a");

                  print(a);

                  var b = pref.getKeys();

                  print(b);
                },
                child: Text("Create file"),
              ),

              ElevatedButton(
                onPressed: () async {
                  Directory dir = await getTemporaryDirectory();

                  File myFile = File("${dir.path}/abc.txt");

                  await myFile.writeAsString("hello motto");

                  await myFile.writeAsString(
                    " againn",
                    mode: FileMode.writeOnlyAppend,
                  );

                  var content = await myFile
                      .openRead()
                      .transform(utf8.decoder)
                      .transform(LineSplitter());

                  content.listen((a) {
                    print(a);
                  });

                  FileSystemEntityType typee = await FileSystemEntity.type(
                    "https://myFile.path.com",
                  );
                  print(typee);
                },
                child: Text("Create file"),
              ),

              ElevatedButton(
                onPressed: () async {
                  ImagePicker imgPicker = ImagePicker();

                  List<XFile>? myImage = await imgPicker.pickMultiImage();

                  if (myImage.isEmpty) return;

                  setState(() {
                    imgFile = File(myImage.first.path);
                  });
                },
                child: Text("image"),
              ),

              Image.file(imgFile ?? File("")),
              ElevatedButton(
                onPressed: () async {
                  FilePickerResult? pickedFile = await FilePicker.platform
                      .pickFiles();
                  setState(() {
                    imgFile = File(pickedFile?.files.single.path ?? "");
                  });
                },
                child: Text("file"),
              ),

              Container(
                height: 300,
                color: Colors.grey,
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 50,
                        width: 50,
                        color: Colors.blue,
                      ),
                    ),
                    Container(height: 150, width: 150, color: Colors.red),
                  ],
                ),
              ),

              Text("Profile", style: TextStyle(fontSize: 20.sp)),

              20.verticalSpacingDiameter,

              Container(height: 100.w, width: 100.w, color: Colors.purple),

              ElevatedButton(
                onPressed: () => context.push("/settings"),
                child: Text("go to home"),
              ),

              Container(
                height: 200,
                child: PageView(
                  allowImplicitScrolling: false,
                  reverse: false,
                  children: [
                    Container(color: Colors.red),
                    Container(color: Colors.green),
                    Container(color: Colors.blue),
                  ],
                ),
              ),

              Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    return const Iterable<String>.empty();
                  }

                  return options.where(
                    (option) => option.toLowerCase().contains(
                      textEditingValue.text.toLowerCase(),
                    ),
                  );
                },
              ),

              CheckboxListTile.adaptive(
                value: _isFilterSelected,
                onChanged: (value) {
                  setState(() {
                    _isFilterSelected = !_isFilterSelected;
                  });
                },
                tristate: false,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(),
                title: Text("hey"),
                controlAffinity: ListTileControlAffinity.leading,
                checkboxScaleFactor: 2,
                isThreeLine: false,
                secondary: Text("data"),
                selectedTileColor: Colors.blue,
                selected: _isFilterSelected,
                subtitle: Text(
                  "sdjh h djhsf jhsd fjhsdj fhjsdh fkjhsd kfjhks jdhfksdjhfkj hsdf  hwei fuwi uefhiwh fuwhf e",
                ),
              ),

              SwitchListTile(
                value: _isFilterSelected,
                title: Text("switch"),
                onChanged: (value) {
                  setState(() {
                    _isFilterSelected = !_isFilterSelected;
                  });
                },
              ),

              CupertinoSwitch(
                value: _isFilterSelected,

                onChanged: (value) {
                  setState(() {
                    _isFilterSelected = !_isFilterSelected;
                  });
                },
              ),

              DropdownButtonHideUnderline(
                child: DropdownButton(
                  menuWidth: 200,
                  items: chips.map((x) {
                    return DropdownMenuItem(child: Text(x), value: x);
                  }).toList(),
                  value: selectedChip,
                  onChanged: (value) {
                    setState(() {
                      selectedChip = value ?? "";
                    });
                  },
                ),
              ),

              DropdownMenu(
                dropdownMenuEntries: chips.map((x) {
                  return DropdownMenuEntry(label: x, value: x);
                }).toList(),
                closeBehavior: DropdownMenuCloseBehavior.self,
                enableSearch: true,
                initialSelection: selectedChip,
                menuStyle: MenuStyle(),
              ),

              PopupMenuButton(
                child: Icon(Icons.abc),

                itemBuilder: (context) => [
                  PopupMenuItem(value: "edit", child: Text("Edit")),
                  PopupMenuItem(value: "delete", child: Text("Delete")),
                  PopupMenuItem(value: "share", child: Text("Share")),
                ],
              ),

              ReorderableListView(
                padding: EdgeInsets.all(20),
                itemExtent: 40,
                buildDefaultDragHandles: true,

                shrinkWrap: true,
                children: chips.map((e) {
                  return Text(e, key: ValueKey(e));
                }).toList(),
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) newIndex -= 1;
                    var x = chips.removeAt(oldIndex);
                    chips.insert(newIndex, x);
                  });
                },
              ),

              ToggleButtons(
                isSelected: _isToggled,
                selectedColor: Colors.white,
                fillColor: Colors.amberAccent,
                onPressed: (index) {
                  setState(() {
                    _isToggled[index] = !_isToggled[index];
                  });
                },
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text("1"),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text("2"),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text("3"),
                  ),
                ],
              ),

              Wrap(
                children: chips.map((x) {
                  return RawChip(
                    label: Text(x),

                    selected: selectedChips.contains(x),
                    onSelected: (value) {
                      setState(() {
                        if (value) {
                          selectedChips.add(x);
                        } else {
                          selectedChips.remove(x);
                        }
                      });
                    },
                    avatar: Icon(Icons.abc),
                    // onDeleted: () {},
                  );
                }).toList(),
              ),

              ActionChip(
                label: Text("text"),
                onPressed: () async {
                  // DateTime? x = await showDatePicker(
                  //   context: context,
                  //   firstDate: DateTime(2020),
                  //   lastDate: DateTime(2027),
                  // );

                  DateTime? y = await showDialog(
                    context: context,
                    builder: (context) {
                      return DatePickerDialog(
                        initialEntryMode: DatePickerEntryMode.input,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2027),
                      );
                    },
                  );
                },
              ),

              ActionChip(
                label: Text("time"),
                onPressed: () async {
                  // DateTime? x = await showDatePicker(
                  //   context: context,
                  //   firstDate: DateTime(2020),
                  //   lastDate: DateTime(2027),
                  // );

                  TimeOfDay? y = await showDialog(
                    context: context,
                    builder: (context) {
                      return TimePickerDialog(
                        initialEntryMode: TimePickerEntryMode.input,
                        initialTime: TimeOfDay.now(),
                      );
                    },
                  );
                },
              ),

              SegmentedButton(
                segments: [
                  ButtonSegment(
                    value: ViewType.apple,
                    icon: Icon(Icons.apple),
                    label: Text("1"),
                  ),
                  ButtonSegment(
                    value: ViewType.banana,
                    icon: Icon(Icons.baby_changing_station),
                    label: Text("2"),
                  ),
                  ButtonSegment(
                    value: ViewType.grapes,
                    icon: Icon(Icons.airplanemode_active_outlined),
                    label: Text("3"),
                  ),
                ],
                selected: _isSegmented,
                multiSelectionEnabled: true,
                emptySelectionAllowed: true,
                onSelectionChanged: (Set<ViewType> x) {
                  setState(() {
                    _isSegmented = x;
                  });
                  print(_isSegmented.toString());
                },
              ),

              Container(
                // width: double.infinity,
                // height: 440,
                child: Stepper(
                  connectorColor: WidgetStatePropertyAll(Colors.amber),
                  connectorThickness: 2,
                  elevation: 200,
                  type: StepperType.vertical,
                  margin: EdgeInsets.all(50),
                  stepIconHeight: 60,
                  stepIconWidth: 60,
                  stepIconMargin: EdgeInsets.all(10),
                  controlsBuilder: (context, details) {
                    return Row(
                      children: [
                        ElevatedButton(
                          onPressed: details.onStepContinue,
                          child: Text("Next"),
                        ),
                        TextButton(
                          onPressed: details.onStepCancel,
                          child: Text("Back"),
                        ),
                      ],
                    );
                  },
                  stepIconBuilder: (stepIndex, stepState) {
                    if (stepIndex == 0) {
                      return Icon(Icons.abc);
                    } else if (stepIndex == 1) {
                      return Icon(Icons.access_alarm);
                    } else {
                      return Icon(Icons.airline_seat_individual_suite_rounded);
                    }
                  },
                  currentStep: _stepperIndex,
                  onStepContinue: () {
                    setState(() {
                      if (_stepperIndex < 2) {
                        _stepperIndex++;
                      }
                    });
                  },
                  onStepCancel: () {
                    setState(() {
                      if (_stepperIndex > 0) {
                        _stepperIndex--;
                      }
                    });
                  },
                  onStepTapped: (value) {
                    setState(() {
                      _stepperIndex = value;
                    });
                  },
                  steps: [
                    Step(
                      label: Text("label"),
                      title: Text("this 1"),
                      content: Column(children: [Text("1")]),
                      subtitle: Text("data"),
                    ),

                    Step(
                      title: Text("this 2"),
                      content: Column(children: [Text("2")]),
                    ),

                    Step(
                      title: Text("this 3"),
                      content: Column(children: [Text("3")]),
                    ),
                  ],
                ),
              ),

              ElevatedButton(
                onPressed: () => z.resume(),
                child: Text("resume"),
              ),
              ElevatedButton(
                onPressed: () => z.cancel(),
                child: Text("cancel"),
              ),
              ElevatedButton(onPressed: () => z.pause(), child: Text("pause")),

              SelectableText(
                "heyyy",
                onSelectionChanged: (selection, cause) =>
                    print(selection.start),
                selectionColor: Colors.amber,
                selectionHeightStyle: BoxHeightStyle.includeLineSpacingBottom,
              ),

              SelectionArea(
                child: Column(
                  children: [
                    Text("data"),
                    Text("data"),
                    Text("data"),
                    Text("data"),
                    Text("data"),
                  ],
                ),
              ),

              Form(
                autovalidateMode: AutovalidateMode.always,
                child: InputDatePickerFormField(
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2027),
                  errorFormatText: "invalid",
                  errorInvalidText: "wrong",
                  fieldLabelText: "",
                  initialDate: DateTime.now(),
                  onDateSubmitted: (value) {
                    print(value);
                  },
                ),
              ),

              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  showValueIndicator: ShowValueIndicator.alwaysVisible,
                ),
                child: Slider(
                  value: _sliderValue,
                  label: _sliderValue.toString(),
                  divisions: 10,
                  secondaryActiveColor: Colors.green,
                  min: 0,
                  max: 100,
                  onChanged: (value) {
                    print("slider value $value");
                    setState(() {
                      _sliderValue = value;
                    });
                  },
                  allowedInteraction: SliderInteraction.slideThumb,
                ),
              ),

              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  showValueIndicator: ShowValueIndicator.alwaysVisible,
                  valueIndicatorShape: SliderComponentShape.noOverlay,
                  rangeValueIndicatorShape:
                      DropRangeSliderValueIndicatorShape(),
                ),
                child: RangeSlider(
                  divisions: 10,
                  values: _rangeValues,
                  min: 0,
                  labels: RangeLabels(
                    _rangeValues.start.toString(),
                    _rangeValues.end.toString(),
                  ),
                  max: 100,
                  onChanged: (x) {
                    setState(() {
                      _rangeValues = x;
                    });
                  },
                ),
              ),

              CupertinoSlider(
                value: _sliderValue,
                min: 0,
                max: 100,

                onChanged: (value) {
                  setState(() {
                    _sliderValue = value;
                  });
                },
              ),

              StreamBuilder<int>(
                stream: myStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data.toString());
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } else {
                    return Text("no data");
                  }
                },
              ),
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  color: Colors.yellowAccent,
                  child: Text(MediaQuery.of(context).viewPadding.toString()),
                ),
              ),

              Container(
                height: 300,
                width: 300,
                color: Colors.grey,
                child: FractionallySizedBox(
                  heightFactor: 0.5,
                  widthFactor: 0.5,
                  child: Container(color: Colors.blueAccent),
                ),
              ),

              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                width: double.infinity,
                color: Colors.greenAccent,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Column(
                      children: [
                        Text(constraints.maxHeight.toString()),
                        Container(
                          color: Colors.deepOrange,
                          height: constraints.maxHeight * 0.1,
                          width: constraints.maxWidth * 0.1,
                        ),

                        Container(
                          color: const Color.fromARGB(255, 244, 133, 99),
                          height: constraints.maxHeight * 0.3,
                          width: constraints.maxWidth * 0.3,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
