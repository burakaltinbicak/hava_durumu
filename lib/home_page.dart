import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hava_durumu/daily_weather_card.dart';
import 'package:http/http.dart' as http;
import 'home_page copy.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String location = 'sydney';
  double? tempature;
  final String key = 'd0f9efec41c0ebff92760d9f4d31a462';
  var locationdata;
  String code = 'c';
  Position? deviceposition;

  String? icon;
  List<String> icons = [];
  List<double> tempatures = [];
  List<String> dates = [];

  Future<void> getlocationdatafromapi() async {
    locationdata = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$location&appid=$key&units=metric'));
    final locationdataparsed = jsonDecode(locationdata.body);

    setState(() {
      tempature = locationdataparsed['main']["temp"];
      location = locationdataparsed['name'];
      code = locationdataparsed['weather'].first['main'];
      icon = locationdataparsed['weather'].first['icon'];
    });
  }

  Future<void> getlocationdatafromapibylatlon() async {
    if (deviceposition != null) {
      locationdata = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?lat=${deviceposition!.latitude}&lon=${deviceposition!.longitude}&appid=$key&units=metric'));
      final locationdataparsed = jsonDecode(locationdata.body);

      setState(() {
        tempature = locationdataparsed['main']["temp"];
        location = locationdataparsed['name'];
        code = locationdataparsed['weather'].first['main'];
        icon = locationdataparsed['weather'].first['icon'];
      });
    }
  }

  Future<void> getdeviceposition() async {
    try {
      deviceposition = await _determinePosition();
    } catch (error) {
      print("şu hata oluştu $error");
    }

    print(deviceposition);
  }

  Future<void> getdailyforecastbylatlon() async {
    var forecast = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?lat=${deviceposition!.latitude}&lon=${deviceposition!.longitude}&appid=$key&units=metric'));
    var forecastdataparsed = jsonDecode(forecast.body);
    print(
        "'https://api.openweathermap.org/data/2.5/forecast?lat=${deviceposition!.latitude}&lon=${deviceposition!.longitude}&appid=$key&units=metric'");
    tempatures.clear();
    icons.clear();
    dates.clear();

    setState(() {
      tempatures.add(forecastdataparsed['list'][7]['main']['temp']);
      tempatures.add(forecastdataparsed['list'][15]['main']['temp']);
      tempatures.add(forecastdataparsed['list'][23]['main']['temp']);
      tempatures.add(forecastdataparsed['list'][31]['main']['temp']);
      tempatures.add(forecastdataparsed['list'][39]['main']['temp']);

      icons.add(forecastdataparsed['list'][7]['weather'][0]['icon']);
      icons.add(forecastdataparsed['list'][15]['weather'][0]['icon']);
      icons.add(forecastdataparsed['list'][23]['weather'][0]['icon']);
      icons.add(forecastdataparsed['list'][31]['weather'][0]['icon']);
      icons.add(forecastdataparsed['list'][39]['weather'][0]['icon']);

      dates.add(forecastdataparsed['list'][7]['dt_txt']);
      dates.add(forecastdataparsed['list'][15]['dt_txt']);
      dates.add(forecastdataparsed['list'][23]['dt_txt']);
      dates.add(forecastdataparsed['list'][31]['dt_txt']);
      dates.add(forecastdataparsed['list'][39]['dt_txt']);
    });
  }

  Future<void> getdailyforecastbylocation() async {
    var forecast = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?q=$location&appid=$key&units=metric'));
    var forecastdataparsed = jsonDecode(forecast.body);

    tempatures.clear();
    icons.clear();
    dates.clear();

    setState(() {
      tempatures.add(forecastdataparsed['list'][7]['main']['temp']);
      tempatures.add(forecastdataparsed['list'][15]['main']['temp']);
      tempatures.add(forecastdataparsed['list'][23]['main']['temp']);
      tempatures.add(forecastdataparsed['list'][31]['main']['temp']);
      tempatures.add(forecastdataparsed['list'][39]['main']['temp']);

      icons.add(forecastdataparsed['list'][7]['weather'][0]['icon']);
      icons.add(forecastdataparsed['list'][15]['weather'][0]['icon']);
      icons.add(forecastdataparsed['list'][23]['weather'][0]['icon']);
      icons.add(forecastdataparsed['list'][31]['weather'][0]['icon']);
      icons.add(forecastdataparsed['list'][39]['weather'][0]['icon']);

      dates.add(forecastdataparsed['list'][7]['dt_txt']);
      dates.add(forecastdataparsed['list'][15]['dt_txt']);
      dates.add(forecastdataparsed['list'][23]['dt_txt']);
      dates.add(forecastdataparsed['list'][31]['dt_txt']);
      dates.add(forecastdataparsed['list'][39]['dt_txt']);
    });
  }

  void getInitialData() async {
    await getdeviceposition();
    await getlocationdatafromapibylatlon();
    await getdailyforecastbylatlon();
  }

  @override
  void initState() {
    getInitialData();
    //getlocationdatafromapi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/$code.jpg'), fit: BoxFit.cover),
      ),
      child: (tempature == null ||
              deviceposition == null ||
              icons.isEmpty ||
              dates.isEmpty ||
              tempatures.isEmpty)
          ? Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    Text('please wait retrieving weather data')
                  ],
                ),
              ),
            )
          : Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //   OutlinedButton(
                    //   onPressed: () async {
                    //    print('getlocationdata cagrilmadan önce : $locationdata');
                    //   await getlocationdata();
                    //   debugPrint(
                    //       'getlocationdata cagrilmadan sonra : $locationdata');

                    //   final locationdataparsed = jsonDecode(locationdata.body);

                    //  print(locationdataparsed);
                    //  print(locationdataparsed.runtimeType);
                    //   },
                    //  child: Text('getlocationdata')),
                    SizedBox(
                      height: 50,
                      child: Image.network(
                          'https://openweathermap.org/img/wn/$icon@2x.png'),
                    ),
                    Text(
                      "$tempature°C",
                      style: const TextStyle(
                          fontSize: 70, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          location,
                          style: const TextStyle(fontSize: 30),
                        ),
                        IconButton(
                            onPressed: () async {
                              final selectedcity = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SearchPage()));
                              location = selectedcity;
                              getlocationdatafromapi();
                              getdailyforecastbylocation();
                            },
                            icon: const Icon(Icons.search))
                      ],
                    ),
                    buildweathercards(
                        icons: icons, dates: dates, tempatures: tempatures)
                  ],
                ),
              ),
            ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}

