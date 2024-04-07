import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mailer/mailer.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

/*
git add <files>
git commit -m "<comment>"
git push origin main
*/

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'wearevolunteenz',
        theme: ThemeData(
          sliderTheme: const SliderThemeData(
            showValueIndicator: ShowValueIndicator.never,
          ),
          useMaterial3: true,
          colorScheme: const ColorScheme.light().copyWith(
            primary: const Color.fromARGB(255, 0, 206, 203),
            secondary: const Color.fromARGB(255, 168, 248, 168),
            tertiary: const Color.fromARGB(255, 255, 237, 102),
            error: const Color.fromARGB(255, 255, 94, 91),
            background: const Color.fromARGB(255, 255, 255, 234),
            surface: const Color.fromARGB(255, 168, 248, 168),
          ),

          //primaryColor: Color.fromARGB(255, 0, 206, 203),
          //primarySwatch:  Color.fromARGB(255, 0, 206, 203)
        ),
        home: const Home(),
      ),
    );
  }
}

Future<String?> getDeviceIdentifier() async {
  String? deviceIdentifier = "unknown";
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    deviceIdentifier = androidInfo.serialNumber;
  } else if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    deviceIdentifier = iosInfo.identifierForVendor;
  } else if (kIsWeb) {
    // The web doesnt have a device UID, so use a combination fingerprint as an example
    WebBrowserInfo webInfo = await deviceInfo.webBrowserInfo;
    deviceIdentifier = webInfo.vendor! +
        webInfo.userAgent! +
        webInfo.hardwareConcurrency.toString();
  } else if (Platform.isLinux) {
    LinuxDeviceInfo linuxInfo = await deviceInfo.linuxInfo;
    deviceIdentifier = linuxInfo.machineId;
  } else if (Platform.isWindows) {
    WindowsDeviceInfo winInfo = await deviceInfo.windowsInfo;
    deviceIdentifier = winInfo.deviceId;
  }
  return deviceIdentifier;
}

class Home extends StatefulWidget {
  @override
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  _HomeState();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int currentIndex = 0;
  List<Widget> _screens() => [const Opp(), const Org()];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final List<Widget> screens = _screens();

