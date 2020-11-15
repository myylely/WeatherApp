import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:convert';
import 'package:weather_icons/weather_icons.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: ' Weather Application',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MainView createState() => _MainView();

  // The MyHomePage class manages its own stage and create a Stage object from createState() and is called when createState() wants to build the widget.
}

class _MainView extends State<MyHomePage> {
  // _MainView instance creates when createState() is called from previous function. The State class defines build().

  var daysFormat = DateFormat.yMMMd().format(DateTime.now());

  var temp;
  var description;
  var currently;
  var humidity;
  var windSpeed;

  Future getWeather() async {
    http.Response reponse = await http.get(
        'http://api.openweathermap.org/data/2.5/weather?q=Gothenburg&units=metric&appid=f9f435567424ab4a12456beb3799ee0d');
    var weatherData = jsonDecode(reponse.body);
    setState(() {
      this.description = weatherData['weather'][0]['description'];
      this.temp = weatherData['main']['temp'];
      this.currently = weatherData['weather'][0]['main'];
      this.humidity = weatherData['main']['humidity'];
      this.windSpeed = weatherData['wind']['speed'];
    });
  }

  @override
  void initState() {
    super.initState();
    this.getWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height / 2,
            width: double.infinity,
            //color: Colors.amberAccent,
            decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topCenter, colors: [
                Colors.blue[900],
                Colors.blue[700],
                Colors.blue[500],
                Colors.blue[300]
              ]),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 50),
                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    'Göteborg',
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  temp != null ? temp.round().toString() + '°C' : 'Loading',
                  style: TextStyle(
                      fontSize: 40,
                      letterSpacing: 3,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 10),
                Text(currently != null ? currently.toString() : 'Loading'),
                SizedBox(height: 20),
                Text('$daysFormat'),
              ],
            ),
          ),
          Expanded(
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Padding(
                      padding: EdgeInsets.all(5),
                      child: ListView(
                        children: <Widget>[
                          ListTile(
                            leading: BoxedIcon(WeatherIcons.thermometer),
                            title: Text(
                              'Temperature',
                              style: TextStyle(letterSpacing: 2),
                            ),
                            trailing: Text(
                              temp != null
                                  ? temp.round().toString() + '°C'
                                  : 'Loading',
                            ),
                          ),
                          ListTile(
                            leading: BoxedIcon(WeatherIcons.cloud),
                            title: Text(
                              'Weather',
                              style: TextStyle(letterSpacing: 2),
                            ),
                            trailing: Text(description != null
                                ? description.toString()
                                : 'Loading'),
                          ),
                          ListTile(
                            leading: BoxedIcon(WeatherIcons.strong_wind),
                            title: Text(
                              'Wind Speed',
                              style: TextStyle(letterSpacing: 2),
                            ),
                            trailing: Text(windSpeed != null
                                ? windSpeed.round().toString()
                                : 'Loading'),
                          ),
                          ListTile(
                            leading: BoxedIcon(WeatherIcons.humidity),
                            title: Text('Humidity',
                                style: TextStyle(letterSpacing: 2)),
                            trailing: Text(humidity != null
                                ? humidity.round().toString()
                                : 'Loading'),
                          ),
                        ],
                      ))))
        ],
      ),
    );
  }
}
