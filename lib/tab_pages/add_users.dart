import 'dart:typed_data';
import 'dart:html' as html; // For web compatibility
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iw_admin_panel/colors.dart';
import 'package:iw_admin_panel/const/images.dart';
import 'package:iw_admin_panel/const/textstyle.dart';
import 'package:iw_admin_panel/controllers/add_user_controller.dart';
import 'package:iw_admin_panel/sidebar_controller.dart';

class AddUsers extends StatefulWidget {
  const AddUsers({super.key});

  @override
  State<AddUsers> createState() => _AddUsersState();
}

class _AddUsersState extends State<AddUsers> {

  final SidebarController sidebarController = Get.put(SidebarController());
  final AddUserController userVM = Get.put(AddUserController());
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance; // Firebase Storage instance

  Uint8List? _image;

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      setState(() {
        _image = result.files.first.bytes; // Retrieve the image bytes
      });
    }
  }

  Future<void> _registerUser() async {
    userVM.loading.value = true;

    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a profile picture.')),
      );
      userVM.loading.value = false; // Stop loading since no image is selected
      return;
    }

    try {
      // Create user with email and password
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: userVM.emailController.text.trim(),
        password: userVM.passController.text.trim(),
      );

      // Get the created user
      User? user = userCredential.user;

      if (user != null) {
        // Upload the Uint8List data directly to Firebase Storage
        String fileName = 'profile_pictures/${user.uid}.jpg';
        UploadTask uploadTask = _storage.ref(fileName).putData(
          _image!, // Pass the Uint8List directly
          SettableMetadata(contentType: 'image/jpeg'), // Metadata for image
        );
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();

        // Store user details in Firestore under the user's UID
        await _firestore.collection('users').doc(user.uid).set({
          'name': userVM.nameController.text.trim(),
          'email': user.email,
          'bio': '',
          'is_verified': false,
          'phone_number': '',
          'profile_pic': downloadUrl, // Save the download URL of the profile picture
          'joined': Timestamp.now(),
          'followers': [],
          'following': [],
          'favourites': [],
          'events': [],
          'requested': [],
          'location': '',
          'profile_type': 'Public',
          'is_blocked': false,
          'chat_blocked': false,
          "is_deleted": false,
          "created_by": "Admin",
          'uid': user.uid,
        });

        // Update the password for the current user
        await user.updatePassword(userVM.passController.text.trim());
        userVM.loading.value = false;

        userVM.nameController.clear();
        userVM.emailController.clear();
        userVM.passController.clear();
        setState(() {
          _image = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User Created Successfullu')),
        );
        // Navigate to the LoginView screen after successful registration
      }
    } catch (e) {
      userVM.loading.value = false;
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Future<void> createAdmin() async {
    userVM.loading.value = true;

    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a profile picture.')),
      );
      userVM.loading.value = false; // Stop loading since no image is selected
      return;
    }

    try {
      // Create user with email and password
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: userVM.emailController.text.trim(),
        password: userVM.passController.text.trim(),
      );

      // Get the created user
      User? user = userCredential.user;

      if (user != null) {
        // Upload the Uint8List data directly to Firebase Storage
        String fileName = 'profile_pictures/${user.uid}.jpg';
        UploadTask uploadTask = _storage.ref(fileName).putData(
          _image!, // Pass the Uint8List directly
          SettableMetadata(contentType: 'image/jpeg'), // Metadata for image
        );
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();

        // Store admin details in Firestore under the user's UID
        await _firestore.collection('admin').doc(user.uid).set({
          'name': userVM.nameController.text.trim(),
          'email': user.email,
          'bio': '',
          'is_verified': false,
          'phone_number': '',
          'profile_pic': downloadUrl, // Save the download URL of the profile picture
          'joined': Timestamp.now(),
          'followers': [],
          'following': [],
          'favourites': [],
          'events': [],
          'requested': [],
          'location': '',
          'profile_type': 'Public',
          "created_by": "Admin",
          'uid': user.uid,
        });

        // Update the password for the current user
        await user.updatePassword(userVM.passController.text.trim());
        userVM.loading.value = false;

        userVM.nameController.clear();
        userVM.emailController.clear();
        userVM.passController.clear();
        setState(() {
          _image = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Admin Created Successfullu')),
        );
        // Navigate to the LoginView screen after successful registration
      }
    } catch (e) {
      userVM.loading.value = false;
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  html.File uploadImageAsFile(Uint8List imageBytes, String fileName) {
    // Convert Uint8List into a Blob (File equivalent for web)
    final blob = html.Blob([imageBytes]);

    // Create a File object for web
    return html.File([blob], fileName, {'type': 'image/jpeg'});
  }



  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    double headingFont = width <= 425 && width > 375
        ? 14
        : width <= 768 && width > 425
        ? 18
        : width <= 1024 && width >768
        ? 18
        : width <= 1440 && width > 1024
        ? 20
        : width > 1440 && width <= 2570
        ? 26
        : 12;

    double spacing(double width){
      if (width <= 430 && width > 300) return 10;
      if (width <= 768 && width > 430) return 12;
      if (width <= 1024 && width > 768) return 14;
      if (width <= 1440 && width > 1024) return 15;
      if (width <= 2900 && width > 1440) return 20;
      return 15;
    }

    double containerWidth(double width){
      if (width <= 430 && width > 300) return width * .95;
      if (width <= 500 && width > 430) return width * .8;
      if (width <= 768 && width > 500) return width * .7;
      if (width <= 1024 && width > 768) return width * .52;
      if (width <= 1440 && width > 1024) return width * .5;
      if (width <= 1800 && width > 1440) return width * .4;
      if (width <= 2900 && width > 1800) return width * .2;
      return width * .5;
    }


    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [AppColors.blueColor, AppColors.greenbutton])
      ),
      padding: EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: height < 768 ? 10 : 40,
          ),
          child: Container(
            width: containerWidth(width),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Add Profile Picture",
                  style: TextStyle(
                    color: AppColors.backgroundColor,
                    fontSize: headingFont,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 10,),
                Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () => _pickImage(),
                    child: Container(
                      height: 150,
                      width: 240,
                      decoration: BoxDecoration(
                        image: _image != null ? DecorationImage(image: MemoryImage(_image!)): null,
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.secondaryColor
                      ),
                      child: _image == null
                          ? Icon(Icons.image, size: 40, color: AppColors.blueColor,)
                          : SizedBox(),
                    ),
                  ),
                ),
                SizedBox(height: spacing(width)),
                Text('Enter User Name',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: headingFont),),
                const SizedBox(height: 5),
                _buildInputField("User Name", context, userVM.nameController),
                SizedBox(height: spacing(width)),
                Text('Enter User Email',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: headingFont),),
                const SizedBox(height: 5),
                _buildInputField("User Email", context, userVM.emailController),
                SizedBox(height: spacing(width)),
                Text('Select User Role',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: headingFont),),
                const SizedBox(height: 5),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.94, vertical: 5),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(240, 240, 240, 1),
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Obx(
                      ()=> Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                               userVM.role.value,
                               overflow: TextOverflow.ellipsis,
                               style: jost400(headingFont, AppColors.primaryColor),
                            ),
                            GestureDetector(
                            onTap: (){
                              userVM.showRole.value = !userVM.showRole.value;
                            },
                            child: Icon( userVM.showRole.value ? CupertinoIcons.chevron_up : CupertinoIcons.chevron_down, color: Colors.black87, size: 18)),
                          ],
                        ),
                      ),
                     Obx((){
                       if(userVM.showRole.value){
                         return ListView.builder(
                             itemCount: userVM.roles.length,
                             padding: EdgeInsets.zero,
                             shrinkWrap: true,
                             physics: NeverScrollableScrollPhysics(),
                             itemBuilder: (context, index){
                               return Padding(
                                 padding:  EdgeInsets.only(top: index != 0 ? 8.0: 0),
                                 child: GestureDetector(
                                   onTap: (){
                                     userVM.role.value = userVM.roles[index];
                                     userVM.showRole.value = false;
                                   },
                                   child: Text(
                                     userVM.roles[index],
                                     overflow: TextOverflow.ellipsis,
                                     style: jost400(headingFont, AppColors.primaryColor),
                                   ),
                                 ),
                               );
                             });
                       } else {
                         return SizedBox.shrink();
                       }
                     }),
                    ],
                  ),
                ),
                SizedBox(height: spacing(width)),
                Text('Enter User Password',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: headingFont),),
                const SizedBox(height: 5),
                _buildInputField("User Password", context, userVM.passController),
                const SizedBox(height: 30),
                Obx(
                    ()=> GestureDetector(
                    onTap: (){
                      if(userVM.role.value == "User"){
                        _registerUser();
                      } else {
                        createAdmin();
                      }
                    },
                    child: Container(
                      height: 51,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.blueColor, AppColors.lighterBlueColor],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(13),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: userVM.loading.value ? CircularProgressIndicator(color: Colors.white,) :  Text(
                          'Add ${userVM.role.value}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
      String labelText,
      BuildContext context,
      TextEditingController controller, {
        bool isNumber = false,
        int maxLines = 1,
      }) {

    final width = MediaQuery.of(context).size.width;

    double verticalPadding(double width){
      if (width <= 430 && width > 300) return 10;
      if (width <= 768 && width > 430) return 10;
      if (width <= 1024 && width > 768) return 14;
      if (width <= 1440 && width > 1024) return 16;
      if (width <= 2900 && width > 1440) return 16;
      return Get.width * 0.5;
    }

    double horizontalPadding(double width){
      if (width <= 430 && width > 300) return 14;
      if (width <= 768 && width > 430) return 10;
      if (width <= 1024 && width > 768) return 16;
      if (width <= 1440 && width > 1024) return 20;
      if (width <= 2900 && width > 1440) return 20;
      return Get.width * 0.5;
    }

    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: jost400(17, Colors.black),
      decoration: InputDecoration(
        labelText: null, // Removes the label text
        hintText: null,
        isDense: true,// Ensures there's no hint text inside the field
        contentPadding: EdgeInsets.symmetric(vertical: verticalPadding(width), horizontal: horizontalPadding(width)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blueGrey[300]!), // Lighter border color
        ),
        filled: true,
        fillColor: Color.fromRGBO(240, 240, 240, 1), // Lighter background color
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.blueColor), // Focused border color
        ),
      ),
    );
  }

}