    return Scaffold(
      key: _scaffoldKey,
      body: IndexedStack(index: currentIndex, children: screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        backgroundColor: theme.colorScheme.secondary,
        onTap: (index) => setState(() => currentIndex = index),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.work_history), label: "Opportunities"),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_balance), label: "Organizations")
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class FilterPage extends StatefulWidget {
  @override
  FilterPage({super.key, required this.permFilter});

  Map<String, dynamic> permFilter;

  @override
  // ignore: no_logic_in_create_state
  State<FilterPage> createState() => _FilterPageState(permFilter: permFilter);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class _FilterPageState extends State<FilterPage> {
  @override
  _FilterPageState({
    required this.permFilter,
  });

  Position? uposition;

  Map<String, dynamic> permFilter;
  List<int> sliderValues = [
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    12,
    14,
    16,
    18,
    20,
    22,
    24,
    26,
    28,
    30,
    35,
    40,
    45,
    50,
    55,
    60,
    65,
    70,
    80,
    90,
    100,
    110,
    120,
    130,
    140,
    150
  ];

    final locText = TextEditingController();
    TextEditingController searchText = TextEditingController();

  void _getCurrentLocation() async {
    Position? position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    position = await Geolocator.getLastKnownPosition();

    setState(() {
      uposition = position;
    });
  }

  Future pickDateRange() async {
    DateTimeRange? newDateRange = await showDateRangePicker(
        context: context,
        initialDateRange: tempFilter["dateRange"],
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
        builder: (context, Widget? child) => Theme(
              data: ThemeData.light().copyWith(
                dialogTheme: const DialogTheme(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0.0)),
                  ),
                ),
                textTheme: const TextTheme(
                  titleSmall: TextStyle(fontSize: 20.0), // calendar "Select"
                  titleLarge: TextStyle(fontSize: 16.0), // calendar "dates"
                  labelLarge: TextStyle(fontSize: 20.0), // text field "Select"
                  headlineLarge: TextStyle(fontSize: 16.0), // textfield "dates"
                  bodyMedium:
                      TextStyle(color: Colors.black), // calendar actual dates
                  bodyLarge: TextStyle(color: Colors.black),
                ),
                useMaterial3: true,
                colorScheme: const ColorScheme.light(
                  background: Color.fromARGB(255, 255, 0, 0),
                  secondaryContainer: Color.fromARGB(255, 255, 237, 102),
                  surface: Color.fromARGB(255, 253, 253, 188),
                  primary: Color.fromARGB(255, 0, 206, 203),
                ),
              ),
              child: child!,
            ));

    if (newDateRange == null) {
      return;
    }

    setState(() {
      tempFilter["dateRange"] = newDateRange;
      tempFilter["dateRangeChanged"] = true;
    });
  }

  Map<String, dynamic> tempFilter = {};

  @override
  void initState() {
    super.initState();
    tempFilter = Map.from(permFilter);
    searchText.text = tempFilter["searchText"];
    locText.text = tempFilter["location"];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final start = tempFilter["dateRange"].start;
    final end = tempFilter["dateRange"]!.end;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        title: const Text('Filter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            TextFormField(
              controller: searchText,
              //initialValue: tempFilter["searchText"],
              onChanged: (newText) {
                tempFilter["searchText"] = newText;
              },
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.only(left: 0),
                prefixIcon: Icon(Icons.search),
                filled: true,
                border: OutlineInputBorder(),
                hintText: 'Search',
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: locText,
              //initialValue: tempFilter["location"],
              onChanged: (newText) {
                setState(() {
                  tempFilter["location"] = newText;
                });
              },
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.only(left: 0),
                prefixIcon: Icon(Icons.room),
                filled: true,
                border: OutlineInputBorder(),
                hintText: 'Location',
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Icon(Icons.my_location),
                SizedBox(
                  width: 125,
                  child: Text(
                      "  Within ${tempFilter["radius"].round().toString()} miles"),
                ),
                Expanded(
                  child: Slider(
                    min: 0,
                    max: (sliderValues.length).toDouble() - 1,
                    divisions: sliderValues.length,
                    activeColor: theme.colorScheme.primary,
                    inactiveColor: HSLColor.fromColor(theme.colorScheme.primary)
                        .withLightness(0.9)
                        .toColor(),
                    value: sliderValues.indexOf(tempFilter["radius"]).toDouble(),
                    onChanged: (value) {
                      setState(() {
                        tempFilter["radius"] = sliderValues[value.toInt()];
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            SizedBox(
                //padding: const EdgeInsets.only(right: 8),
                width: double.infinity,
                height: 38,
                child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.all(10.0),
                        shape: const RoundedRectangleBorder(
                            side: BorderSide(color: Colors.black, width: 1),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                topRight: Radius.circular(5),
                                bottomRight: Radius.circular(5),
                                bottomLeft: Radius.circular(5)))),
                    onPressed: pickDateRange,
                    icon: const Icon(Icons.date_range, color: Colors.black),
                    label: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        " ${DateFormat('MMM d, yyyy').format(start)} 12AM to ${DateFormat('MMM d, yyyy').format(end)} 12AM",
                        //'${start.year}/${start.month}/${start.day} to ${end.year}/${end.month}/${end.day}',
                        style: const TextStyle(color: Colors.black),
                        textAlign: TextAlign.left,
                      ),
                    ))),
            const SizedBox(height: 35),
            Row(
              children: [
                Checkbox(
                  onChanged: (state) {
                    setState(() {
                      tempFilter["signUp"] = state;
                    });
                  },
                  value: tempFilter["signUp"],
                  checkColor: Colors.white,
                  fillColor: (tempFilter["signUp"])
                      ? MaterialStateProperty.all(Colors.black)
                      : MaterialStateProperty.all(theme.colorScheme.background),
                ),
                const Text("Instant Sign-up Oppurtunities"),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  onChanged: (state) {
                    setState(() {
                      tempFilter["virtual"] = state;
                    });
                  },
                  value: tempFilter["virtual"],
                  checkColor: Colors.white,
                  fillColor: (tempFilter["virtual"])
                      ? MaterialStateProperty.all(Colors.black)
                      : MaterialStateProperty.all(theme.colorScheme.background),
                ),
                const Text("Virtual"),
              ],
            ),
            TextButton(
                onPressed: () {
                  setState(() {
                    tempFilter = Map.from(permFilter);
                    searchText.text = tempFilter["searchText"];
                    locText.text = tempFilter["location"];
                  });
                },
                child: const Text("Reset values")),
            const Expanded(
                child: SizedBox(
              width: 5,
            )),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.secondary,
                ),
                onPressed: () async {
                  //Convert location into lat and lon
                  if (tempFilter["location"] != permFilter["location"]) {
                    if (tempFilter["location"] != "Current position" &&
                        tempFilter["location"] != '') {
                      try {
                        final response = await http
                            .get(Uri.parse(
                                "https://nominatim.openstreetmap.org/search?format=json&addressdetails=1&q=${tempFilter["location"]}, California"))
                            .timeout(const Duration(seconds: 30));

                        if (response.statusCode == 200) {
                          final List<dynamic> respJson =
                              json.decode(response.body);
                          setState(() {
                            if (respJson.isNotEmpty) {
                              tempFilter["lat"] =
                                  double.parse(respJson[0]["lat"]);
                              tempFilter["lon"] =
                                  double.parse(respJson[0]["lon"]);
                            }
                          });
                        } else {
                          // ignore: use_build_context_synchronously
                          showSnackBar(
                            "Failed to geocode. Try again later.",
                            context,
                            const Color.fromARGB(255, 255, 94, 91),
                          );
                          // Add screen message
                        }
                      } on SocketException {
                        showSnackBar(
                          "Failed to geocode. Try again later.",
                          context,
                          const Color.fromARGB(255, 255, 94, 91),
                        );
                      }
                    } else if (tempFilter["location"] != '') {
                      _getCurrentLocation();
                      setState(() {
                        if (uposition != null) {
                          tempFilter["lat"] = uposition!.latitude;
                          tempFilter["lon"] = uposition!.longitude;
                        }
                      });
                    }
                  }

                  //Make user input permanant
                  permFilter = Map.from(tempFilter);
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context, permFilter);
                },
                child: Text("Save",
                    style: TextStyle(color: theme.colorScheme.primary)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Opp extends StatefulWidget {
  @override
  const Opp({super.key});

  @override
  State<Opp> createState() => _OppState();
}

class _OppState extends State<Opp> {
  @override
  _OppState();
  List _selectedItems = []; //Just applied items
  int viewMode = 0; //0 = all, 1 = applied, 2 = not applied
  List oppItems = [];
  List _results = [];
  Future<Map<String, dynamic>>? _future;

  Map<String, dynamic> permFilter = {
    "searchText": '',
    "dateRange": DateTimeRange(
        start: DateTime.now(),
        end: DateTime.now().add(const Duration(days: 365))),
    "dateRangeChanged": false,
    "location": 'Current Location',
    "radius": 1,
    "lat": 0.0,
    "lon": 0.0,
    "signUp": false,
    "virtual": false,
  };

  void _determinePosition() async {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled return an error message
      return Future.error('Location services are disabled.');
    }

    // Check location permissions
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
  }

  @override
  void initState() {
    super.initState();

    _future = fetchJsonDemoData(context);
    // return;
    getApplicationDocumentsDirectory().then((dir) {
      String appliedJsonFile = "${dir.path}/applied.json";
      final File file = File(appliedJsonFile);
      if (file.existsSync()) {
        String contents = file.readAsStringSync();
        _selectedItems = jsonDecode(contents);
      }
    });
  }

  bool updateSelected(i, [bool remove = false]) {
    String itext = i["opp"] +
        ' ' +
        i["org"] +
        ' ' +
        i["dateStart"] +
        ' ' +
        i["dateEnd"] +
        ' ' +
        i["location"];
    for (var s in _selectedItems) {
      String stext = s["opp"] +
          ' ' +
          s["org"] +
          ' ' +
          s["dateStart"] +
          ' ' +
          s["dateEnd"] +
          ' ' +
          s["location"];
      if (stext == itext) {
        if (remove) {
          _selectedItems.remove(s);
          return false;
        } else {
          return true;
        }
      }
    }
    return false;
  }

  bool isSelected(i, [bool remove = false]) {
    String itext = i["opp"] +
        ' ' +
        i["org"] +
        ' ' +
        i["dateStart"] +
        ' ' +
        i["dateEnd"] +
        ' ' +
        i["location"];
    for (var s in _selectedItems) {
      String stext = s["opp"] +
          ' ' +
          s["org"] +
          ' ' +
          s["dateStart"] +
          ' ' +
          s["dateEnd"] +
          ' ' +
          s["location"];
      if (stext == itext) {
        if (remove) {
          _selectedItems.remove(s);
          return false;
        } else {
          return true;
        }
      }
    }
    return false;
  }

  void saveAppliedFile() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String appliedJsonFile = "${directory.path}/applied.json";
    final File file = File(appliedJsonFile);
    file.writeAsStringSync(json.encode(_selectedItems));
  }

  List filterItems() {
    List tmpList = [];
    tmpList = List.from(_results);
    /*
    if (searchText.isEmpty && locTitle.isEmpty && !dateRangeChanged) {
      tmpList = List.from(oppItems);
    } else {
      tmpList = List.from(_results);
    }
    */
    if (viewMode == 0) {
      tmpList = tmpList;
    } else if (viewMode == 1) {
      tmpList = tmpList.where((i) => isSelected(i)).toList();
    } else {
      tmpList = tmpList.where((i) => !isSelected(i)).toList();
    }
    return tmpList;
  }

  IconData _filterIcon() {
    if (viewMode == 0) {
      return Icons.indeterminate_check_box;
    } else if (viewMode == 1) {
      return Icons.check_box;
    } else {
      return Icons.check_box_outline_blank;
    }
  }

  Future _refresh() async {
    setState(() => oppItems.clear());
    final Map<String, dynamic> resp = await fetchJsonDemoData(context);
    setState(() {
      if (resp.isNotEmpty) {
        oppItems = resp["opps"];
      }
    });
  }

  void _handlefilter(Map<String, dynamic> permFilter) {
    _results = List.from(oppItems);

    setState(() {
      _results.removeWhere((item) => !(item["opp"] +
              ' ' +
              item["org"] +
              ' ' +
              item["description"].join('\n').toLowerCase())
          .contains(permFilter["searchText"].toLowerCase()));

      _results.removeWhere((item) => (((item["dateStart"].length == 0)
                  ? DateTime.parse('2100-01-01')
                  : DateTime.parse(item["dateStart"]))
              .compareTo(permFilter["dateRange"].start) <
          0));

      _results.removeWhere((item) => ((((item["dateEnd"].length == 0)
                  ? DateTime.parse('1900-01-01')
                  : DateTime.parse(item["dateEnd"]))
              .compareTo(permFilter["dateRange"].end) >
          -1)));

      _results.removeWhere((item) => (item["lat"].isNotEmpty &&
          (((Geolocator.distanceBetween(permFilter['lat'], permFilter['lon'],
                      double.parse(item["lat"]), double.parse(item["lon"]))) /
                  1609.344) >
              permFilter["radius"])));

      _results.removeWhere(
          (item) => (permFilter["signUp"] && (item["type"] != 'Sign-up')));

      _results.removeWhere((item) => (permFilter["virtual"] &&
          ((item["location"] != 'Virtual') && (item["location"].isNotEmpty))));
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!
        .copyWith(color: theme.colorScheme.secondary, fontSize: 40);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: theme.colorScheme.primary,
          centerTitle: true,
          title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'weare',
                  style: style,
                  textAlign: TextAlign.center,
                ),
                Image.asset('assets/logo.png', scale: 6),
                Text(
                  'olunteenz',
                  style: style,
                  textAlign: TextAlign.center,
                ),
              ]),
        ),
        body: FutureBuilder<Map<String, dynamic>>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isNotEmpty && oppItems.isEmpty) {
                  oppItems = List.from(snapshot.data!["opps"]);
                  _results = List.from(oppItems);
                }
                return Column(children: <Widget>[
                  Container(
                    height: 40,
                    color: theme.colorScheme.secondary,
                    child: Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: ElevatedButton.icon(
                              label: Text(
                                  '${_results.length} out of ${oppItems.length}',
                                  /*
                                  ((searchText.isEmpty &&
                                          locTitle.isEmpty &&
                                          !dateRangeChanged)
                                      ? '${oppItems.length} out of ${oppItems.length} matched'
                                      : '${_results.length} out of ${oppItems.length} matched'),
                                */
                                  style: const TextStyle(fontSize: 17),
                                  textAlign: TextAlign.center),
                              onPressed: () async {
                                _determinePosition();
                                var test = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        FilterPage(permFilter: permFilter),
                                  ),
                                );

                                if (test != null) {
                                  permFilter = test as Map<String, dynamic>;
                                }

                                _handlefilter(permFilter);
                              },
                              icon: const Icon(Icons.filter_alt),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: ElevatedButton.icon(
                                label: Text(
                                  "${_selectedItems.length} applied",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: (_selectedItems.isEmpty
                                        ? FontWeight.normal
                                        : FontWeight.bold),
                                    color: (_selectedItems.isEmpty
                                        ? Colors.black
                                        : theme.colorScheme.primary),
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor:
                                        theme.colorScheme.secondary,
                                    padding: const EdgeInsets.all(2),
                                    shape: const RoundedRectangleBorder(
                                        //side: BorderSide(color: Colors.black, width: 0),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(5),
                                            topRight: Radius.circular(5),
                                            bottomRight: Radius.circular(5),
                                            bottomLeft: Radius.circular(5)))),
                                onPressed: () {
                                  setState(() {
                                    viewMode = (viewMode + 1) % 3;
                                  });
                                },
                                icon: Icon(_filterIcon(), color: Colors.black)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: oppItems.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : RefreshIndicator(
                            onRefresh: _refresh,
                            child: ListView.builder(
                              itemCount: filterItems().length,
                              itemBuilder: (BuildContext context, int index) {
                                List items = filterItems();
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 8, left: 8, right: 8),
                                  child: ListTile(
                                    shape: const RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Colors.black, width: 1),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(5),
                                            topRight: Radius.circular(5),
                                            bottomRight: Radius.circular(5),
                                            bottomLeft: Radius.circular(5))),
                                    tileColor: theme.colorScheme.background,
                                    selectedTileColor:
                                        theme.colorScheme.background,
                                    selectedColor: Colors.grey,
                                    leading: Icon(isSelected(items[index])
                                        ? Icons.check_circle
                                        : Icons.radio_button_unchecked),
                                    trailing: TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                OppInfo(oppItems: items[index]),
                                          ),
                                        );
                                      },
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                      ),
                                      child: const Text('ⓘ',
                                          style: TextStyle(fontSize: 24)),
                                    ),
                                    title: (items[index]["location"] ==
                                                "Virtual" ||
                                            items[index]["location"].isEmpty)
                                        ? Text(
                                            "${items[index]["opp"]} 🛜",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        : Text(
                                            "${items[index]["opp"]}",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                    subtitle: (items[index]["dateStart"]
                                            .isEmpty)
                                        ? Text(items[index]["org"])
                                        : Text(
                                            "${items[index]["org"]}\n${DateFormat("MMM d, h:mm a").format(DateTime.parse(items[index]["dateStart"]).toLocal())}-${DateFormat("MMM d, h:mm a").format(DateTime.parse(items[index]["dateEnd"]).toLocal())}"),
                                    contentPadding:
                                        const EdgeInsets.only(left: 10),
                                    visualDensity: const VisualDensity(
                                        horizontal: 0, vertical: -4),
                                    selected: isSelected(items[index]),
                                    onTap: () async {
                                      Uri url = Uri.parse(items[index]["link"]);
                                      if (await canLaunchUrl(url)) {
                                        await launchUrl(
                                            url); //forceWebView is true now
                                        // ignore: use_build_context_synchronously
                                        bool result = await showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5.0)),
                                            backgroundColor:
                                                theme.colorScheme.background,
                                            content:
                                                const Text("Did you apply?"),
                                            actions: [
                                              TextButton(
                                                  child: const Text("Yes",
                                                      style: TextStyle()),
                                                  onPressed: () {
                                                    Navigator.pop(
                                                        context, true);
                                                  }),
                                              TextButton(
                                                  child: const Text("No",
                                                      style: TextStyle()),
                                                  onPressed: () {
                                                    Navigator.pop(
                                                        context, false);
                                                  })
                                            ],
                                          ),
                                        );
                                        setState(() {
                                          if (result) {
                                            if (!isSelected(items[index])) {
                                              _selectedItems.add(items[index]);
                                              sendUsageData(
                                                  context,
                                                  "applied",
                                                  items[index]["org"] +
                                                      ' ' +
                                                      items[index]["opp"] +
                                                      ' ' +
                                                      items[index]
                                                          ["dateStart"] +
                                                      ' ' +
                                                      items[index]["dateEnd"] +
                                                      ' ' +
                                                      items[index]["location"]);
                                            }
                                          } else {
                                            isSelected(items[index], true);
                                          }
                                        });
                                        saveAppliedFile();
                                      } else {
                                        // ignore: use_build_context_synchronously
                                        showSnackBar('Could not open website',
                                            context, theme.colorScheme.error);
                                      }
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                  ))
                ]);
              } else if (snapshot.hasError) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('An error occured ${snapshot.error.toString()}')
                  ],
                );
              }
              return const Center(child: CircularProgressIndicator());
            }));
  }
}

