// import 'package:flutter/material.dart';
// import 'package:google_places_flutter/google_places_flutter.dart';
// import 'package:google_places_flutter/model/prediction.dart';
//
//
// class Google extends StatefulWidget {
//   const Google({super.key});
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
//         children: <Widget>[
//           SizedBox(height: 100),
//           placesAutoCompleteTextField(),
//         ],
//       );
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
//                 Icon(Icons.location_on),
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
//