class buildweathercards extends StatelessWidget {
  const buildweathercards({
    super.key,
    required this.icons,
    required this.dates,
    required this.tempatures,
  });

  final List<String> icons;
  final List<String> dates;
  final List<double> tempatures;

  @override
  Widget build(BuildContext context) {
    List<DailyWeatherCard> cards =
        []; /*[
          DailyWeatherCard(
            icon: icons[0],
            date: dates[0],
            tempature: tempatures[0],
          ),
          DailyWeatherCard(
            icon: icons[1],
            date: dates[1],
            tempature: tempatures[1],
          ),
          DailyWeatherCard(
            icon: icons[2],
            date: dates[2],
            tempature: tempatures[2],
          ),
          DailyWeatherCard(
            icon: icons[3],
            date: dates[3],
            tempature: tempatures[3],
          ),
          DailyWeatherCard(
            icon: icons[4],
            date: dates[4],
            tempature: tempatures[4],
          ),
        ];*/
    for (int i = 0; i < 5; i++) {
      cards.add(DailyWeatherCard(
          icon: icons[i], tempature: tempatures[i], date: dates[i]));
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.15,
      width: MediaQuery.of(context).size.width * 0.9,
      child: ListView(scrollDirection: Axis.horizontal, children: cards),
    );
  }
}