class MyAppState extends ChangeNotifier {}

class Org extends StatefulWidget {
  @override
  const Org({super.key});

  @override
  State<Org> createState() => _OrgState();
}

Future<Map<String, dynamic>> fetchJsonDemoData(context) async {
  try {
    final response = await http
        .get(Uri.parse(
            'https://script.google.com/macros/s/AKfycbzvl-CBWxpM0gvSUbnWH_ixrdA2LHmLXKLB0NsYRoaPD7T0q1Ex2ZgMMndZ3wKfz5HEmg/exec'))
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      showSnackBar(
        "Failed to load. Try again later.",
        context,
        const Color.fromARGB(255, 255, 94, 91),
      );
      return {};
      // Add screen message
    }
  } on SocketException {
    showSnackBar(
      "Failed to load. Try again later.",
      context,
      const Color.fromARGB(255, 255, 94, 91),
    );
    return {};
    // Add screen message
  }
}

void sendUsageData(context, action, target) async {
  String? userId = await getDeviceIdentifier();
  try {
    final response = await http
        .get(Uri.parse(
            'https://script.google.com/macros/s/AKfycbzvl-CBWxpM0gvSUbnWH_ixrdA2LHmLXKLB0NsYRoaPD7T0q1Ex2ZgMMndZ3wKfz5HEmg/exec?userId=$userId&action=$action&target=$target'))
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      return;
    } else {
      return;
      // Add screen message
    }
  } on SocketException {
    return;
    // Add screen message
  }
}

