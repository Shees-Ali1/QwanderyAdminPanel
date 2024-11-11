// import 'dart:html' as html;
//
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
//
// class EventCategories extends StatefulWidget {
//   const EventCategories({Key? key}) : super(key: key);
//
//   @override
//   State<EventCategories> createState() => _EventCategoriesState();
// }
//
// class _EventCategoriesState extends State<EventCategories> {
//   List<Map<String, dynamic>> categories = [];
//   final FirebaseStorage _storage = FirebaseStorage.instance;
//   String newCategory = '';
//   bool isModified = false;
//   html.File? eventImageFile;
//
//   Stream<List<Map<String, dynamic>>>? _categoriesStream;
//
//   @override
//   void initState() {
//     super.initState();
//     _categoriesStream = FirebaseFirestore.instance
//         .collection('categories')
//         .doc('0Z5MCvrweqyhFRgHdl0n')
//         .snapshots()
//         .map((snapshot) {
//       if (snapshot.exists) {
//         final List<Map<String, dynamic>> fetchedCategories = [];
//         final data = snapshot.data();
//         if (data != null && data.containsKey('categories')) {
//           final List<dynamic> categoryList = data['categories'];
//           categoryList.forEach((category) {
//             fetchedCategories.add({
//               'name': category['name'],
//               'image': category['image'],
//             });
//           });
//         } else {
//           print('Categories data is null or does not contain the "categories" key');
//         }
//         return fetchedCategories;
//       } else {
//         print('Categories document does not exist');
//         return [];
//       }
//     });
//   }
//
//   void _fetchCategoriesFromFirestore() async {
//     try {
//       // Get a reference to the categories document with the specified ID
//       DocumentSnapshot categoriesDocSnapshot = await FirebaseFirestore.instance.collection('categories').doc('0Z5MCvrweqyhFRgHdl0n').get();
//
//       // Check if the document exists
//       if (categoriesDocSnapshot.exists) {
//         // Extract categories from the document
//         List<Map<String, dynamic>> fetchedCategories = []; // Update to list of maps
//
//         // Explicitly cast the value returned by categoriesDocSnapshot.data() to Map<String, dynamic>
//         Map<String, dynamic>? data = categoriesDocSnapshot.data() as Map<String, dynamic>?;
//
//         // Check if data is not null and contains 'categories' key
//         if (data != null && data.containsKey('categories')) {
//           List<dynamic> categoryList = data['categories'];
//           categoryList.forEach((category) {
//             // Add each category as a map to the list
//             fetchedCategories.add({
//               'name': category['name'] , // Assuming 'name' is the key for category name
//               'image': category['image'], // Assuming 'image' is the key for image name
//             });
//           });
//         } else {
//           print('Categories data is null or does not contain the "categories" key');
//         }
//
//         // Update the categories list and rebuild the widget
//         setState(() {
//           categories = fetchedCategories;
//         });
//       } else {
//         print('Categories document does not exist');
//       }
//     } catch (error) {
//       print('Failed to fetch categories: $error');
//     }
//   }
//
//
//
//   Future<void> _uploadCategoriesToFirestore() async {
//     try {
//       DocumentReference categoriesDocRef = FirebaseFirestore.instance.collection('categories').doc('0Z5MCvrweqyhFRgHdl0n');
//
//       List<Map<String, dynamic>> categoriesList = [];
//
//       categories.forEach((category) {
//         categoriesList.add(category); // Add category directly, assuming category is already in the correct format
//       });
//
//       await categoriesDocRef.set({'categories': categoriesList});
//
//
//       // Show a success message
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Categories uploaded to Firestore ---------------'),
//           duration: Duration(seconds: 2),
//         ),
//       );
//     } catch (error) {
//       // Show an error message if something goes wrong
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to upload categories: $error'),
//           duration: Duration(seconds: 2),
//         ),
//       );
//     }
//   }
//
//   void _showAddCategoryDialog() async {
//     String imageName = '';
//     String categoryName = ''; // Variable to store the category name
//
//     showDialog(
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (BuildContext context, StateSetter setState) {
//             return AlertDialog(
//               title: Text('Add Category'),
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   TextField(
//                     onChanged: (value) {
//                       categoryName = value; // Store the entered category name
//                     },
//                     decoration: InputDecoration(
//                       hintText: 'Enter category',
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   if (imageName.isNotEmpty)
//                     Text('$imageName'),
//                   SizedBox(height: 20),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text('Select Image:'),
//                       ElevatedButton(
//                         onPressed: () async {
//                           html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
//                           uploadInput.click();
//                           uploadInput.onChange.listen((e) async {
//                             final files = uploadInput.files;
//                             if (files != null && files.isNotEmpty) {
//                               final file = files[0];
//                               setState(() {
//                                 imageName = file.name;
//                               });
//                               final imageUrl = await uploadImageEvents(file);
//                               if (imageUrl != null) {
//                                 // Add category to Firestore with name and image URL
//                                 categories.add({'name': categoryName, 'image': imageUrl});
//                                 await _uploadCategoriesToFirestore();
//                               } else {
//                                 print('Failed to upload image to Firebase Storage');
//                               }
//                             }
//                           });
//                         },
//                         child: Text('Choose Image'),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: Text('Cancel'),
//                 ),
//                 TextButton(
//                   onPressed: () async {
//                     // Upload category to Firestore
//                     await _uploadCategoriesToFirestore();
//                     Navigator.of(context).pop();
//                   },
//                   child: Text('Add'),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
//
//   Future<String> uploadImageEvents(html.File imageFile) async {
//     Reference ref = _storage.ref().child('categories').child(imageFile.name);
//     UploadTask uploadTask = ref.putBlob(imageFile);
//     TaskSnapshot snapshot = await uploadTask;
//     // Get the download URL for the image
//     final downloadURL = await snapshot.ref.getDownloadURL();
//     return downloadURL;
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color.fromRGBO(43, 41, 41, 1),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 5),
//             child: Text(
//               'Categories',
//               style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w700),
//             ),
//           ),
//           SizedBox(height: 10,),
//           StreamBuilder<List<Map<String, dynamic>>>(
//             stream: _categoriesStream,
//             builder: (context, snapshot) {
//               if (snapshot.hasError) {
//                 return Text('Error: ${snapshot.error}');
//               }
//
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return CircularProgressIndicator(); // or any loading indicator
//               }
//
//               final categories = snapshot.data ?? [];
//
//               return Expanded(
//                 child: Wrap(
//                   spacing: 25,
//                   runSpacing: 20,
//                   children: categories.map((category) {
//                     return GestureDetector(
//                       onTap: () {
//                         // Handle category selection
//                       },
//                       child: Column(
//                         children: [
//                           Image.network(
//                             category['image'] ?? '', // Assuming 'image' is the key for the image URL
//                             width: 100,
//                             height: 100,
//                           ),
//                           SizedBox(height: 8),
//                           Text(
//                             category['name'] ?? '', // Accessing the 'name' key of the category map
//                             style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
//                           ),
//                         ],
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               );
//             },
//           ),
//
//
//
//
//
//
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               ElevatedButton(
//                 onPressed: _showAddCategoryDialog,
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     children: [
//                       Icon(Icons.add),
//                       Text('Add more'),
//                     ],
//                   ),
//                 ),
//               ),
//               // ElevatedButton(
//               //   onPressed:  _uploadCategoriesToFirestore , // Enable button only when modified
//               //   child: Padding(
//               //     padding: const EdgeInsets.all(8.0),
//               //     child: Text('Upload the Data'),
//               //   ),
//               // ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//
