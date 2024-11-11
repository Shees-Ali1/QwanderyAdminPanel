import 'package:flutter/material.dart';
import 'package:flutter_google_places_web/flutter_google_places_web.dart';

const kGoogleApiKey = "AIzaSyCvlE2XcxEXl5B3nrOQkwlkQ4Wnn_8oUPI";


class GooglePlaceholder extends StatefulWidget {

  @override
  _GooglePlaceholderState createState() => _GooglePlaceholderState();
}

class _GooglePlaceholderState extends State<GooglePlaceholder> {
  String test = '';
  @override
  Widget build(BuildContext context) {
    return   Container(
          padding: EdgeInsets.only(top: 150),
          width: 500,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Address autocomplete',
              ),
              FlutterGooglePlacesWeb(
                apiKey: kGoogleApiKey,
                 proxyURL: 'https://cors-anywhere.herokuapp.com/',

                required: true,
              ),
              TextButton(
                onPressed: () {
                  print(FlutterGooglePlacesWeb.value['name']); // '1600 Amphitheatre Parkway, Mountain View, CA, USA'
                  print(FlutterGooglePlacesWeb.value['streetAddress']); // '1600 Amphitheatre Parkway'
                  print(FlutterGooglePlacesWeb.value['city']); // 'CA'
                  print(FlutterGooglePlacesWeb.value['country']);
                  setState(() {
                    test = FlutterGooglePlacesWeb.value['name'] ?? '';
                  });
                },
                child: Text('Press to test'),
              ),
              Text(test),
            ],
          ),
        );


  }
}