class _OrgState extends State<Org> {
  @override
  _OrgState();
  final List _selectedItems = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List orgItems = [];
  final List _results = [];
  String searchText = '';
  String locText = '';
  Future<Map<String, dynamic>>? _future;

  @override
  void initState() {
    super.initState();
    _future = fetchJsonDemoData(context);
  }

  void _handletext(String input) {
    _results.clear();
    searchText = input;
    for (var item in orgItems) {
      if (item["name"]!.toLowerCase().contains(searchText.toLowerCase()) ||
          item["info"]!
              .join(',')
              .toLowerCase()
              .contains(searchText.toLowerCase())) {
        if (item["address"]!.toLowerCase().contains(locText.toLowerCase())) {
          setState(() {
            _results.add(item);
          });
        }
      }
    }
  }

  void _handleloc(String input) {
    _results.clear();
    locText = input;
    for (var item in orgItems) {
      if (item["address"]!.toLowerCase().contains(input.toLowerCase())) {
        if (item["name"]!.toLowerCase().contains(searchText.toLowerCase()) ||
            item["info"]!
                .join(',')
                .toLowerCase()
                .contains(searchText.toLowerCase())) {
          setState(() {
            _results.add(item);
          });
        }
      }
    }
  }

  Future _refresh() async {
    setState(() => orgItems.clear());
    final Map<String, dynamic> resp = await fetchJsonDemoData(context);
    setState(() {
      if (resp.isNotEmpty) {
        orgItems = resp["orgs"];
      }
    });
  }

