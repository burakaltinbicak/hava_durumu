import 'package:flutter/material.dart';

class DailyWeatherCard extends StatelessWidget {
  DailyWeatherCard(
      {super.key,
      required this.icon,
      required this.tempature,
      required this.date});

  final String icon;
  final double tempature;
  final String date;
  @override
  Widget build(BuildContext context) {
    List<String> weekdays = [
      'pazartesi',
      'sali',
      'carsamba',
      'persembe',
      'cuma',
      'cumartesi',
      'pazar'
    ];
    String weekday = weekdays[DateTime.parse(date).weekday - 1];

    return Card(
      color: Colors.transparent,
      child: SizedBox(
        height: 280,
        width: 190,
        child: Column(
          children: <Widget>[
            Image.network('https://openweathermap.org/img/wn/$icon.png'),
            Text(
              "$tempature°C",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text("$weekday")
          ],
        ),
      ),
    );
  }
}
