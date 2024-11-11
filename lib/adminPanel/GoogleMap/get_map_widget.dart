import 'package:flutter/material.dart';
import 'dart:html';
import 'dart:ui_web' as ui;
import 'package:google_maps/google_maps.dart';
import 'package:geolocator/geolocator.dart';
import 'package:web/src/dom/html.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

Widget getMap() {
  // A unique id to name the div element
  String htmlId = "6";

  ui.platformViewRegistry.registerViewFactory(htmlId, (int viewId) {
    final elem = DivElement()
      ..id = htmlId
      ..style.width = "100%"
      ..style.height = "100%"
      ..style.border = "none";

    _getUserLocation().then((latLng) {
      final mapOptions = MapOptions()
        ..zoom = 11
        ..tilt = 90
        ..center = latLng;

      final map = GMap(elem as HTMLElement?, mapOptions);
      Marker(MarkerOptions()
        ..position = latLng
        ..map = map
        ..title = 'My position');
    });

    return elem;
  });

  // creates a platform view for Flutter Web
  return HtmlElementView(
    viewType: htmlId,
  );
}

Future<LatLng> _getUserLocation() async {
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  return LatLng(position.latitude, position.longitude);
}
// class Google extends StatefulWidget {
//
//   const Google({Key? key,}) : super(key: key);
//
//   @override
//   State<Google> createState() => _GoogleState();
// }
//
// class _GoogleState extends State<Google> {
//   TextEditingController controller = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return  Column(
//
//       children: <Widget>[
//         SizedBox(height: 100),
//         placesAutoCompleteTextField(),
//       ],
//     );
//
//   }
//
//   placesAutoCompleteTextField() {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 20),
//       child: GooglePlaceAutoCompleteTextField(
//         textEditingController: controller,
//         googleAPIKey: "AIzaSyCvlE2XcxEXl5B3nrOQkwlkQ4Wnn_8oUPI",
//         inputDecoration: InputDecoration(
//           hintText: "Search your location",
//           border: InputBorder.none,
//           enabledBorder: InputBorder.none,
//         ),
//         debounceTime: 400,
//         countries: ["in", "fr"],
//         isLatLngRequired: true,
//         getPlaceDetailWithLatLng: (Prediction prediction) {
//           print("placeDetails" + prediction.lat.toString());
//         },
//
//         itemClick: (Prediction prediction) {
//           controller.text = prediction.description ?? "";
//           controller.selection = TextSelection.fromPosition(
//               TextPosition(offset: prediction.description?.length ?? 0));
//         },
//         seperatedBuilder: Divider(),
//         containerHorizontalPadding: 10,
//
//         // OPTIONAL// If you want to customize list view item builder
//         itemBuilder: (context, index, Prediction prediction) {
//           return Container(
//             padding: EdgeInsets.all(10),
//             child: Row(
//               children: [
//
//                 SizedBox(
//                   width: 7,
//                 ),
//                 Expanded(child: Text("${prediction.description ?? ""}"))
//               ],
//             ),
//           );
//         },
//
//         isCrossBtnShown: true,
//
//         // default 600 ms ,
//       ),
//     );
//   }
// }

// getPlaceDetailWithLatLng: (Prediction prediction) {
// print("Callback being triggered");
// print("Prediction object: $prediction");
// print("Latitude: ${prediction.lat}, Longitude: ${prediction.lng}");
// },
//
// itemClick: (Prediction prediction) {
// print("Item clicked--------");
// print("Prediction object: $prediction");
// print("Description: ${prediction.description}");
// print("Latitude: ${prediction.lat}, Longitude: ${prediction.lng}");
// controller.text = prediction.description ?? "";
// controller.selection = TextSelection.fromPosition(
// TextPosition(offset: prediction.description?.length ?? 0));
// },