  bool isSelected(i) {
    for (var s in _selectedItems) {
      if (s["name"] == i["name"]) return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!
        .copyWith(color: theme.colorScheme.secondary, fontSize: 40);
    //int selectedItem = 0;

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: theme.colorScheme.primary,
          centerTitle: true,
          title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'weare',
                  style: style,
                  textAlign: TextAlign.center,
                ),
                Image.asset('assets/logo.png', scale: 6),
                Text(
                  'olunteenz',
                  style: style,
                  textAlign: TextAlign.center,
                ),
              ]),
        ),
        body: FutureBuilder<Map<String, dynamic>>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isNotEmpty && orgItems.isEmpty) {
                  orgItems = List.from(snapshot.data!["orgs"]);
                }
                return Column(children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: Container(
                        padding: const EdgeInsets.all(8.0),
                        color: theme.colorScheme.primary,
                        child: TextField(
                          onChanged: _handletext,
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.all(0.0),
                            prefixIcon: Icon(Icons.search),
                            filled: true,
                            border: OutlineInputBorder(),
                            hintText: 'Search',
                          ),
                        ),
                      )),
                      SizedBox(
                        width: 150,
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          color: theme.colorScheme.primary,
                          child: TextField(
                            onChanged: _handleloc,
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.all(2.0),
                              prefixIcon: Icon(Icons.room),
                              filled: true,
                              border: OutlineInputBorder(),
                              hintText: 'Location',
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(
                    height: 40,
                    color: theme.colorScheme.secondary,
                    child: Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Text("${orgItems.length} total",
                                style: const TextStyle(fontSize: 18),
                                textAlign: TextAlign.center),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                                ((searchText.isEmpty && locText.isEmpty)
                                    ? '${orgItems.length} matched'
                                    : '${_results.length} matched'),
                                style: const TextStyle(fontSize: 18),
                                textAlign: TextAlign.center),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: ElevatedButton.icon(
                                label: Text(
                                  "${_selectedItems.length} picked",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: (_selectedItems.isEmpty
                                        ? FontWeight.normal
                                        : FontWeight.bold),
                                    color: (_selectedItems.isEmpty
                                        ? Colors.black
                                        : theme.colorScheme.primary),
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor:
                                        theme.colorScheme.secondary,
                                    padding: const EdgeInsets.all(2),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0))),
                                onPressed: () {
                                  if (_selectedItems.isEmpty) return;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MessagePage(
                                          selectedItems: _selectedItems),
                                    ),
                                  );
                                },
                                icon: Icon(Icons.mail,
                                    color: (_selectedItems.isEmpty
                                        ? theme.colorScheme.secondary
                                        : Colors.black))),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: orgItems.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : RefreshIndicator(
                            onRefresh: _refresh,
                            child: ListView.builder(
                              itemCount:
                                  ((searchText.isEmpty && locText.isEmpty)
                                          ? orgItems
                                          : _results)
                                      .length,
                              itemBuilder: (BuildContext context, int index) {
                                List items = [];
                                if (searchText.isEmpty && locText.isEmpty) {
                                  items = orgItems;
                                } else {
                                  items = _results;
                                }
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 8, left: 8, right: 8),
                                  child: ListTile(
                                    shape: const RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Colors.black, width: 1),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(5),
                                            topRight: Radius.circular(5),
                                            bottomRight: Radius.circular(5),
                                            bottomLeft: Radius.circular(5))),
                                    tileColor: theme.colorScheme.background,
                                    selectedTileColor:
                                        theme.colorScheme.tertiary,
                                    selectedColor: Colors.black,
                                    trailing: TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                OrgInfo(orgItem: items[index]),
                                          ),
                                        );
                                      },
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                      ),
                                      child: const Text('ⓘ',
                                          style: TextStyle(
                                            fontSize: 24,
                                          )),
                                    ),
                                    title: Text(items[index]["name"]),
                                    contentPadding:
                                        const EdgeInsets.only(left: 10),
                                    visualDensity: const VisualDensity(
                                        horizontal: 0, vertical: -4),
                                    selected: isSelected(items[index]),
                                    onTap: () {
                                      setState(() {
                                        if (isSelected(items[index])) {
                                          _selectedItems.remove(items[index]);
                                        } else {
                                          _selectedItems.add(items[index]);
                                        }
                                      });
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                  ))
                ]);
              } else if (snapshot.hasError) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('An error occured ${snapshot.error.toString()}')
                  ],
                );
              }
              return const Center(child: CircularProgressIndicator());
            }));
  }
}

