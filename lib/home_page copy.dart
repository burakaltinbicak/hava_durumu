// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String selectedcity = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/search.jpg'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: TextField(
                  onChanged: (value) {
                    selectedcity = value;
                  },
                  decoration: InputDecoration(
                      hintText: ' Şehir Seçiniz',
                      border: OutlineInputBorder(borderSide: BorderSide.none)),
                  style: TextStyle(fontSize: 30),
                  textAlign: TextAlign.center,
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    var response = await http.get(Uri.parse(
                        'https://api.openweathermap.org/data/2.5/weather?q=$selectedcity&appid=d0f9efec41c0ebff92760d9f4d31a462&units=metric'));
                    if (response.statusCode == 200) {
                      Navigator.pop(context, selectedcity);
                    } else {
                      _showMyDialog();
                    }
                  },
                  child: const Text('Select City'))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Location not Found.'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Please select a valid location.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