class OrgInfo extends StatelessWidget {
  // In the constructor, require a Todo.
  const OrgInfo({super.key, required this.orgItem});

  // Declare a field that holds the Todo.
  final Map<String, dynamic> orgItem;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        title: const Text('Organization Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          // scrollDirection: Axis.horizontal,
          child: Column(
            children: [
              Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const Text('Name',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                        softWrap: true),
                    Text(orgItem["name"] + '\n',
                        textAlign: TextAlign.left, softWrap: true),
                    const Text('Catagories',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left),
                    // Text(item.info.join(', ')+'\n'),
                    Wrap(
                        spacing: 6.0,
                        runSpacing: 6.0,
                        children:
                            List.generate(orgItem["info"].length, (index) {
                          return Chip(
                            visualDensity: const VisualDensity(
                                vertical: -4, horizontal: -4),
                            label: Text(orgItem["info"][index]),
                            backgroundColor: theme.colorScheme.secondary,
                            padding: const EdgeInsets.only(
                                top: 0, left: 2, right: 2, bottom: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            side: const BorderSide(style: BorderStyle.none),
                          );
                        })),
                    const Text('\nAddress',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                        softWrap: true),
                    Text(orgItem["address"] + "\n",
                        textAlign: TextAlign.left, softWrap: true),
                    const Text('Website',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                        softWrap: true),

                    TextButton(
                      onPressed: () async {
                        Uri url = Uri.parse(orgItem["website"]);
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url); //forceWebView is true now
                        } else {
                          // ignore: use_build_context_synchronously
                          showSnackBar('Could not open website', context,
                              theme.colorScheme.error);
                        }
                      },
                      style: TextButton.styleFrom(
                        /*
                              backgroundColor:
                                  const Color.fromARGB(255, 219, 219, 219),
                                  */
                        padding: EdgeInsets.zero,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          orgItem["website"] + '\n',
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ),
                    const Text('Email',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                        softWrap: true),
                    Text(orgItem["email"],
                        textAlign: TextAlign.left, softWrap: true),
                  ]),
            ],
          ),
        ),
      ),
    );
  }
}

class OppInfo extends StatelessWidget {
  const OppInfo({super.key, required this.oppItems});

  // Declare a field that holds the Todo.
  final Map<String, dynamic> oppItems;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        title: const Text('Opportunity Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          // scrollDirection: Axis.horizontal,
          child: Column(
            children: [
              Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const Text('Organization',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                        softWrap: true),
                    Text(oppItems["org"] + '\n',
                        textAlign: TextAlign.left, softWrap: true),
                    const Text('Opportunity',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left),
                    // Text(item.info.join(', ')+'\n'),
                    TextButton(
                      onPressed: () async {
                        Uri url = Uri.parse(oppItems["link"]);
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url); //forceWebView is true now
                        } else {
                          // ignore: use_build_context_synchronously
                          showSnackBar('Could not open website', context,
                              theme.colorScheme.error);
                        }
                      },
                      style: TextButton.styleFrom(
                        /*
                              backgroundColor:
                                  const Color.fromARGB(255, 219, 219, 219),
                                  */
                        padding: EdgeInsets.zero,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          oppItems["opp"] + ' [Apply ↗️]\n',
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ),
                    const Text('Start Date',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                        softWrap: true),
                    Text(
                        oppItems["dateStart"].isEmpty
                            ? ""
                            : "${DateFormat("EEE, MMM-d-yyyy, h:mm a").format(DateTime.parse(oppItems["dateStart"]).toLocal())}\n",
                        textAlign: TextAlign.left,
                        softWrap: true),
                    const Text('End Date',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                        softWrap: true),
                    Text(
                        oppItems["dateEnd"].isEmpty
                            ? ""
                            : "${DateFormat("EEE, MMM-d-yyyy, h:mm a").format(DateTime.parse(oppItems["dateEnd"]).toLocal())}\n",
                        textAlign: TextAlign.left,
                        softWrap: true),
                    const Text('Requirements',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                        softWrap: true),
                    Text(oppItems["requirements"].join("\n") + "\n",
                        textAlign: TextAlign.left, softWrap: true),
                    const Text('Training',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                        softWrap: true),
                    Text(oppItems["training"] + "\n",
                        textAlign: TextAlign.left, softWrap: true),
                    const Text('Openings',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                        softWrap: true),
                    Text(oppItems["openings"],
                        textAlign: TextAlign.left, softWrap: true),
                    const Text('Location',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                        softWrap: true),
                    Text(oppItems["location"] + "\n",
                        textAlign: TextAlign.left, softWrap: true),
                    const Text('Description',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                        softWrap: true),
                    Text(oppItems["description"].join("\n") + "\n",
                        textAlign: TextAlign.left, softWrap: true),
                  ]),
            ],
          ),
        ),
      ),
    );
  }
}

class MessagePage extends StatefulWidget {
  @override
  const MessagePage({super.key, required this.selectedItems});

  final List selectedItems;

  @override
  State<MessagePage> createState() =>
      // ignore: no_logic_in_create_state
      _MessagePageState(selectedItems: selectedItems);
}

class _MessagePageState extends State<MessagePage> {
  @override
  _MessagePageState({required this.selectedItems});

  final List selectedItems;

  String msgBody = '';
  String msgSubj = '';
  String filePath = '';

  void _handleBody(String input) {
    setState(() {
      msgBody = input;
    });
  }

  void _handleSubj(String input) {
    setState(() {
      msgSubj = input;
    });
  }

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        // allowedExtensions: ['jpg', 'pdf', 'doc'],
        );

    if (result != null && result.files.single.path != null) {
      /// Load result and file details
      //PlatformFile file = result.files.first;
      File file = File(result.files.single.path!);

      // https://github.com/miguelpruivo/flutter_file_picker/wiki/FAQ
      // https://github.com/miguelpruivo/flutter_file_picker/issues/301
      Directory directory = await getApplicationDocumentsDirectory();
      String dir = "${directory.path}/${result.files.first.name}";
      try {
        // This will try first to just rename the file if they are on the same directory,
        await file.rename(dir);
      } on FileSystemException {
        // if the rename method fails, it will copy the original file to the new directory and then delete the original file
        await file.copy(dir);
        await file.delete();
      }
      setState(() {
        filePath = dir;
      });
    } else {
      /// User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        title: const Text('Message'),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              color: theme.colorScheme.background,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: _handleSubj,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Subject',
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: theme.colorScheme.background,
                  child: TextField(
                    onChanged: _handleBody,
                    maxLines: null, // Set this
                    expands: true,
                    keyboardType: TextInputType.multiline,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter message here',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: theme.colorScheme.primary,
        child: Row(
          children: [
            SizedBox(
              width: 70,
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.secondary,
                  ),
                  child: filePath.isEmpty
                      ? const Icon(Icons.note_add_outlined, color: Colors.black)
                      : const Icon(Icons.task_outlined, color: Colors.black),
                  onPressed: () {
                    _pickFile();
                  },
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.secondary,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Send Gmail",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: (msgBody.isEmpty || msgSubj.isEmpty)
                                  ? Colors.grey
                                  : Colors.black)),
                    ],
                  ),
                  onPressed: () async {
                    if (!(msgBody.isEmpty || msgSubj.isEmpty)) {
                      await sendEmail();
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ),
            Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: ElevatedButton(
                      onPressed: () {
                        GoogleSignInApi.signOut();
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Signout",
                              style: TextStyle(
                                  fontFamily: 'Roboto', color: Colors.black)),
                        ],
                      ),
                    )))
          ],
        ),
      ),
    );
  }

  Future<void> testingEmail(String from, result, String to) async {
    final theme = Theme.of(context);
    var content = '''
Content-Type: multipart/mixed; boundary="foo_bar_baz"
MIME-Version: 1.0
From: $from
To: $to
Subject: $msgSubj

--foo_bar_baz
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

$msgBody

''';

    if (filePath.isNotEmpty) {
      try {
        File fileRes = File(filePath);
        String fileInBase64 = base64Encode(await fileRes.readAsBytes());

        final mimeType = lookupMimeType(filePath);
        final fileName = filePath.split('/').last;
        content = '''$content
--foo_bar_baz
Content-Type: $mimeType
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="$fileName"

$fileInBase64

''';
        await fileRes.delete();
      } catch (err) {
        showSnackBar(err.toString(), context, theme.colorScheme.error);
        return;
      }
    }
    content = ''' $content
--foo_bar_baz--
''';

    var bytes = utf8.encode(content);
    var base64 = base64Encode(bytes);
    var body = json.encode({'raw': base64});

    String url =
        'https://www.googleapis.com/gmail/v1/users/$from/messages/send';

    final http.Response response = await http.post(Uri.parse(url),
        headers: {
          'Authorization': result['Authorization'],
          'X-Goog-AuthUser': result['X-Goog-AuthUser'],
          'Accept': 'application/json',
          'Content-type': 'application/json'
        },
        body: body);
    //final Map<String, dynamic> data = json.decode(response.body);

    if (response.statusCode != 200) {
      // ignore: use_build_context_synchronously
      showSnackBar("Failed to send.", context, theme.colorScheme.error);
    } else {
      // ignore: use_build_context_synchronously
      showSnackBar('Successfully sent.', context, theme.colorScheme.error);
    }
  }

  Future sendEmail() async {
    final theme = Theme.of(context);
    final user = await GoogleSignInApi.signin(theme, context);

    if (user == null) {
      // ignore: use_build_context_synchronously
      showSnackBar(
          'Google authentication failed', context, theme.colorScheme.error);
      return;
    }
    final auth = await user.authHeaders;

    var i = 0;
    for (var s in selectedItems) {
      try {
        await testingEmail(user.email, auth, s["email"]);
        // ignore: use_build_context_synchronously
        sendUsageData(context, 'emailed', s["name"]);
        i = i + 1;
      } on MailerException catch (e) {
        // ignore: use_build_context_synchronously
        showSnackBar(e.toString(), context, theme.colorScheme.error);
      }
    }
    if (i == selectedItems.length) {
      // ignore: use_build_context_synchronously
      showSnackBar('Sent all emails', context, theme.colorScheme.secondary);
    } else {
      // ignore: use_build_context_synchronously
      showSnackBar('Sent $i of ${selectedItems.length} emails', context,
          theme.colorScheme.error);
    }
  }
}

void showSnackBar(String text, context, color) {
  final snackBar = SnackBar(
    content:
        Text(text, style: const TextStyle(fontSize: 20, color: Colors.black)),
    backgroundColor: color,
  );

  ScaffoldMessenger.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(snackBar);
}

class GoogleSignInApi {
  static final _googleSignIn =
      GoogleSignIn(scopes: ['https://www.googleapis.com/auth/gmail.send']);

  static Future<GoogleSignInAccount?> signin(theme, context) async {
    Widget buildPopupDialog(BuildContext context) {
      final theme = Theme.of(context);
      return AlertDialog(
        title: const Text('Please sign into Google to allow sending Gmails',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
            )),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
                bottomRight: Radius.circular(5),
                bottomLeft: Radius.circular(5))),
        backgroundColor: theme.colorScheme.background,
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[],
        ),
        actions: <Widget>[
          Center(
            child: ElevatedButton(
              onPressed: () async {
                final user = await _googleSignIn.signIn();
                // ignore: use_build_context_synchronously
                Navigator.pop(context, user);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                      'assets/google_signin_buttons/ios/3x/btn_google_light_normal_ios@3x.png',
                      scale: 4),
                  const Text('Sign in with Google',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14,
                      ))
                ],
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.secondary),
                  child: const Text('Cancel')),
            ),
          ),
        ],
      );
    }

    if (await _googleSignIn.isSignedIn() && _googleSignIn.currentUser != null) {
      showSnackBar('Signed in: ${_googleSignIn.currentUser?.displayName}',
          context, theme.colorScheme.secondary);
      return _googleSignIn.currentUser;
    } else {
      try {
        final user = await showDialog(
          context: context,
          builder: (BuildContext context) => buildPopupDialog(context),
        );
        return user;
      } catch (err) {
        showSnackBar(err.toString(), context, theme.colorScheme.error);
        return null;
      }
    }
  }

  static Future signOut() => _googleSignIn.signOut();
}
